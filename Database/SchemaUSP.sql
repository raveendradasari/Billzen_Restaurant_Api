/****** Object:  StoredProcedure [dbo].[usp_adjustCompanyAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_adjustCompanyAccount]
(
@credit_debit int,
@payment_head nvarchar(max),
@paid_amount decimal(18,2),
@debit_account bigint,
@payment_mode nvarchar(max),
@payment_reference nvarchar(max)
)
AS
BEGIN

	BEGIN TRY
		DECLARE @balance decimal(18,2)
		DECLARE @new_balance decimal(18,2)

		IF @credit_debit = 1
		BEGIN
			--Credit 
			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance+@paid_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@debit_account,(SELECT GETDATE()),@payment_head+' [Manual]','Manuall',@payment_reference,@paid_amount,0,@new_balance)

		END
		ELSE IF @credit_debit = 2
		BEGIN
			--Credit 
			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance-@paid_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@debit_account,(SELECT GETDATE()),@payment_head+' [Manual]','Manuall',@payment_reference,0,@paid_amount,@new_balance)
		END

		SELECT 1 as 'status', 'Account has been manually adjusted successfuly.' as message 

	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed updating mannual update into the account.'+ERROR_MESSAGE() as message 
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_deleteCompanyAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deleteCompanyAccount]
(
@id bigint
)
AS
BEGIN
	BEGIN TRY
		
	    DECLARE @balance decimal(18,2)
		DECLARE @prev_opening_balance decimal(18,2)
		SET @prev_opening_balance = (SELECT opening_balance FROM tbl_CompanyAccount WHERE id=@id)

		UPDATE tbl_CompanyAccount SET 
			isDeleted=1
		WHERE id=@id

		--Removed from Company Account entry
		SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @id ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		SET @balance = (@balance-@prev_opening_balance)
		INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@id,(SELECT GETDATE()),'Opening Balance Deleted','Opening Balance Revoked','-',0,@prev_opening_balance,@balance)
		
		
		SELECT 1 as 'status', 'Company Account removed successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Removing Company Account. Please try again' as message
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_deleteCompositionAndWastage]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_deleteCompositionAndWastage](
@composition_id bigint
)
AS
BEGIN
	BEGIN TRY
		delete from tbl_CompositionAndWastage where id=@composition_id
		SELECT 1 as 'status', 'Selected composition and wastage deleted successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed deleting the selected composition and wastage. Please try again' as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteCustomerAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_deleteCustomerAccount]
@id bigint
AS
BEGIN
		UPDATE tbl_customerAccounts SET IsDeleted = 1 WHERE id=@id
		SELECT 1 as 'status', 'Customer Account Deleted successfully.' as message
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteExpenditure]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deleteExpenditure]
(
@id bigint,
@prev_total_amount decimal(18,2)
)
AS
BEGIN
		BEGIN TRY
			DECLARE @balance decimal(18,2)
			DECLARE @new_balance decimal(18,2)
			DECLARE @prev_debit_account bigint
			DECLARE @prev_payment_head nvarchar(max)
			DECLARE @prev_payment_mode nvarchar(max)
			DECLARE @prev_payment_reference nvarchar(max)

			SET @prev_debit_account = (SELECT debit_account FROM tbl_expenditures WHERE id=@id)
			SET @prev_payment_head = (SELECT payment_head FROM tbl_expenditures WHERE id=@id)
			SET @prev_payment_mode = (SELECT payment_mode FROM tbl_expenditures WHERE id=@id)
			SET @prev_payment_reference = (SELECT payment_reference FROM tbl_expenditures WHERE id=@id)

			UPDATE tbl_Expenditures SET 
				isDeleted=1
			WHERE id=@id

			--Removed from Company Account entry
			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @prev_debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance+@prev_total_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@prev_debit_account,(SELECT GETDATE()),'Expenditure Revoked(Deleted) - '+@prev_payment_head+'','Expenditure Revoked',''+@prev_payment_mode+' - '+@prev_payment_reference+'',@prev_total_amount,0,@new_balance)
		


			SELECT 1 as 'status', 'Expenditure removed successfully.' as message
		END TRY
		BEGIN CATCH
			SELECT 0 as 'status', 'Failed removing Expenditure. Please try again' as message
		END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_deletePinnedShortcut]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deletePinnedShortcut]
(
@id bigint
)
AS
BEGIN
	BEGIN TRY
		
	  
		UPDATE tbl_PinnedShortcuts SET 
			isDeleted=1
		WHERE id=@id

		
		SELECT 1 as 'status', 'Unpinned successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed unpinning the shortcut. Please try again' as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteProductionEntryByEntryId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deleteProductionEntryByEntryId]
(
@id bigint
)
AS
BEGIN

	BEGIN TRY
		update tbl_Productions set isDeleted = 1 where id=@id

		DECLARE @sale_product_id bigint
		DECLARE @production_quantity decimal(18,2)

		SET @sale_product_id = (SELECT sale_product_id FROM tbl_Productions WHERE id=@id)
		SET @production_quantity = (SELECT production_quantity FROM tbl_Productions WHERE id=@id)

		-- Manage Sale Product Stock
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_SaleProductStock WHERE item_id=@sale_product_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		SET @balance_quantity = (@balance_quantity-@production_quantity)
			INSERT INTO tbl_SaleProductStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@sale_product_id,(SELECT GETDATE()), 'Production Entry Revoked',0,@production_quantity,@balance_quantity)


		SELECT 1 as 'status', 'Production Entry deleted successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Error on deleting production entry. Please try again.' as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteProductionUnit]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_deleteProductionUnit]
(
@id bigint
)
AS
BEGIN
		BEGIN TRY
			UPDATE tbl_ProductionUnitsAndCapacity SET 
				isDeleted=1
			WHERE id=@id

			SELECT 1 as 'status', 'Production Unit removed successfully.' as message
		END TRY
		BEGIN CATCH
			SELECT 0 as 'status', 'Failed removing Production Unit. Please try again' as message
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deletePurchaseOrder]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deletePurchaseOrder]
(
@purchaseorder_id bigint
)
AS
BEGIN
	BEGIN TRY
		update tbl_PurchaseOrder set isDeleted = 1 where id=@purchaseorder_id
		SELECT 1 as 'status', 'Purchase order deleted successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Error on deleting purchase order. Please try again.' as message
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteRawMaterial]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_deleteRawMaterial]
(
@id bigint
)
AS
BEGIN
		BEGIN TRY
			UPDATE tbl_RawMaterials SET 
				isDeleted=1
			WHERE id=@id

			SELECT 1 as 'status', 'Item removed successfully.' as message
		END TRY
		BEGIN CATCH
			SELECT 0 as 'status', 'Failed removing item. Please try again' as message
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteSaleProduct]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deleteSaleProduct]
(
@id bigint
)
AS
BEGIN
		BEGIN TRY
			UPDATE tbl_SaleProducts SET 
				isDeleted=1
			WHERE id=@id

			SELECT 1 as 'status', 'Item removed successfully.' as message
		END TRY
		BEGIN CATCH
			SELECT 0 as 'status', 'Failed removing item. Please try again' as message
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteSalesOrder]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deleteSalesOrder]
(
@salesorder_id bigint
)
AS
BEGIN
	BEGIN TRY
		update tbl_salesOrder set isDeleted = 1 where id=@salesorder_id
		SELECT 1 as 'status', 'Sales order deleted successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Error on deleting sales order. Please try again.' as message
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteSupplierAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_deleteSupplierAccount]
@id bigint
AS
BEGIN
		UPDATE tbl_supplierAccounts SET IsDeleted = 1 WHERE id=@id
		SELECT 1 as 'status', 'Supplier Account Deleted successfully.' as message
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteUser]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_deleteUser]
(
@id bigint
)
AS
BEGIN
	BEGIN TRY
		
	  
		UPDATE tbl_Users SET 
			isDeleted=1
		WHERE id=@id

		
		SELECT 1 as 'status', 'User has been removed successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Removing user. Please try again' as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_deleteWastage]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_deleteWastage]
(
@id bigint
)
AS
BEGIN
		BEGIN TRY
			UPDATE tbl_Wastages SET 
				isDeleted=1
			WHERE id=@id

			SELECT 1 as 'status', 'Item removed successfully.' as message
		END TRY
		BEGIN CATCH
			SELECT 0 as 'status', 'Failed removing item. Please try again' as message
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAccountStatements]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getAccountStatements]
(
@startDate date,
@endDate date,
@account_id bigint
)
AS
BEGIN
	
	select a.id,a.account_id,b.account_title,a.date,a.payment_head,a.operation,a.reference,a.credit,a.debit,a.balance
	from tbl_CompanyPassbook a JOIN tbl_CompanyAccount b on a.account_id=b.id 
	where b.isDeleted=0 AND account_id=@account_id AND date>=@startDate AND date<=@endDate
	ORDER BY ID DESC
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getActivityLog]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getActivityLog](
@login_id nvarchar(max)='0'
)
AS
BEGIN
	IF @login_id != '0'
	BEGIN
		SELECT id,date, action_performer_name,action_performer_login_id,action_title,action_content from tbl_ActivityLog where action_performer_login_id=@login_id order by id desc
	END
	ELSE
	BEGIN
		SELECT id,date, action_performer_name,action_performer_login_id,action_title,action_content from tbl_ActivityLog order by id desc
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCompanyAccounts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getAllCompanyAccounts]
AS
BEGIN
	
	select id,account_title,account_number,account_type,account_ifsc_code,opening_balance,
	COALESCE((select top 1 balance from tbl_CompanyPassbook where account_id=a.id ORDER BY id desc),0) as balance,
	is_default
	from tbl_CompanyAccount a where a.isDeleted=0 order by a.account_title asc
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllPurchaseOrders]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[usp_getAllPurchaseOrders]
 (
 @startDate date,
 @endDate date
 )
 AS

BEGIN

SELECT a.id,b.supplier_name,a.invoice_no,a.purchase_date,a.raw_materials,a.delivery_status,a.payment_status 
from tbl_PurchaseOrder a JOIN tbl_SupplierAccounts b ON a.supplier_id=b.id WHERE a.isDeleted=0 AND b.isDeleted=0 
AND a.purchase_date>=@startDate AND a.purchase_date<=@endDate 
order by a.id desc
option (maxrecursion 0) 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllRawMaterials]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getAllRawMaterials]
AS
BEGIN
	
	SELECT a.id,a.item_name,a.description as item_description,a.item_type,a.item_group,b.name as item_unit,a.rate as item_rate,(select name from tbl_Gst where id=a.gst AND isDeleted=0) as item_gst_name, (select rate from tbl_Gst where id=a.gst AND isDeleted=0) as item_gst_rate 
	FROM tbl_RawMaterials a JOIN tbl_Units b on a.unit=b.id
	WHERE a.isDeleted = 0 AND b.isDeleted = 0 order by a.id desc option (maxrecursion 0)

	SELECT name from tbl_Units order by name asc option (maxrecursion 0)

	SELECT name,rate from tbl_Gst order by name asc option (maxrecursion 0)

END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSaleProducts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getAllSaleProducts]
AS
BEGIN
	
	SELECT a.id,a.item_name,a.description as item_description,a.item_type,a.item_group,b.name as item_unit,a.rate as item_rate,(select name from tbl_Gst where id=a.gst AND isDeleted=0) as item_gst_name, (select rate from tbl_Gst where id=a.gst AND isDeleted=0) as item_gst_rate 
	FROM tbl_SaleProducts a JOIN tbl_Units b on a.unit=b.id
	WHERE a.isDeleted = 0 AND b.isDeleted = 0 order by a.id desc option (maxrecursion 0)

	SELECT name from tbl_Units order by name asc option (maxrecursion 0)

	SELECT name,rate from tbl_Gst order by name asc option (maxrecursion 0)

END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSalesOrders]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getAllSalesOrders]
 (
 @startDate date=null,
@endDate date=null
 )
 AS

BEGIN
if @startDate is null
BEGIN
SELECT a.id,b.customer_name,a.invoice_no,a.sales_date,a.sale_products,a.delivery_status,a.payment_status 
from tbl_salesOrder a JOIN tbl_customerAccounts b ON a.customer_id=b.id WHERE a.isDeleted=0 AND b.isDeleted=0 order by a.id desc  option (maxrecursion 0)
END
ELSE
BEGIN
SELECT a.id,b.customer_name,a.invoice_no,a.sales_date,a.sale_products,a.delivery_status,a.payment_status 
from tbl_salesOrder a JOIN tbl_customerAccounts b ON a.customer_id=b.id WHERE a.isDeleted=0 AND a.sales_date>= @startDate AND a.sales_date<= @endDate  AND b.isDeleted=0 order by a.id desc  option (maxrecursion 0)
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllWastages]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getAllWastages]
AS
BEGIN

SELECT a.id,a.item_name,a.description as item_description,a.item_type,a.item_group,b.name as item_unit,a.rate as item_rate,(select name from tbl_Gst where id=a.gst AND isDeleted=0) as item_gst_name, (select rate from tbl_Gst where id=a.gst AND isDeleted=0) as item_gst_rate 
	FROM tbl_Wastages a JOIN tbl_Units b on a.unit=b.id
	WHERE a.isDeleted = 0 AND b.isDeleted = 0 order by a.id desc option (maxrecursion 0)

END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCompositionAndWastageBySaleProductId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCompositionAndWastageBySaleProductId]
(
@sale_product_item_id bigint
)
AS
BEGIN

	SELECT id,sale_product_id, raw_material_id,(select item_name from tbl_RawMaterials where id= raw_material_id and isDeleted=0) as item_name,
	wastage_id,(select item_name from tbl_Wastages where id= wastage_id and isDeleted=0) as waste_name,
	(SELECT b.name from tbl_RawMaterials a JOIN tbl_Units b ON a.unit=b.id where a.id=raw_material_id) as item_unit,
	(SELECT b.name from tbl_Wastages a JOIN tbl_Units b ON a.unit=b.id where a.id=wastage_id) as waste_unit,
	utilize_quantity,wastage_quantity FROM tbl_CompositionAndWastage WHERE sale_product_id = @sale_product_item_id AND isDeleted=0
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCompositionBySaleProductId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCompositionBySaleProductId]
(
@sale_product_id bigint
)
AS
BEGIN
	SELECT id,raw_material_id,wastage_id,utilize_quantity,wastage_quantity FROM tbl_CompositionAndWastage WHERE sale_product_id=@sale_product_id AND isDeleted=0
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCustomerPaymentBycustomerId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCustomerPaymentBycustomerId]
(
@customer_id bigint,
@startDate date,
@endDate date
)
AS
BEGIN
if @startDate is null
	BEGIN
		SELECT  id,customer_id,date,payment_head,operation,reference,credit,debit,balance FROM tbl_customerPassbook WHERE customer_id= @customer_id ORDER BY id DESC
		option (maxrecursion 0)
	END
ELSE
	BEGIN
		SELECT  id,customer_id,date,payment_head,operation,reference,credit,debit,balance FROM tbl_customerPassbook WHERE customer_id= @customer_id AND date>=@startDate AND date<=@endDate ORDER BY id DESC
		option (maxrecursion 0)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCustomerPaymentByInvoice]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCustomerPaymentByInvoice]
(
@invoice_no nvarchar(max)
)
AS
BEGIN

DECLARE @invoice_string nvarchar(max)
SET @invoice_string = 'INVOICE :'+@invoice_no

SELECT  id,customer_id,date,payment_head,operation,reference,credit,debit,balance FROM tbl_customerPassbook WHERE operation=''+@invoice_string+'' ORDER BY id DESC
option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCustomersAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCustomersAccount]
@id bigint
AS
BEGIN
	if @id = 0
	BEGIN
		SELECT id,customer_name,poc_name,email,phone,fax,mobile,whatsapp,website,address,gst_registration_type,gstin,pan_or_tan,bank_account_number,opening_balance,as_of,terms,notes,date_of_registration,
		(select top 1 balance from tbl_CustomerPassbook where customer_id=a.id order by id desc) as balance,
		(select count(*) from tbl_SalesOrder where customer_id = a.id and isDeleted=0 group by customer_id) as total_orders
		FROM tbl_customerAccounts a WHERE isDeleted=0 ORDER BY id DESC
		option (maxrecursion 0)
	END
	else
	BEGIN
		SELECT id,customer_name,poc_name,email,phone,fax,mobile,whatsapp,website,address,gst_registration_type,gstin,pan_or_tan,bank_account_number,opening_balance,as_of,terms,notes,date_of_registration,
		(select top 1 balance from tbl_CustomerPassbook where customer_id=a.id order by id desc) as balance,
		(select count(*) from tbl_SalesOrder where customer_id = a.id and isDeleted=0 group by customer_id) as total_orders
		FROM tbl_customerAccounts a WHERE isDeleted=0 AND id=@id ORDER BY id DESC
		option (maxrecursion 0)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getDistinctExpenditure]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getDistinctExpenditure]
AS
BEGIN
	SELECT DISTINCT payment_head from tbl_expenditures WHERE isDeleted=0 option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getExpenditure]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getExpenditure]
(
@id bigint = 0,
@startDate date,
@endDate date
)
AS
BEGIN
	IF @id = 0
	BEGIN
		SELECT a.id,a.payment_head,a.description,a.payment_reference,a.date,a.amount,
		a.gst_id,
		(select name from tbl_Gst where id=a.gst_id and isDeleted=0) as gst_name,
		(select rate from tbl_Gst where id=a.gst_id and isDeleted=0) as gst_rate,
		a.is_regular_expenditure,
		debit_account,
		payment_mode,
		(SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.isDeleted=0 AND date>=@startDate AND date<=@endDate  order by a.id desc
		option (maxrecursion 0)
	END
	ELSE
	BEGIN
		SELECT a.id,a.payment_head,a.description,a.payment_reference,a.date,a.amount,
		a.gst_id,
		(select name from tbl_Gst where id=a.gst_id and isDeleted=0) as gst_name,
		(select rate from tbl_Gst where id=a.gst_id and isDeleted=0) as gst_rate,
		a.is_regular_expenditure,
		debit_account,
		payment_mode,
		(SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.id=@id AND a.isDeleted=0  AND date>=@startDate AND date<=@endDate order by a.id desc
		option (maxrecursion 0)
	END
END

--exec usp_getExpenditure 0,'2021-06-27','2021-06-30'
GO
/****** Object:  StoredProcedure [dbo].[usp_getExpenditureSummary]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getExpenditureSummary]
(
@startDate date,
@endDate date
)
AS
BEGIN
	DECLARE @total_amount decimal(18,2)
	DECLARE @total_count int
	DECLARE @total_regular_amount decimal(18,2)
	DECLARE @total_regular_count int
	DECLARE @total_irregular_amount decimal(18,2)
	DECLARE @total_irregular_count int
	DECLARE @maximum_expenditure_head nvarchar(max)
	DECLARE @maximum_expenditure_head_amount decimal(18,2)

	SET @total_amount = (SELECT SUM(b.total_amount) FROM (SELECT (SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.isDeleted=0 and date>=@startDate AND date<=@endDate ) b)

	SET @total_count =	(SELECT COUNT(b.payment_head) as total_count  FROM (SELECT payment_head, count(id) as count FROM tbl_expenditures a WHERE a.isDeleted=0 and date>=@startDate AND date<=@endDate GROUP BY payment_head) b)

	SET @total_regular_amount = (SELECT SUM(b.total_amount) FROM (SELECT (SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.isDeleted=0 AND a.is_regular_expenditure=1 and date>=@startDate AND date<=@endDate ) b)

	SET @total_regular_count =	(SELECT COUNT(b.payment_head) as total_count  FROM (SELECT payment_head, count(id) as count FROM tbl_expenditures a WHERE a.isDeleted=0 AND a.is_regular_expenditure=1 and date>=@startDate AND date<=@endDate  GROUP BY payment_head) b)

	SET @total_irregular_amount = (SELECT SUM(b.total_amount) FROM (SELECT (SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.isDeleted=0 AND a.is_regular_expenditure=0 and date>=@startDate AND date<=@endDate ) b)

	SET @total_irregular_count =	(SELECT COUNT(b.payment_head) as total_count  FROM (SELECT payment_head, count(id) as count FROM tbl_expenditures a WHERE a.isDeleted=0 AND a.is_regular_expenditure=0  and date>=@startDate AND date<=@endDate GROUP BY payment_head) b)

	SET @maximum_expenditure_head = (SELECT top 1 b.payment_head FROM (SELECT a.payment_head, (SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.isDeleted=0 and date>=@startDate AND date<=@endDate ) b ORDER BY b.total_amount DESC)

	SET @maximum_expenditure_head_amount = (SELECT top 1 b.total_amount FROM (SELECT a.payment_head, (SELECT (a.amount+((a.amount * COALESCE((select rate from tbl_Gst where id=a.gst_id and isDeleted=0),0) )/100))) as total_amount
		FROM tbl_expenditures a WHERE a.isDeleted=0 and date>=@startDate AND date<=@endDate ) b ORDER BY b.total_amount DESC)

	SELECT COALESCE(@total_amount,0) as total_amount,
			 COALESCE(@total_count,0) as total_count,
			 COALESCE(@total_regular_amount,0) as total_regular_amount,
			 COALESCE(@total_regular_count,0) as total_regular_count,
			 COALESCE(@total_irregular_amount,0) as total_irregular_amount,
			 COALESCE(@total_irregular_count,0) as total_irregular_count,
			 @maximum_expenditure_head as maximum_expenditure_head,
			 COALESCE(@maximum_expenditure_head_amount,0) as maximum_expenditure_head_amount
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getFY]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getFY]
AS
BEGIN
	SELECT id, display_name,start_day,start_month,end_day,end_month from tbl_FY option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getGst]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getGst]
AS
BEGIN
	SELECT id,name,rate from tbl_Gst WHERE isDeleted=0  option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getHistoryByRawmaterialId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getHistoryByRawmaterialId]
(
@item_id bigint
)
AS
BEGIN
	SELECT id,date,reference,in_quantity,out_quantity,balance_quantity from tbl_RawMaterialStock WHERE item_id=@item_id ORDER BY id DESC option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getHistoryBySaleProductId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getHistoryBySaleProductId]
(
@item_id bigint
)
AS
BEGIN
	SELECT id,date,reference,in_quantity,out_quantity,balance_quantity from tbl_SaleProductStock WHERE item_id=@item_id ORDER BY id DESC option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getHistoryByWastageId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getHistoryByWastageId]
(
@item_id bigint
)
AS
BEGIN
	SELECT id,date,reference,in_quantity,out_quantity,balance_quantity from tbl_WastageStock WHERE item_id=@item_id ORDER BY id DESC
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getItemGroups]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getItemGroups]
AS
BEGIN
	SELECT DISTINCT item_group FROM tbl_RawMaterials WHERE isDeleted=0 ORDER BY item_group DESC option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getItemGroupsSaleProduct]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getItemGroupsSaleProduct]
AS
BEGIN
	SELECT DISTINCT item_group FROM tbl_SaleProducts WHERE isDeleted=0 ORDER BY item_group DESC
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getItemGroupsWastage]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getItemGroupsWastage]
AS
BEGIN
	SELECT DISTINCT item_group FROM tbl_Wastages WHERE isDeleted=0 ORDER BY item_group DESC option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getLastPurchasedRawMaterials]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getLastPurchasedRawMaterials]
(
	@supplier_id bigint
)
AS
BEGIN
	SELECT top 1 raw_materials FROM [tbl_PurchaseOrder] WHERE supplier_id=@supplier_id AND isDeleted=0 ORDER BY id DESC 
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getLastSalesSaleProducts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getLastSalesSaleProducts]
(
	@customer_id bigint
)
AS
BEGIN
	SELECT top 1 sale_products FROM [tbl_salesOrder] WHERE customer_id=@customer_id AND isDeleted=0 ORDER BY id DESC 
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getLatestProductionsByProductionUnitId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getLatestProductionsByProductionUnitId]
(
@production_unit_id bigint
)
AS
BEGIN
	DECLARE @lastDate date
	SET @lastDate = (SELECT top 1 date from tbl_Productions WHERE production_unit_id=@production_unit_id AND isDeleted=0 ORDER by date desc)
	SELECT id,date,production_unit_id,functioning_hours,sale_product_id,production_quantity
	FROM tbl_Productions WHERE production_unit_id=@production_unit_id AND isDeleted=0 AND date=@lastDate ORDER by date desc
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getNoticifactions]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getNoticifactions]
AS
BEGIN
	SELECT top 20 id,date,message,is_important,isDeleted FROM tbl_Notifications
	ORDER BY id desc
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getPinnedShortcutsByLoginId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getPinnedShortcutsByLoginId](
@login_id nvarchar(max)
)
AS
BEGIN

select id,login_id,shortcut_title,shortcut_url,shortcut_icon from tbl_PinnedShortcuts where login_id=@login_id and isDeleted=0 order by shortcut_title asc
option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getProductionCalendar]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getProductionCalendar]
(
@production_unit_id bigint=0,
@sale_product_id bigint=0
)
AS
BEGIN

	DECLARE @TempData TABLE
	(
		 id bigint, 
		 date date, 
		 production_unit_id bigint,
		 sale_product_name nvarchar(max),
		 prod_group nvarchar(max),
		 production_quantity decimal(18,2)
	)

	if(@sale_product_id >0)
	BEGIN
		INSERT INTO @TempData	
		SELECT id, date,production_unit_id,(select item_name from tbl_SaleProducts where id=sale_product_id) as sale_product_name,
		(select item_group from tbl_SaleProducts where id=sale_product_id) as prod_group,production_quantity
		from tbl_Productions where isDeleted=0 AND sale_product_id=@sale_product_id AND production_unit_id=@production_unit_id
		option (maxrecursion 0)
	END
	else
	BEGIN
		INSERT INTO @TempData	
		SELECT id, date,production_unit_id,(select item_name from tbl_SaleProducts where id=sale_product_id) as sale_product_name,
		(select item_group from tbl_SaleProducts where id=sale_product_id) as prod_group,production_quantity
		from tbl_Productions where isDeleted=0 AND production_unit_id=@production_unit_id
		option (maxrecursion 0)
	END

	DECLARE @OutputProd TABLE
	(
		 date date, 
		 group_name nvarchar(max),
		 quantity decimal(18,2)
	)
	insert into @OutputProd select date,prod_group,sum(production_quantity) as production_quantity from @TempData group by date,prod_group

	--select * from @OutputProd

	DECLARE @OutputFull TABLE
	(
		 date date, 
		 group_name nvarchar(max),
		 quantity decimal(18,2),
		 flag nvarchar(max)
	)
	insert into @OutputFull (date,group_name,quantity,flag) select date, group_name,quantity,'Production' from @OutputProd

	select * from @OutputFull order by flag asc option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getProductionsByDate]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getProductionsByDate]
(
@production_unit_id bigint=0,
@date date
)
AS
BEGIN
	if(@production_unit_id >0)
		BEGIN
			SELECT id, date,production_unit_id,functioning_hours,(select item_name from tbl_SaleProducts where id=sale_product_id) as sale_product_name,
			(select item_group from tbl_SaleProducts where id=sale_product_id) as prod_group,
			(select a.name from tbl_Units a JOIN tbl_SaleProducts b ON a.id=b.unit where b.id=sale_product_id) as prod_unit_name,
			production_quantity
			from tbl_Productions where isDeleted=0 AND production_unit_id=@production_unit_id AND date = @date option (maxrecursion 0)
		END
		else
		BEGIN
			SELECT id, date,production_unit_id,functioning_hours,(select item_name from tbl_SaleProducts where id=sale_product_id) as sale_product_name,
			(select item_group from tbl_SaleProducts where id=sale_product_id) as prod_group,
			(select a.name from tbl_Units a JOIN tbl_SaleProducts b ON a.id=b.unit where b.id=sale_product_id) as prod_unit_name,
			production_quantity
			from tbl_Productions where isDeleted=0 AND date = @date option (maxrecursion 0)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getProductionUnitsAndCapacity]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getProductionUnitsAndCapacity]
(
@id bigint=0
)
AS
BEGIN
	IF @id=0
	BEGIN
		SELECT id,unit_name,unit_description,production_capacity_per_hour from tbl_ProductionUnitsAndCapacity where isDeleted=0 option (maxrecursion 0)
	END
	ELSE
	BEGIN
		SELECT id,unit_name,unit_description,production_capacity_per_hour from tbl_ProductionUnitsAndCapacity where isDeleted=0 AND id=@id option (maxrecursion 0)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getPurchaseOrderById]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getPurchaseOrderById]  
(  
 @id bigint  
)  
AS  
BEGIN  
  
select a.id,a.supplier_id,b.supplier_name,b.gstin as supplier_gstin, a.invoice_no, a.purchase_date,a.email,a.whatsapp,a.shipping_via,a.supplier_mailing_address,a.shipping_to,a.memo,a.message_to_spplier,a.raw_materials,a.delivery_status,a.payment_status,b.terms   
  
from tbl_PurchaseOrder a JOIN tbl_SupplierAccounts b ON a.supplier_id =b.id WHERE a.id=@id AND a.isDeleted=0 and b.isDeleted=0 order by a.id desc  
option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getRawMaterialsByPurchaseOrderId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getRawMaterialsByPurchaseOrderId]
(
@id bigint
)
AS
BEGIN
	SELECT raw_materials,delivery_status FROM tbl_PurchaseOrder WHERE id=@id AND isDeleted=0
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getRawMaterialStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getRawMaterialStock]
AS
BEGIN
	SELECT a.id,a.item_name,a.description as item_description,a.item_type,a.item_group,a.unit as unit_id,(select name from tbl_Units where id=a.unit and isDeleted=0) as unit_name,a.rate,(select name from tbl_Gst where id=a.gst and isDeleted=0) as gst_name,(select rate from tbl_Gst where id=a.gst and isDeleted=0) as gst_rate,a.low_stock_alert,
	(select top 1 balance_quantity from tbl_RawMaterialStock where item_id=a.id ORDER BY id desc) as balance_quantity FROM tbl_RawMaterials a WHERE a.isDeleted=0 ORDER BY a.item_name ASC
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getRawMaterialSummary]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getRawMaterialSummary]
AS
BEGIN
DECLARE @low_stock int
DECLARE @out_of_stock int
DECLARE @sufficient_stock int

DECLARE @TempReport TABLE
	(low_stock_alert int, 
	 balance_quantity int
	)
INSERT INTO @TempReport	
SELECT a.low_stock_alert,(select top 1 balance_quantity from tbl_RawMaterialStock where item_id=a.id ORDER BY id desc) as balance_quantity FROM tbl_RawMaterials a WHERE isDeleted=0

SET @out_of_stock = (SELECT COUNT(*) FROM @TempReport WHERE balance_quantity <=0)
SET @low_stock = ((SELECT COUNT(*) FROM @TempReport WHERE balance_quantity <= low_stock_alert)-@out_of_stock )
SET @sufficient_stock = (SELECT COUNT(*) FROM @TempReport WHERE balance_quantity > low_stock_alert)

SELECT @low_stock as low_stock,@out_of_stock as out_of_stock,@sufficient_stock as sufficient_stock

END
GO
/****** Object:  StoredProcedure [dbo].[usp_getRoles]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getRoles]
AS
BEGIN
	SELECT id,role_name,role_description
		FROM tbl_Roles where isDeleted=0 ORDER by role_name ASC option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSaleProductionByProductionId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSaleProductionByProductionId](
@production_id bigint
)
AS
BEGIN
	SELECT id,date,production_unit_id,functioning_hours,sale_product_id,production_quantity
	FROM tbl_Productions WHERE id=@production_id AND isDeleted=0  option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSaleProductsBySalesOrderId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSaleProductsBySalesOrderId]
(
@id bigint
)
AS
BEGIN
	SELECT sale_products,delivery_status FROM tbl_salesOrder WHERE id=@id AND isDeleted=0 option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSaleProductStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSaleProductStock]
AS
BEGIN
	SELECT a.id,a.item_name,a.description as item_description,a.item_type,a.item_group,a.unit as unit_id,(select name from tbl_Units where id=a.unit and isDeleted=0) as unit_name,a.rate,(select name from tbl_Gst where id=a.gst and isDeleted=0) as gst_name,(select rate from tbl_Gst where id=a.gst and isDeleted=0) as gst_rate,a.low_stock_alert,
	(select top 1 balance_quantity from tbl_SaleProductStock where item_id=a.id ORDER BY id desc) as balance_quantity FROM tbl_SaleProducts a WHERE a.isDeleted=0 ORDER BY a.item_name ASC
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSaleProductSummary]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSaleProductSummary]
AS
BEGIN
DECLARE @low_stock int
DECLARE @out_of_stock int
DECLARE @sufficient_stock int

DECLARE @TempReport TABLE
	(low_stock_alert int, 
	 balance_quantity int
	)
INSERT INTO @TempReport	
SELECT a.low_stock_alert,(select top 1 balance_quantity from tbl_SaleProductStock where item_id=a.id ORDER BY id desc) as balance_quantity FROM tbl_SaleProducts a WHERE isDeleted=0

SET @out_of_stock = (SELECT COUNT(*) FROM @TempReport WHERE balance_quantity <=0)
SET @low_stock = ((SELECT COUNT(*) FROM @TempReport WHERE balance_quantity <= low_stock_alert)-@out_of_stock )
SET @sufficient_stock = (SELECT COUNT(*) FROM @TempReport WHERE balance_quantity > low_stock_alert)

SELECT @low_stock as low_stock,@out_of_stock as out_of_stock,@sufficient_stock as sufficient_stock

END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSalesOrderById]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSalesOrderById]  
(  
 @id bigint  
)  
AS  
BEGIN  
  
select a.id,a.customer_id,b.customer_name,b.gstin as customer_gstin, a.invoice_no, a.sales_date,a.email,a.whatsapp,a.shipping_via,a.customer_mailing_address,a.shipping_to,a.memo,a.message_to_customer,a.sale_products,a.delivery_status,a.payment_status,b.terms   
  
from tbl_salesOrder a JOIN tbl_customerAccounts b ON a.customer_id =b.id WHERE a.id=@id AND a.isDeleted=0 and b.isDeleted=0 ORDER BY a.id desc  
option (maxrecursion 0) 
END  
GO
/****** Object:  StoredProcedure [dbo].[usp_getSubscriberProfile]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSubscriberProfile]
AS
BEGIN
select top 1 a.id,a.business_name,a.logo_url,a.email,
a.mobile,a.whatsapp,a.website,a.gst_number,a.business_address,a.currency_name,a.currency_symbol,a.invoice_prefix,a.status,a.service_provider_message,
a.fy,b.display_name as fy_display_name,b.start_day,b.start_month,b.end_day,b.end_month,a.default_filter_view_type,a.default_filter_ranger
from 
tbl_SubscriberProfile a join tbl_FY b on a.fy=b.id

END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSupplierPaymentByInvoice]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSupplierPaymentByInvoice]
(
@invoice_no nvarchar(max)
)
AS
BEGIN

DECLARE @invoice_string nvarchar(max)
SET @invoice_string = 'INVOICE :'+@invoice_no

SELECT  id,supplier_id,date,payment_head,operation,reference,credit,debit,balance FROM tbl_SupplierPassbook WHERE operation=''+@invoice_string+'' ORDER BY id DESC
option (maxrecursion 0) 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSupplierPaymentBySupplierId]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_getSupplierPaymentBySupplierId]
(
@startDate date,
@endDate date,
@supplier_id bigint
)
AS
BEGIN


SELECT  id,supplier_id,date,payment_head,operation,reference,credit,debit,balance FROM tbl_SupplierPassbook 
WHERE supplier_id= @supplier_id AND date>=@startDate AND date<=@endDate
ORDER BY id DESC
option (maxrecursion 0)

END

GO
/****** Object:  StoredProcedure [dbo].[usp_getSuppliersAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSuppliersAccount]
@id bigint
AS
BEGIN
	if @id = 0
	BEGIN
		SELECT id,supplier_name,poc_name,email,phone,fax,mobile,whatsapp,website,address,gst_registration_type,gstin,pan_or_tan,bank_account_number,opening_balance,as_of,terms,notes,date_of_registration,
		(select top 1 balance from tbl_SupplierPassbook where supplier_id=a.id order by id desc) as balance,
		(select count(*) from tbl_PurchaseOrder where supplier_id = a.id and isDeleted=0 group by supplier_id) as total_orders
		FROM tbl_supplierAccounts a WHERE isDeleted=0 ORDER BY id DESC
		option (maxrecursion 0)
	END
	else
	BEGIN
		SELECT id,supplier_name,poc_name,email,phone,fax,mobile,whatsapp,website,address,gst_registration_type,gstin,pan_or_tan,bank_account_number,opening_balance,as_of,terms,notes,date_of_registration,
		(select top 1 balance from tbl_SupplierPassbook where supplier_id=a.id order by id desc) as balance,
		(select count(*) from tbl_PurchaseOrder where supplier_id = a.id and isDeleted=0 group by supplier_id) as total_orders
		FROM tbl_supplierAccounts a WHERE isDeleted=0 AND id=@id ORDER BY id DESC
		option (maxrecursion 0)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getUnits]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getUnits]
AS
BEGIN
	SELECT id, name from tbl_Units WHERE isDeleted=0 option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getUsersAndRoles]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getUsersAndRoles]
(
@login_id nvarchar(max)='',
@id bigint = 0
)
AS
BEGIN
   IF @id != 0
	BEGIN
		SELECT a.id,a.login_id,a.password,a.role_id,b.role_name,b.role_description,a.is_active,a.full_name,a.email,a.mobile,a.last_login 
		FROM tbl_Users a JOIN tbl_Roles b ON a.role_id=b.id WHERE a.isDeleted =0 AND b.isDeleted=0 AND a.id = @id  ORDER BY a.full_name ASC
		 option (maxrecursion 0)
	END
	ELSE
	BEGIN
		IF @login_id != ''
		BEGIN
			SELECT a.id,a.login_id,a.password,a.role_id,b.role_name,b.role_description,a.is_active,a.full_name,a.email,a.mobile,a.last_login 
			FROM tbl_Users a JOIN tbl_Roles b ON a.role_id=b.id WHERE a.isDeleted =0 AND b.isDeleted=0 AND a.login_id = @login_id  ORDER BY a.full_name ASC
			 option (maxrecursion 0)
		END
		ELSE
		BEGIN
			SELECT a.id,a.login_id,a.password,a.role_id,b.role_name,b.role_description,a.is_active,a.full_name,a.email,a.mobile,a.last_login 
			FROM tbl_Users a JOIN tbl_Roles b ON a.role_id=b.id WHERE a.isDeleted =0 AND b.isDeleted=0 ORDER BY a.full_name ASC
			 option (maxrecursion 0)
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getWastageStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getWastageStock]
AS
BEGIN
	SELECT a.id,a.item_name,a.description as item_description,a.item_type,a.item_group,a.unit as unit_id,(select name from tbl_Units where id=a.unit and isDeleted=0) as unit_name,a.rate,(select name from tbl_Gst where id=a.gst and isDeleted=0) as gst_name,(select rate from tbl_Gst where id=a.gst and isDeleted=0) as gst_rate,
	(select top 1 balance_quantity from tbl_WastageStock where item_id=a.id ORDER BY id desc) as balance_quantity FROM tbl_Wastages a WHERE a.isDeleted=0 ORDER BY a.item_name ASC
	 option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_login]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_login]
(
@login_id nvarchar(max),
@password nvarchar(max)
)
AS
BEGIN

	IF EXISTS (SELECT * FROM tbl_Users WHERE login_id=@login_id AND isDeleted=0)
		BEGIN
			DECLARE @actual_password nvarchar(max)
			DECLARE @status bit

			SET @status = (SELECT is_active from tbl_Users where login_id=@login_id AND isDeleted=0)
			SET @actual_password = (SELECT password from tbl_Users where login_id=@login_id AND isDeleted=0 AND is_active=1)

			IF @status = 1
				BEGIN
					IF @password = @actual_password
						BEGIN
							--update last login
							update tbl_Users set last_login= (SELECT GETDATE()) WHERE login_id=@login_id AND isDeleted=0
							DECLARE @role_id bigint
							SET @role_id = (SELECT role_id FROM tbl_Users where login_id=@login_id AND isDeleted=0)
							select top 1 a.id,
											a.business_name,
											a.logo_url,
											a.email as business_email,
											a.mobile as business_mobile,
											a.whatsapp as business_whatsapp,
											a.website as business_website,
											a.gst_number,
											a.business_address,
											a.currency_name,
											a.currency_symbol,
											a.invoice_prefix,
											a.status as app_status,
											a.service_provider_message,
											@role_id as role_id,
											(SELECT role_name FROM tbl_Roles where id=@role_id AND isDeleted=0) as role_name,
											(SELECT role_description FROM tbl_Roles where id=@role_id AND isDeleted=0) as role_description,
											(SELECT is_active FROM tbl_Users where login_id=@login_id AND isDeleted=0) as is_active,
											(SELECT full_name FROM tbl_Users where login_id=@login_id AND isDeleted=0) as full_name,
											(SELECT email FROM tbl_Users where login_id=@login_id AND isDeleted=0) as user_email,
											(SELECT mobile FROM tbl_Users where login_id=@login_id AND isDeleted=0) as user_mobile,
											(SELECT last_login FROM tbl_Users where login_id=@login_id AND isDeleted=0) as last_login,
											a.fy,b.display_name as fy_display_name,b.start_day,b.start_month,b.end_day,b.end_month,a.default_filter_view_type,a.default_filter_ranger,
											1 as 'status',
											'success.' as message

							from tbl_SubscriberProfile a join tbl_FY b on a.fy=b.id

						END
					ELSE
						BEGIN
							SELECT 0 as 'status', 'Invalid Password. Please provide your valid password to login.' as message
						END
				END
			ELSE
				BEGIN
					SELECT 0 as 'status', 'Your account has been blocked/disabled. Please contact your administrator.' as message
				END
		
		END
	ELSE
		BEGIN
			SELECT 0 as 'status', 'Invalid Login ID. Please provide your registered login id.' as message
		END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_makeCustomerPayment]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_makeCustomerPayment]
(
@customer_id bigint,
@payment_date date,
@credit_debit int,
@payment_head nvarchar(max),
@paid_amount decimal(18,2),
@debit_account bigint,
@payment_mode nvarchar(max),
@payment_reference nvarchar(max),
@is_company_account_to_update bit
)
AS
BEGIN

	BEGIN TRY
		DECLARE @balance decimal(18,2)
		DECLARE @new_balance decimal(18,2)
		DECLARE @customer_name nvarchar(max)

		SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		IF @credit_debit = 1
		BEGIN
			--Credit - amount taken from customer
			SET @new_balance = (@balance+@paid_amount)
			INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@customer_id,@payment_date,@payment_head,'general action',@payment_reference,@paid_amount,0,@new_balance)

			IF @is_company_account_to_update = 1
			BEGIN
				--Company account
				SET @customer_name =  (select customer_name from tbl_customerAccounts where id = @customer_id)

				SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @new_balance = (@balance-@paid_amount)
				INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@debit_account,@payment_date,'Given to customer - '+@customer_name+'('+@payment_head+')','general',@payment_mode+'-'+@payment_reference,0,@paid_amount,@new_balance)
			END

		END
		ELSE IF @credit_debit = 2
		BEGIN
			--Debit - amount given to customer
			SET @new_balance = (@balance-@paid_amount)
			INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@customer_id,@payment_date,@payment_head,'general',@payment_reference,0,@paid_amount,@new_balance)
			--Company account
			SET @customer_name =  (select customer_name from tbl_customerAccounts where id = @customer_id)

			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance+@paid_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@debit_account,@payment_date,'Payment recieved from customer - '+@customer_name+'('+@payment_head+')','general',@payment_mode+'-'+@payment_reference,@paid_amount,0,@new_balance)
		END

		SELECT 1 as 'status', 'Payment updated successfuly.' as message 

	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed updating payment.'+ERROR_MESSAGE() as message 
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_makeCustomerPaymentBySalesAndInvoice]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_makeCustomerPaymentBySalesAndInvoice]
(
@sales_order_id bigint,
@payment_date date,
@paid_amount decimal(18,2),
@debit_account bigint,
@payment_mode nvarchar(max),
@payment_reference nvarchar(max),
@payment_status int
)
AS
BEGIN

	BEGIN TRY
		UPDATE tbl_salesOrder SET payment_status=@payment_status WHERE id=@sales_order_id
		DECLARE @customer_id bigint
		DECLARE @customer_name nvarchar(max)
		DECLARE @invoice_no nvarchar(max)
		DECLARE @balance decimal(18,2)
		DECLARE @new_balance decimal(18,2)
		DECLARE @invoice_prev_debit_payment decimal(18,2)
		DECLARE @reference_concat nvarchar(max)
		DECLARE @payment_head nvarchar(max)


		SET @customer_id = (select customer_id from tbl_salesOrder where id=@sales_order_id)
		SET @customer_name = (select customer_name from tbl_CustomerAccounts where id=@customer_id AND isDeleted=0)
		SET @invoice_no = (select invoice_no from tbl_salesOrder where id=@sales_order_id)

		IF @payment_status > 0
		BEGIN
			SET @invoice_prev_debit_payment = (SELECT top 1 debit FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

			IF @invoice_prev_debit_payment > 0
			BEGIN
				IF @invoice_prev_debit_payment != @paid_amount
				BEGIN
					--Updating existing entry
					SET @payment_head = 'Invoice Payment - Adjusted'

					SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @reference_concat = (SELECT top 1 reference FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
					
					SET @new_balance = (@balance+@invoice_prev_debit_payment)
					INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@customer_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@invoice_prev_debit_payment,0,@new_balance)

					SET @balance = @new_balance
					SET @new_balance = (@balance-@paid_amount)
					SET @reference_concat = 'Payment Mode-'+@payment_mode+'; Ref-'+@payment_reference

					INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@customer_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@paid_amount,@new_balance)


					--Company account DONE
					SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @new_balance = (@balance-@invoice_prev_debit_payment)
					INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@debit_account,@payment_date,@payment_head+'(Customer-'+@customer_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@invoice_prev_debit_payment,@new_balance)

					SET @balance = @new_balance
					SET @new_balance = (@balance+@paid_amount)
					SET @reference_concat = 'Payment Mode-'+@payment_mode+'; Ref-'+@payment_reference
					INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@debit_account,@payment_date,@payment_head+'(Customer-'+@customer_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@paid_amount,0,@new_balance)
				END
			END
			ELSE
			BEGIN
					--Newly entry of paid/part paid
					SET @payment_head = (SELECT top 1 payment_head FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
					IF (@payment_head is null or @payment_head = '')
					BEGIN
						SET @payment_head = 'Invoice Payment'
					END
					SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @new_balance = (@balance-@paid_amount)
					SET @reference_concat = 'Payment Mode-'+@payment_mode+'; Ref-'+@payment_reference
					INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@customer_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@paid_amount,@new_balance)

					--Company account DONE
					SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @new_balance = (@balance+@paid_amount)
					INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@debit_account,@payment_date,@payment_head+'(Customer-'+@customer_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@paid_amount,0,@new_balance)
			END
		END
		ELSE
		BEGIN

			SET @invoice_prev_debit_payment = (SELECT top 1 debit FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
			IF @invoice_prev_debit_payment > 0
			BEGIN
				--Change back to unpaid
				SET @payment_head = 'Invoice Payment - Adjusted'
				SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @reference_concat = (SELECT top 1 reference FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

				SET @new_balance = (@balance+@invoice_prev_debit_payment)
				INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@customer_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@invoice_prev_debit_payment,0,@new_balance)
				
				--Company account DONE
				SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @new_balance = (@balance-@invoice_prev_debit_payment)
				INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@debit_account,@payment_date,@payment_head+'(Customer-'+@customer_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@invoice_prev_debit_payment,@new_balance)
			END	
		END


		SELECT 1 as 'status', 'Payment status updated successfully.' as message 

	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed updating payment status.'+ERROR_MESSAGE() as message 
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_makeSupplierPayment]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_makeSupplierPayment]
(
@supplier_id bigint,
@payment_date date,
@credit_debit int,
@payment_head nvarchar(max),
@paid_amount decimal(18,2),
@debit_account bigint,
@payment_mode nvarchar(max),
@payment_reference nvarchar(max),
@is_company_account_to_update bit
)
AS
BEGIN

	BEGIN TRY
		DECLARE @balance decimal(18,2)
		DECLARE @new_balance decimal(18,2)
		DECLARE @supplier_name nvarchar(max)

		SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		IF @credit_debit = 1
		BEGIN
			--Credit - amount taken from supplier
			SET @new_balance = (@balance+@paid_amount)
			INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@supplier_id,@payment_date,@payment_head,'general action',@payment_reference,@paid_amount,0,@new_balance)

			IF @is_company_account_to_update = 1
			BEGIN
				--Company account
				SET @supplier_name =  (select supplier_name from tbl_SupplierAccounts where id = @supplier_id)

				SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @new_balance = (@balance+@paid_amount)
				INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@debit_account,@payment_date,'Credit from Supplier - '+@supplier_name+'('+@payment_head+')','general',@payment_reference,@paid_amount,0,@new_balance)
			END

		END
		ELSE IF @credit_debit = 2
		BEGIN
			--Debit - amount given to supplier
			SET @new_balance = (@balance-@paid_amount)
			INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@supplier_id,@payment_date,@payment_head,'general',@payment_reference,0,@paid_amount,@new_balance)
			--Company account
			SET @supplier_name =  (select supplier_name from tbl_SupplierAccounts where id = @supplier_id)

			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance-@paid_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@debit_account,@payment_date,'Payment to Supplier - '+@supplier_name+'('+@payment_head+')','general',@payment_reference,0,@paid_amount,@new_balance)
		END

		SELECT 1 as 'status', 'Payment updated successfuly.' as message 

	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed updating payment.'+ERROR_MESSAGE() as message 
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_makeSupplierPaymentByPurchaseAndInvoice]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_makeSupplierPaymentByPurchaseAndInvoice]
(
@purchase_order_id bigint,
@payment_date date,
@paid_amount decimal(18,2),
@debit_account bigint,
@payment_mode nvarchar(max),
@payment_reference nvarchar(max),
@payment_status int
)
AS
BEGIN

	BEGIN TRY
		UPDATE tbl_PurchaseOrder SET payment_status=@payment_status WHERE id=@purchase_order_id
		DECLARE @supplier_id bigint
		DECLARE @supplier_name nvarchar(max)
		DECLARE @invoice_no nvarchar(max)
		DECLARE @balance decimal(18,2)
		DECLARE @new_balance decimal(18,2)
		DECLARE @invoice_prev_debit_payment decimal(18,2)
		DECLARE @reference_concat nvarchar(max)
		DECLARE @payment_head nvarchar(max)


		SET @supplier_id = (select supplier_id from tbl_PurchaseOrder where id=@purchase_order_id)
		SET @supplier_name = (select supplier_name from tbl_SupplierAccounts where id=@supplier_id AND isDeleted=0)
		SET @invoice_no = (select invoice_no from tbl_PurchaseOrder where id=@purchase_order_id)

		IF @payment_status > 0
		BEGIN
			SET @invoice_prev_debit_payment = (SELECT top 1 debit FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

			IF @invoice_prev_debit_payment > 0
			BEGIN
				IF @invoice_prev_debit_payment != @paid_amount
				BEGIN
					--Updating existing entry
					SET @payment_head = 'Invoice Payment - Adjusted'

					SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @reference_concat = (SELECT top 1 reference FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
					
					SET @new_balance = (@balance+@invoice_prev_debit_payment)
					INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@supplier_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@invoice_prev_debit_payment,0,@new_balance)

					SET @balance = @new_balance
					SET @new_balance = (@balance-@paid_amount)
					SET @reference_concat = 'Payment Mode-'+@payment_mode+'; Ref-'+@payment_reference

					INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@supplier_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@paid_amount,@new_balance)


					--Company account DONE
					SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @new_balance = (@balance+@invoice_prev_debit_payment)
					INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@debit_account,@payment_date,@payment_head+'(Supplier-'+@supplier_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@invoice_prev_debit_payment,0,@new_balance)

					SET @balance = @new_balance
					SET @new_balance = (@balance-@paid_amount)
					SET @reference_concat = 'Payment Mode-'+@payment_mode+'; Ref-'+@payment_reference
					INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@debit_account,@payment_date,@payment_head+'(Supplier-'+@supplier_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@paid_amount,@new_balance)
				END
			END
			ELSE
			BEGIN
					--Newly entry of paid/part paid
					SET @payment_head = (SELECT top 1 payment_head FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
					IF (@payment_head is null or @payment_head = '')
					BEGIN
						SET @payment_head = 'Invoice Payment'
					END
					SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @new_balance = (@balance-@paid_amount)
					SET @reference_concat = 'Payment Mode-'+@payment_mode+'; Ref-'+@payment_reference
					INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@supplier_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@paid_amount,@new_balance)

					--Company account DONE
					SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
					IF (@balance is null)
					BEGIN
						SET @balance = 0
					END
					SET @new_balance = (@balance-@paid_amount)
					INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
								VALUES (@debit_account,@payment_date,@payment_head+'(Supplier-'+@supplier_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,0,@paid_amount,@new_balance)
			END
		END
		ELSE
		BEGIN

			SET @invoice_prev_debit_payment = (SELECT top 1 debit FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
			IF @invoice_prev_debit_payment > 0
			BEGIN
				--Change back to unpaid
				SET @payment_head = 'Invoice Payment - Adjusted'
				SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @reference_concat = (SELECT top 1 reference FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Invoice Payment%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

				SET @new_balance = (@balance+@invoice_prev_debit_payment)
				INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@supplier_id,@payment_date,@payment_head+'(Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@invoice_prev_debit_payment,0,@new_balance)
				
				--Company account DONE
				SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @new_balance = (@balance+@invoice_prev_debit_payment)
				INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@debit_account,@payment_date,@payment_head+'(Supplier-'+@supplier_name+'; Invoice#'+@invoice_no+')','INVOICE :'+@invoice_no,@reference_concat,@invoice_prev_debit_payment,0,@new_balance)
			END	
		END


		SELECT 1 as 'status', 'Payment status updated successfully.' as message 

	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed updating payment status.'+ERROR_MESSAGE() as message 
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_manageRawMaterialStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_manageRawMaterialStock]
(
@item_id bigint,
@in_out int,
@adjust_quantity decimal(18,2),
@reference nvarchar(max)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_RawMaterialStock WHERE item_id=@item_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		IF @in_out = 1
		BEGIN
			SET @balance_quantity = (@balance_quantity+@adjust_quantity)
			INSERT INTO tbl_RawMaterialStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @reference,@adjust_quantity,0,@balance_quantity)
		END
		ELSE
		BEGIN
			SET @balance_quantity = (@balance_quantity-@adjust_quantity)
			INSERT INTO tbl_RawMaterialStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @reference,0,@adjust_quantity,@balance_quantity)
		END

		SELECT 1 as 'status', 'Quantity updated successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Updating Quantity updated. Please try again' as message
	END CATCH
		
END
GO
/****** Object:  StoredProcedure [dbo].[usp_manageRawMaterialStockManually]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_manageRawMaterialStockManually]
(
@item_id bigint,
@in_out int,
@adjust_quantity decimal(18,2)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_RawMaterialStock WHERE item_id=@item_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		IF @in_out = 1
		BEGIN
			SET @balance_quantity = (@balance_quantity+@adjust_quantity)
			INSERT INTO tbl_RawMaterialStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), 'Manual Entry',@adjust_quantity,0,@balance_quantity)
		END
		ELSE
		BEGIN
			SET @balance_quantity = (@balance_quantity-@adjust_quantity)
			INSERT INTO tbl_RawMaterialStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), 'Manual Entry',0,@adjust_quantity,@balance_quantity)
		END

		SELECT 1 as 'status', 'Quantity updated successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Updating Quantity updated. Please try again' as message
	END CATCH
		
END
GO
/****** Object:  StoredProcedure [dbo].[usp_manageSaleProductsStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_manageSaleProductsStock]
(
@item_id bigint,
@in_out int,
@adjust_quantity decimal(18,2),
@reference nvarchar(max)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_SaleProductStock WHERE item_id=@item_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		IF @in_out = 1
		BEGIN
			SET @balance_quantity = (@balance_quantity+@adjust_quantity)
			INSERT INTO tbl_SaleProductStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @reference,@adjust_quantity,0,@balance_quantity)
		END
		ELSE
		BEGIN
			SET @balance_quantity = (@balance_quantity-@adjust_quantity)
			INSERT INTO tbl_SaleProductStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @reference,0,@adjust_quantity,@balance_quantity)
		END

		SELECT 1 as 'status', 'Quantity updated successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Updating Quantity updated. Please try again' as message
	END CATCH
		
END
GO

/****** Object:  StoredProcedure [dbo].[usp_manageSaleProductStockManually]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_manageSaleProductStockManually]
(
@item_id bigint,
@in_out int,
@adjust_quantity decimal(18,2)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_SaleProductStock WHERE item_id=@item_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		IF @in_out = 1
		BEGIN
			SET @balance_quantity = (@balance_quantity+@adjust_quantity)
			INSERT INTO tbl_SaleProductStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), 'Manual Entry',@adjust_quantity,0,@balance_quantity)
		END
		ELSE
		BEGIN
			SET @balance_quantity = (@balance_quantity-@adjust_quantity)
			INSERT INTO tbl_SaleProductStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), 'Manual Entry',0,@adjust_quantity,@balance_quantity)
		END

		SELECT 1 as 'status', 'Quantity updated successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Updating Quantity updated. Please try again' as message
	END CATCH
		
END
GO
/****** Object:  StoredProcedure [dbo].[usp_manageWastageStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_manageWastageStock]
(
@item_id bigint,
@in_out int,
@adjust_quantity decimal(18,2),
@reference nvarchar(max)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_WastageStock WHERE item_id=@item_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		IF @in_out = 1
		BEGIN
			SET @balance_quantity = (@balance_quantity+@adjust_quantity)
			INSERT INTO tbl_WastageStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @reference,@adjust_quantity,0,@balance_quantity)
		END
		ELSE
		BEGIN
			SET @balance_quantity = (@balance_quantity-@adjust_quantity)
			INSERT INTO tbl_WastageStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @reference,0,@adjust_quantity,@balance_quantity)
		END

		SELECT 1 as 'status', 'Quantity updated successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Updating Quantity updated. Please try again' as message
	END CATCH
		
END
GO

/****** Object:  StoredProcedure [dbo].[usp_saveWasteSale]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_saveWasteSale]
(
    @item_id bigint,
	@in_out int,
	@sale_amount  decimal(18,2),
	@comment  nvarchar(max),
	@credit_account bigint,
	@payment_mode nvarchar(max),
	@payment_reference nvarchar(max)
)
AS
BEGIN
    DECLARE @balance decimal(18,2)
    DECLARE @new_balance decimal(18,2)
    DECLARE @item_name nvarchar(max)
	SET @item_name = (select item_name from tbl_Wastages where id=@item_id and isDeleted=0)

	IF @in_out = 1
	BEGIN
		INSERT INTO tbl_WasteSale(date,sale_amount,linked_details,comment) VALUES(
			(SELECT GETDATE()),@sale_amount,@payment_mode+','+@payment_reference,@comment
		)

		--Company Account entry
		SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @credit_account ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		SET @new_balance = (@balance+@sale_amount)
		INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@credit_account,(SELECT GETDATE()),'Wastage Sale. Item- '+@item_name,'Wastage Sale',''+@payment_mode+' - '+@payment_reference+'',@sale_amount,0,@new_balance)
		
		
	END
	ELSE IF @in_out = 2
	BEGIN
		INSERT INTO tbl_WasteSale(date,sale_amount,linked_details,comment) VALUES(
			(SELECT GETDATE()),(@sale_amount*-1),'-',@comment
		)

		--Company Account entry
		SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @credit_account ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		SET @new_balance = (@balance-@sale_amount)
		INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@credit_account,(SELECT GETDATE()),'Wastage Sale Adjusted. Item- '+@item_name,'Wastage Sale','-',0,@sale_amount,@new_balance)
		
	END
END
GO


/****** Object:  StoredProcedure [dbo].[usp_manageWastageStockManually]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_manageWastageStockManually]
(
@item_id bigint,
@in_out int,
@adjust_quantity decimal(18,2),

@is_sale bit = 0,
@adjust_amount decimal(18,2)=0,
@comment nvarchar(max)='-',
@credit_account bigint=0,
@payment_mode nvarchar(max)='-',
@payment_reference nvarchar(max)='-'
)
AS
BEGIN
	BEGIN TRY
	    DECLARE  @new_ref nvarchar(max)
		SET @new_ref ='Manual Entry'

		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_WastageStock WHERE item_id=@item_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		IF @in_out = 1
		BEGIN
			IF @is_sale = 1
			BEGIN
				SET @new_ref = ('Wastage Sold Revoked of Amount - '+CAST(@adjust_amount as varchar(10)))
				EXEC usp_saveWasteSale @item_id,2,@adjust_amount,@comment,@credit_account,@payment_mode, @payment_reference
			END
			SET @balance_quantity = (@balance_quantity+@adjust_quantity)
			INSERT INTO tbl_WastageStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @new_ref,@adjust_quantity,0,@balance_quantity)
		END
		ELSE
		BEGIN
			IF @is_sale = 1
			BEGIN
			    SET @new_ref = 'Wastage Sold of Amount - '+CAST(@adjust_amount as varchar(10))+'. Mode - '+@payment_mode+'-'+@payment_reference
				EXEC usp_saveWasteSale @item_id,1,@adjust_amount,@comment,@credit_account,@payment_mode, @payment_reference
			END
			SET @balance_quantity = (@balance_quantity-@adjust_quantity)
			INSERT INTO tbl_WastageStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()), @new_ref,0,@adjust_quantity,@balance_quantity)
			
		END

		
		SELECT 1 as 'status', 'Quantity updated successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Updating Quantity updated. Please try again.'+ERROR_MESSAGE() as message
	END CATCH
		
END
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Consumers]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Consumers]
(
@startDate date,
@endDate date,
@default_top_or_least_number int=10,
@graph_type nvarchar(20)
)
AS
BEGIN
if @graph_type ='top' OR @graph_type ='least'
BEGIN
	DECLARE @TempSalesPrimary TABLE
	(
		srlno bigint identity(1,1),
		customer_id bigint,
		sale_products nvarchar(max)
	)
	DECLARE @TempSalesSecondary TABLE
	(
		customer_id bigint,
		quantity decimal(18,2)
	)

	INSERT INTO @TempSalesPrimary	
	select customer_id,sale_products from tbl_SalesOrder where isDeleted=0 and delivery_status=2 and sales_date>=@startDate and sales_date<=@endDate ORDER by sales_date asc  option (maxrecursion 0)

		declare @customer_id bigint
		declare @json_input nvarchar(max)
		declare @date_total_quantity decimal(18,2)

		declare @totalrows int = (select count(*) from @TempSalesPrimary)
		declare @currentrow int = 1
		while @currentrow <=  @totalrows  
		begin 
		    
			set @customer_id = (select customer_id from @TempSalesPrimary  where srlno = @currentrow)
			set @json_input = (select sale_products from @TempSalesPrimary  where srlno = @currentrow)
			
			INSERT INTO @TempSalesSecondary
			SELECT @customer_id,quantity
				FROM OPENJSON(@json_input)
					WITH (
					quantity decimal(18,2) '$.item_quantity'
					)
			
			set @currentrow = @currentrow +1
		end  

		--SELECT * FROM @TempSalesSecondary
END
-----------------

if @graph_type ='top'
BEGIN
	select top (@default_top_or_least_number) c.customer_name, c.quantity FROM (
	SELECT b.customer_name as customer_name ,sum(a.quantity) as quantity FROM @TempSalesSecondary a JOIN tbl_CustomerAccounts b ON a.customer_id=b.id
	group by b.customer_name) c ORDER by c.quantity DESC option (maxrecursion 0)
END
else if @graph_type ='least'
BEGIN
	select top (@default_top_or_least_number) c.customer_name, c.quantity FROM (
	SELECT b.customer_name as customer_name ,sum(a.quantity) as quantity FROM @TempSalesSecondary a JOIN tbl_CustomerAccounts b ON a.customer_id=b.id
	group by b.customer_name) c ORDER by c.quantity ASC option (maxrecursion 0)
END
else if @graph_type ='frequent'
BEGIN
	SELECT top (@default_top_or_least_number) b.customer_name,a.sale_count as number  FROM 
	(SELECT customer_id,count(customer_id) as sale_count from tbl_SalesOrder where isDeleted=0 and delivery_status=2 and sales_date>=@startDate and sales_date<=@endDate group by customer_id) a
	JOIN tbl_CustomerAccounts b ON a.customer_id=b.id ORDER by a.sale_count DESC option (maxrecursion 0)
END
	
END
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Expenditure]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Expenditure]
(
@startDate date,
@endDate date
)
AS
BEGIN
   DECLARE @DataTableRegular TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @DataTableIrregular TABLE
	(
		date date,
		amount decimal(18,2)
	)

	INSERT INTO @DataTableRegular	
	SELECT date, sum(amount) as amount FROM tbl_Expenditures WHERE isDeleted=0 and date>=@startDate and date<=@endDate and is_regular_expenditure=1
	GROUP BY date
	option (maxrecursion 0)
	
	--SELECT * from @DataTableRegular

	INSERT INTO @DataTableIrregular	
	SELECT date, sum(amount) as amount FROM tbl_Expenditures WHERE isDeleted=0 and date>=@startDate and date<=@endDate and is_regular_expenditure=0
	GROUP BY date
	option (maxrecursion 0)

	--SELECT * from @DataTableIrregular

	;WITH BlankTable(date) AS
	(
		SELECT @startDate as date
		UNION ALL
		SELECT DATEADD(DAY,1,date)
		FROM BlankTable
		WHERE date < @endDate
	)

	SELECT a.date, 
	COALESCE((select amount from @DataTableRegular where date=a.date),0) as regular,
	COALESCE((select amount from @DataTableIrregular where date=a.date),0) as irregular
	FROM BlankTable a ORDER BY a.date asc
	option (maxrecursion 0)
END

--exec usp_report_Expenditure '2021-01-01','2021-07-31'
--select * from tbl_Expenditures 
--update tbl_Expenditures set payment_head ='Coldrinks for customer 2 Hek' where payment_head ='Coldrinks for customer'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Expenditure_Share]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Expenditure_Share]
(
@startDate date,
@endDate date,
@is_regular bit,
@is_all bit = 0
)
AS
BEGIN
   DECLARE @TempReport TABLE
	(
		name nvarchar(max),
		amount decimal(18,2)
	)
	IF @is_all = 1
	BEGIN
		INSERT INTO @TempReport
		SELECT payment_head as name, SUM(amount) from tbl_Expenditures where isDeleted=0 AND date>=@startDate and date<=@endDate 
		GROUP BY payment_head
		option (maxrecursion 0)
	END
	ELSE
	BEGIN
		INSERT INTO @TempReport
		SELECT payment_head as name, SUM(amount) from tbl_Expenditures where isDeleted=0 AND is_regular_expenditure=@is_regular AND date>=@startDate and date<=@endDate 
		GROUP BY payment_head
		option (maxrecursion 0)
	END
	

	SELECT name,COALESCE(amount,0) as amount from @TempReport option (maxrecursion 0)
END

--exec usp_report_Expenditure_Share '2021-01-01','2021-07-31', 0
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Incoming_Vs_Outgoing_Payment]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Incoming_Vs_Outgoing_Payment]
(
@startDate date,
@endDate date
)
AS
BEGIN
   DECLARE @TempSupplierPayment TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @TempExpenditure TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @TempSales TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @TempWastage TABLE
	(
		date date,
		amount decimal(18,2)
	)

	INSERT INTO @TempSupplierPayment	
	SELECT date, sum(debit) as amount FROM tbl_SupplierPassbook WHERE date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)
	
	INSERT INTO @TempExpenditure	
	SELECT date, sum(amount) as amount FROM tbl_Expenditures WHERE isDeleted=0 AND date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)

	INSERT INTO @TempSales	
	SELECT date, sum(debit) as amount FROM tbl_CustomerPassbook WHERE date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)

	INSERT INTO @TempWastage	
	SELECT date, sum(sale_amount) as amount FROM tbl_WasteSale WHERE isDeleted=0 AND date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)
	
	-- Final Output
	
	;WITH BlankTable(date) AS
	(
		SELECT @startDate as date
		UNION ALL
		SELECT DATEADD(DAY,1,date)
		FROM BlankTable
		WHERE date < @endDate
	)

	SELECT a.date,
	COALESCE((SELECT amount FROM @TempSupplierPayment WHERE date=a.date),0)+COALESCE((SELECT amount FROM @TempExpenditure WHERE date=a.date),0)
	AS outgoing,
	COALESCE((SELECT amount FROM @TempSales WHERE date=a.date),0)+COALESCE((SELECT amount FROM @TempWastage WHERE date=a.date),0)
	AS incoming
	FROM BlankTable a
	option (maxrecursion 0)

END

--exec usp_report_Incoming_Vs_Outgoing_Payment '2021-01-01','2021-07-31'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_OutGoing_Payment_Share]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_OutGoing_Payment_Share]
(
@startDate date,
@endDate date
)
AS
BEGIN
DECLARE @TempReport TABLE
	(
		name nvarchar(max),
		amount decimal(18,2)
	)

	INSERT INTO @TempReport
	SELECT 'Purchase' as name, SUM(debit) from tbl_SupplierPassbook where date>=@startDate and date<=@endDate option (maxrecursion 0)

	INSERT INTO @TempReport
	SELECT 'Expenditure' as name, SUM(amount) from tbl_Expenditures where isDeleted=0 AND date>=@startDate and date<=@endDate option (maxrecursion 0)

	SELECT name, COALESCE(amount,0) as amount from @TempReport option (maxrecursion 0)
END

--exec usp_report_OutGoing_Payment_Share '2021-07-14','2021-07-18'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Payers]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Payers]
(
@startDate date,
@endDate date,
@default_top_or_least_number int=10,
@graph_type nvarchar(20)
)
AS
BEGIN
if @graph_type ='top'
BEGIN
	SELECT top (@default_top_or_least_number) b.customer_name,a.amount as amount  FROM 
	(SELECT customer_id,sum(debit) as amount from tbl_CustomerPassbook where date>=@startDate and date<=@endDate group by customer_id) a
	JOIN tbl_CustomerAccounts b ON a.customer_id=b.id where a.amount>0 ORDER by amount DESC option (maxrecursion 0)
END
else if @graph_type ='least'
BEGIN
	SELECT top (@default_top_or_least_number) b.customer_name,a.amount as amount  FROM 
	(SELECT customer_id,sum(debit) as amount from tbl_CustomerPassbook where date>=@startDate and date<=@endDate group by customer_id) a
	JOIN tbl_CustomerAccounts b ON a.customer_id=b.id where a.amount>0 ORDER by amount ASC option (maxrecursion 0)
END
else if @graph_type ='frequent'
BEGIN
	SELECT c.customer_name,c.number FROM 
	(SELECT top (@default_top_or_least_number) b.customer_name,a.number as number,a.amount  FROM 
	(SELECT customer_id,count(customer_id) as number,sum(debit) as amount from tbl_CustomerPassbook where date>=@startDate and date<=@endDate group by customer_id) a
	JOIN tbl_CustomerAccounts b ON a.customer_id=b.id ORDER by number DESC) c
	 WHERE c.amount>0
	 option (maxrecursion 0)
END
	
END
--usp_report_Payers '2021-01-01','2021-07-31',10,'frequent'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Product_Wise_Production]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Product_Wise_Production]
(
@startDate date,
@endDate date,
@production_unit_id bigint
)
AS
BEGIN
	select (select item_name from tbl_SaleProducts where id=tbl_Productions.sale_product_id and isDeleted=0) as item_name, 
	sum(production_quantity) as quantity from tbl_Productions 
	where production_unit_id=@production_unit_id AND isDeleted=0 and date>=@startDate and date<=@endDate group by sale_product_id  option (maxrecursion 0) 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Product_Wise_Sales]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Product_Wise_Sales]
(
@startDate date,
@endDate date
)
AS
BEGIN

	DECLARE @TempSalesPrimary TABLE
	(
		srlno bigint identity(1,1),
		sale_products nvarchar(max)
	)
	DECLARE @TempSalesSecondary TABLE
	(
		item nvarchar(max),
		quantity decimal(18,2)
	)

	INSERT INTO @TempSalesPrimary	
	select sale_products from tbl_SalesOrder where isDeleted=0 and delivery_status=2 and  sales_date>=@startDate and sales_date<=@endDate ORDER by sales_date asc  option (maxrecursion 0)

		declare @json_input nvarchar(max)
		declare @date_total_quantity decimal(18,2)

		declare @totalrows int = (select count(*) from @TempSalesPrimary)
		declare @currentrow int = 1
		while @currentrow <=  @totalrows  
		begin 
		    
			set @json_input = (select sale_products from @TempSalesPrimary where srlno = @currentrow)
			
			INSERT INTO @TempSalesSecondary
			SELECT item,quantity
				FROM OPENJSON(@json_input)
					WITH (
					item nvarchar(max) '$.item_name',
					quantity decimal(18,2) '$.item_quantity'
					)
			
			set @currentrow = @currentrow +1
		end  

		--SELECT * FROM @TempSalesSecondary

-----------------

SELECT item as item_name,sum(quantity) as quantity FROM @TempSalesSecondary group by item  option (maxrecursion 0)
	
END

--exec usp_report_Product_Wise_Sales '2021-04-26','2021-07-11'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Production_Lasting]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_report_Production_Lasting]
(
@startDate date,
@endDate date
)
AS
BEGIN

	--#1 Get daily Production Average of each sale product id
	DECLARE @TempProductionAverage TABLE
	(
		sale_product_id bigint,
		production_quantity_average decimal(18,2)
	)
	INSERT INTO @TempProductionAverage
	SELECT sale_product_id,AVG(production_quantity) as production_quantity_average 
	FROM tbl_Productions WHERE isDeleted=0 AND date>=@startDate AND date<=@endDate
	GROUP by sale_product_id option (maxrecursion 0)

	--select * from @TempProductionAverage

	--#2 Get composition & stock of each sale product id and find the productive quantity
	DECLARE @TempComposition TABLE
	(
		sale_product_id bigint,
		utilize_quantity decimal(18,2),
		balance_quantity decimal(18,2),
		productive_quantity decimal(18,2)
	)

	INSERT INTO @TempComposition
	SELECT c.sale_product_id, c.utilize_quantity,c.balance_quantity, (SELECT (c.balance_quantity/(SELECT CASE WHEN c.utilize_quantity = 0 THEN 1 ELSE c.utilize_quantity END))) as productive_quantity
	FROM 
	(
	SELECT a.sale_product_id,a.utilize_quantity,(SELECT top 1 balance_quantity FROM tbl_RawMaterialStock WHERE item_id=a.raw_material_id ORDER by id DESC) as balance_quantity
	FROM tbl_CompositionAndWastage a JOIN @TempProductionAverage b ON a.sale_product_id=b.sale_product_id 
	WHERE a.isDeleted=0
	) c
	option (maxrecursion 0)
	
	--select * from @TempComposition

	--Final Output
	DECLARE @TempCapacityProduction TABLE
	(
	    sale_product_id bigint,
		production_average_per_day decimal(18,2),
		production_lasting_quantity decimal(18,2),
		production_lasting_day int
	)
	INSERT INTO @TempCapacityProduction
	SELECT a.sale_product_id,COALESCE(a.production_quantity_average,0) as production_average_per_day, 
	COALESCE((SELECT MIN(productive_quantity) FROM @TempComposition WHERE sale_product_id=a.sale_product_id GROUP BY sale_product_id),0) as production_lasting_quantity,
	COALESCE(((SELECT MIN(productive_quantity) FROM @TempComposition 
	WHERE sale_product_id=a.sale_product_id GROUP BY sale_product_id)/(SELECT production_quantity_average FROM @TempProductionAverage WHERE sale_product_id=a.sale_product_id)),0) as production_lasting_day
	FROM @TempProductionAverage a 
	option (maxrecursion 0)

	select a.sale_product_id,b.item_name as sale_product_name,a.production_average_per_day,a.production_lasting_quantity,a.production_lasting_day from 
	@TempCapacityProduction a JOIN tbl_SaleProducts b ON a.sale_product_id = b.id

END

--exec usp_report_Production_Lasting '2021-04-01','2021-08-31'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Production_vs_Sales]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Production_vs_Sales]
(
@startDate date,
@endDate date
)
AS
BEGIN
--1. Get Production Quantity
	DECLARE @TempProduction TABLE
		(
			date date,
			production decimal(18,2)
		)
	INSERT INTO @TempProduction	
	select date,sum(production_quantity) production from tbl_Productions
	where date>=@startDate and date<=@endDate and isDeleted=0
	group by date order by date asc  option (maxrecursion 0)
	
	--select * from @TempProduction
-----------------
--2. Get Sales Quantity
	DECLARE @TempSalesPrimary TABLE
	(
		srlno bigint,
		sales_date date,
		sale_products nvarchar(max)
	)
	DECLARE @TempSalesSecondary TABLE
	(
		date date,
		sales decimal(18,2)
	)

	INSERT INTO @TempSalesPrimary	
	select row_number() over(order by sales_date asc) as srlno,sales_date,sale_products from tbl_SalesOrder where isDeleted=0 and delivery_status=2 and  sales_date>=@startDate and sales_date<=@endDate ORDER by sales_date asc  option (maxrecursion 0)

		declare @json_input nvarchar(max)
		declare @prev_row_date date
		declare @current_row_date date
		declare @date_total_quantity decimal(18,2)

		declare @totalrows int = (select count(*) from @TempSalesPrimary)
		declare @currentrow int = 1
		while @currentrow <=  @totalrows  
		begin 
		    
			set @json_input = (select sale_products from @TempSalesPrimary where srlno = @currentrow)
			set @current_row_date = (select sales_date from @TempSalesPrimary where srlno = @currentrow)

			declare @date_row_quantity decimal(18,2)
			set @date_row_quantity = (SELECT Sum(quantity) as sales
			FROM OPENJSON(@json_input)
				WITH (
				quantity decimal(18,2) '$.item_quantity'
				))
			 
			if @prev_row_date = @current_row_date
			BEGIN
			set @date_total_quantity = (@date_total_quantity+@date_row_quantity)
			UPDATE @TempSalesSecondary SET sales = @date_total_quantity where date = @current_row_date
			END
			ELSE
			BEGIN
			set @date_total_quantity = @date_row_quantity
			INSERT INTO @TempSalesSecondary values(@current_row_date,@date_row_quantity)	
			END
			set @prev_row_date = @current_row_date
			
			set @currentrow = @currentrow +1
		end  

		--SELECT * FROM @TempSalesSecondary

-----------------
--3. Get Final Output
	DECLARE @DataTable TABLE
		(
		 srlno bigint identity(1,1),
		 date date,
		 production decimal(18,2)default(0), 
		 sales decimal(18,2)default(0)
		)

	;WITH BlankCTE(date) AS
	(
		SELECT @startDate as date
		UNION ALL
		SELECT DATEADD(DAY,1,date)
		FROM BlankCTE
		WHERE date < @endDate
	)
	insert into @DataTable(date) select * from BlankCTE option (maxrecursion 0)
	declare @row_date date
	set @totalrows = (select count(*) from @DataTable)
	set @currentrow = 1 
	while @currentrow <=  @totalrows  
	begin
	    set @row_date = (select date from @DataTable where srlno = @currentrow)
	    if exists (select * from @TempProduction where date=@row_date)
		BEGIN
			update @DataTable set production=(select production from @TempProduction where date=@row_date)
								  WHERE date=@row_date
		END
		if exists (select * from @TempSalesSecondary where date=@row_date)
		BEGIN
			update @DataTable set sales =(select sales from @TempSalesSecondary where date=@row_date) 
								  WHERE date=@row_date
		END
		
		set @currentrow = @currentrow +1
	end
	select date,COALESCE(production,0) as production,COALESCE(sales,0) as sales from @DataTable order by date asc option (maxrecursion 0)
END

--exec usp_report_Production_vs_Sales '2021-04-01','2021-07-30'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_ProfitLoss_Summary]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_ProfitLoss_Summary]
(
@startDate date,
@endDate date
)
AS
BEGIN
	--Outgoing
	DECLARE @supplier_payment decimal(18,2)
	DECLARE @expenditure decimal(18,2)
	
	SET @supplier_payment = COALESCE((SELECT SUM(debit) FROM tbl_SupplierPassbook WHERE date>=@startDate and date<=@endDate),0)
	SET @expenditure =  COALESCE((SELECT SUM(amount) FROM tbl_Expenditures WHERE isDeleted=0 AND date>=@startDate and date<=@endDate),0)

	---Incoming
	DECLARE @sales decimal(18,2)
	DECLARE @wastage decimal(18,2)

	SET @sales =  COALESCE((SELECT SUM(debit) FROM tbl_CustomerPassbook WHERE date>=@startDate and date<=@endDate),0)
	SET @wastage =   COALESCE((SELECT SUM(sale_amount) FROM tbl_WasteSale WHERE isDeleted=0 AND date>=@startDate and date<=@endDate),0)

	DECLARE @default_account_balance decimal(18,2)
	SET @default_account_balance = COALESCE((SELECT top 1 balance FROM tbl_CompanyPassbook WHERE account_id=(SELECT top 1 id FROM tbl_CompanyAccount where is_default=1 order by id desc) order by id desc),0)

	SELECT @supplier_payment as supplier_payment,
	@expenditure as expenditure,(@supplier_payment+@expenditure) as total_outgoing,
	@sales as sales,@wastage as wastage,(@sales+@wastage) as total_incoming,
	((@sales+@wastage)-(@supplier_payment+@expenditure)) as result,
	@default_account_balance as default_account_balance

END

--exec usp_report_ProfitLoss_Summary  '2021-04-26','2021-07-11'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_ProfitLossGraph]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_ProfitLossGraph]
(
@startDate date,
@endDate date
)
AS
BEGIN
   DECLARE @TempSupplierPayment TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @TempExpenditure TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @TempSales TABLE
	(
		date date,
		amount decimal(18,2)
	)
	DECLARE @TempWastage TABLE
	(
		date date,
		amount decimal(18,2)
	)

	INSERT INTO @TempSupplierPayment	
	SELECT date, sum(debit) as amount FROM tbl_SupplierPassbook WHERE date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)
	
	INSERT INTO @TempExpenditure	
	SELECT date, sum(amount) as amount FROM tbl_Expenditures WHERE isDeleted=0 AND date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)

	INSERT INTO @TempSales	
	SELECT date, sum(debit) as amount FROM tbl_CustomerPassbook WHERE date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)

	INSERT INTO @TempWastage	
	SELECT date, sum(sale_amount) as amount FROM tbl_WasteSale WHERE isDeleted=0 AND date>=@startDate and date<=@endDate
	GROUP BY date
	option (maxrecursion 0)
	
	-- Final Output
	
	;WITH BlankTable(date) AS
	(
		SELECT @startDate as date
		UNION ALL
		SELECT DATEADD(DAY,1,date)
		FROM BlankTable
		WHERE date < @endDate
	)

	SELECT a.date,
	((COALESCE((SELECT amount FROM @TempSales WHERE date=a.date),0)+COALESCE((SELECT amount FROM @TempWastage WHERE date=a.date),0))-
		(COALESCE((SELECT amount FROM @TempSupplierPayment WHERE date=a.date),0)+COALESCE((SELECT amount FROM @TempExpenditure WHERE date=a.date),0)))
	AS result
	FROM BlankTable a
	option (maxrecursion 0)

END

--exec usp_report_ProfitLossGraph '2021-01-01','2021-07-31'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Purchase_Graph]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Purchase_Graph]
(
@startDate date,
@endDate date
)
AS
BEGIN
	DECLARE @DataTable TABLE
		(date date,
		 amount decimal(18,2)
		)
	INSERT INTO @DataTable	
	select date, sum(debit) as amount from tbl_SupplierPassbook WHERE date>=@startDate and date<=@endDate
	group by date order by date asc

	;WITH BlankTable(date) AS
	(
		SELECT @startDate as date
		UNION ALL
		SELECT DATEADD(DAY,1,date)
		FROM BlankTable
		WHERE date < @endDate
	)
    
	SELECT d.date, COALESCE(r.amount,0) as amount
	FROM BlankTable d
	LEFT JOIN @DataTable r ON d.Date = r.Date option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Sales_Lasting]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Sales_Lasting]
(
@startDate date,
@endDate date
)
AS
BEGIN

	DECLARE @TempSalesPrimary TABLE
	(
		srlno bigint identity(1,1),
		sale_products nvarchar(max)
	)
	DECLARE @TempSalesSecondary TABLE
	(
		sale_product_id nvarchar(max),
		quantity decimal(18,2)
	)


	INSERT INTO @TempSalesPrimary	
	select sale_products from tbl_SalesOrder where isDeleted=0 and delivery_status=2 and  sales_date>=@startDate and sales_date<=@endDate ORDER by sales_date asc  option (maxrecursion 0)

	declare @json_input nvarchar(max)

	declare @totalrows int = (select count(*) from @TempSalesPrimary)
	declare @currentrow int = 1
	while @currentrow <=  @totalrows  
	begin 
		set @json_input = (select sale_products from @TempSalesPrimary where srlno = @currentrow)
			
		INSERT INTO @TempSalesSecondary
		SELECT sale_product_id,quantity
			FROM OPENJSON(@json_input)
				WITH (
				sale_product_id nvarchar(max) '$.id',
				quantity decimal(18,2) '$.item_quantity'
				)

		set @currentrow = @currentrow +1
	end  

	--SELECT sale_product_id, AVG(quantity) AS average_quantity FROM @TempSalesSecondary
	--GROUP BY sale_product_id option (maxrecursion 0)

-----------------
SELECT outputA.sale_product_id,
(select item_name from tbl_SaleProducts where id= outputA.sale_product_id) as sale_product_name,
COALESCE(outputB.average_quantity,0) as average_quantity,
COALESCE(outputA.balance_quantity,0) as balance_quantity,
CAST(ROUND(COALESCE((SELECT (outputA.balance_quantity/(SELECT CASE WHEN outputB.average_quantity = 0 THEN 1 ELSE outputB.average_quantity END))),outputA.balance_quantity), 0) AS Int) as sale_order_count
FROM
(
SELECT DISTINCT a.item_id as sale_product_id,
(select top 1 balance_quantity from tbl_SaleProductStock where item_id=a.item_id order by id desc) as balance_quantity
from tbl_SaleProductStock a
) outputA LEFT JOIN (SELECT sale_product_id, AVG(quantity) AS average_quantity FROM @TempSalesSecondary
	GROUP BY sale_product_id) outputB 
	ON outputA.sale_product_id = outputB.sale_product_id option (maxrecursion 0)

END

--exec usp_report_Sales_Lasting '2021-04-26','2021-07-11'
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Sales_vs_Collection]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_report_Sales_vs_Collection]
(
@startDate date,
@endDate date
)
AS
BEGIN
DECLARE @DataTable TABLE
	(date date,
	 sales decimal(18,2), 
	 collection decimal(18,2)
	)
INSERT INTO @DataTable	
select date, sum(credit) as sales ,sum(debit) as collection from tbl_CustomerPassbook
where date>=@startDate and date<=@endDate
group by date order by date asc

;WITH BlankTable(date) AS
(
	SELECT @startDate as date
	UNION ALL
	SELECT DATEADD(DAY,1,date)
	FROM BlankTable
	WHERE date < @endDate
)

SELECT d.Date, COALESCE(r.sales,0) as sales,COALESCE(r.collection,0) as collection
FROM BlankTable d
LEFT JOIN @DataTable r ON d.Date = r.Date option (maxrecursion 0)

END
GO
/****** Object:  StoredProcedure [dbo].[usp_report_Wastage_Sale_Graph]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_report_Wastage_Sale_Graph]
(
@startDate date,
@endDate date
)
AS
BEGIN
	DECLARE @DataTable TABLE
		(date date,
		 sales decimal(18,2)
		)
	INSERT INTO @DataTable	
	select date, sum(sale_amount) as sales from tbl_WasteSale
	where isDeleted=0 AND date>=@startDate and date<=@endDate
	group by date order by date asc

	;WITH BlankTable(date) AS
	(
		SELECT @startDate as date
		UNION ALL
		SELECT DATEADD(DAY,1,date)
		FROM BlankTable
		WHERE date < @endDate
	)
    
	SELECT d.date, COALESCE(r.sales,0) as sales
	FROM BlankTable d
	LEFT JOIN @DataTable r ON d.Date = r.Date option (maxrecursion 0)
END

--exec usp_report_Wastage_Graph '2021-01-01','2021-07-31'
GO
/****** Object:  StoredProcedure [dbo].[usp_resetUserPassword]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_resetUserPassword]
(
@id bigint,
@password nvarchar(max)
)
AS
BEGIN
	BEGIN TRY
		
	  
		UPDATE tbl_Users SET 
			password = @password
		WHERE id=@id

		
		SELECT 1 as 'status', 'Password Reset successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Resetting Password. Please try again' as message
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_saveActivityLog]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveActivityLog](
@action_performer_name nvarchar(max),
@action_performer_login_id nvarchar(max),
@action_title nvarchar(max),
@action_content nvarchar(max)
)
AS
BEGIN
BEGIN TRY
	INSERT INTO tbl_ActivityLog (date, action_performer_name,action_performer_login_id,action_title,action_content) values ((select convert(varchar, getdate(), 9)), @action_performer_name,@action_performer_login_id,@action_title,@action_content)
	SELECT 1 as 'status', 'Activity log updated successfully.' as message
END TRY
BEGIN CATCH
	SELECT 0 as 'status', 'Failed saving Activity log. Please try again.' as message
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveCompanyAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveCompanyAccount](
	@id bigint,
	@account_title nvarchar(max),
	@account_number nvarchar(max),
	@account_type nvarchar(max),
	@account_ifsc_code nvarchar(max),
	@opening_balance decimal(18,2),
	@is_default bit
)
AS
BEGIN

BEGIN TRY

	IF @id = 0
	BEGIN
	   
		IF EXISTS (SELECT * FROM tbl_CompanyAccount WHERE account_title=TRIM(@account_title) AND isDeleted=0)
		BEGIN
				SELECT 0 as 'status', 'Company Account already exists.' as message
		END
		ELSE
		BEGIN
			IF @is_default = 1
			BEGIN
				UPDATE tbl_CompanyAccount SET is_default = 0
			END

			IF (SELECT COUNT(*) FROM tbl_CompanyAccount WHERE isDeleted=0) = 0
			BEGIN
				SET @is_default = 1
			END

			INSERT INTO tbl_CompanyAccount (account_title,account_number,account_type,account_ifsc_code,opening_balance,isDeleted,is_default)
			VALUES(@account_title,@account_number,@account_type,@account_ifsc_code,@opening_balance,0,@is_default)
		
			--Company Account entry
			DECLARE @company_account_id bigint
			SET @company_account_id = (SELECT SCOPE_IDENTITY())

			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@company_account_id,(SELECT GETDATE()),'Opening Balance','Opening Balance','-',@opening_balance,0,@opening_balance)
		

			SELECT 1 as 'status', 'Company Account Created successfully.' as message
		END
		
	END
	ELSE
	BEGIN
	    IF EXISTS (select * from tbl_CompanyAccount where id!=@id AND account_title=TRIM(@account_title) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Company Account already Exists.' as message
		END
		ELSE
		BEGIN
			IF @is_default = 1
			BEGIN
				UPDATE tbl_CompanyAccount SET is_default = 0
			END
			DECLARE @prev_opening_balance decimal(18,2)
			DECLARE @balance decimal(18,2)

			SET @prev_opening_balance = (SELECT opening_balance FROM tbl_CompanyAccount WHERE id=@id)
		
			UPDATE tbl_CompanyAccount SET 
					account_title=@account_title,
					account_number=@account_number,
					account_type=@account_type,
					account_ifsc_code=@account_ifsc_code,
					opening_balance= @opening_balance,
					is_default= @is_default
				WHERE id=@id

			--Removed from Company Account entry
			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @id ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @balance = (@balance-@prev_opening_balance)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@id,(SELECT GETDATE()),'Opening Balance Revoked','Opening Balance Revoked','-',0,@prev_opening_balance,@balance)
		

			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @id ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @balance = (@balance+@opening_balance)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@id,(SELECT GETDATE()),'Opening Balance Updated','Opening Balance','-',@balance,0,@balance)
		
			SELECT 1 as 'status', 'Company Account Updated successfully.' as message
		END
    	
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving Company Account. Please try again.' as message
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveCompositionAndWastage]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveCompositionAndWastage]
(
@id bigint =0,
@sale_product_id bigint,
@raw_material_id bigint,
@wastage_id bigint,
@utilize_quantity decimal(18,2),
@wastage_quantity decimal(18,2)
)
AS
BEGIN
	BEGIN TRY
		IF @id = 0
		BEGIN
			INSERT INTO tbl_CompositionAndWastage(sale_product_id,raw_material_id,wastage_id,utilize_quantity,wastage_quantity,isDeleted)
				VALUES(@sale_product_id,@raw_material_id,@wastage_id,@utilize_quantity,@wastage_quantity,0)
			SELECT 1 as 'status', 'Composition and Wastage added successfully.' as message
		END
		ELSE
		BEGIN
			UPDATE tbl_CompositionAndWastage 
				SET sale_product_id = @sale_product_id,raw_material_id=@raw_material_id, wastage_id=@wastage_id, utilize_quantity = @utilize_quantity, wastage_quantity=@wastage_quantity
					WHERE id=@id
			SELECT 1 as 'status', 'Composition and Wastage updated successfully.' as message
		END
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving item into Composition and Wastage. Please try again' as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveCustomerAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveCustomerAccount]
@id bigint = 0,
@customer_name nvarchar(max)='',
@poc_name nvarchar(max)='',
@email nvarchar(100)='',
@phone nvarchar(max)='' ,
@fax nvarchar(max)='' ,
@mobile nvarchar(max)='',
@whatsapp nvarchar(max) ='',
@website nvarchar(max) ='',
@address nvarchar(max) ='' ,
@gst_registration_type nvarchar(max) ='' ,
@gstin nvarchar(max)='' ,
@pan_or_tan nvarchar(max) ='',
@bank_account_number nvarchar(max)='' ,
@opening_balance decimal =0 ,
@as_of date = '',
@terms int = 0,
@notes nvarchar(max) ='' ,
@date_of_registration date =''
AS
BEGIN
	BEGIN TRY
	IF @id = 0
	BEGIN
		  IF NOT EXISTS (SELECT * FROM tbl_customerAccounts WHERE customer_name =TRIM(@customer_name)  AND isDeleted=0)
		   BEGIN
			   INSERT INTO tbl_customerAccounts
				(
				customer_name,poc_name,email,phone,fax,mobile,whatsapp,website,address,gst_registration_type,gstin,pan_or_tan,bank_account_number,
				opening_balance,as_of,terms,notes,date_of_registration
				)
				VALUES(
				@customer_name,@poc_name,@email,@phone,@fax,@mobile,@whatsapp,@website,@address,@gst_registration_type,@gstin,@pan_or_tan,@bank_account_number,
				@opening_balance,@as_of,@terms,@notes,@date_of_registration
				)

				DECLARE @customer_id bigint
				SET @customer_id = (SELECT SCOPE_IDENTITY())

				INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
				VALUES (@customer_id,@as_of,'Opening Balance','Balanced entry','Balanced entry',@opening_balance,0,@opening_balance)

				SELECT 1 as 'status', 'Customer Account Created successfully.' as message
		  END
		  ELSE
		  BEGIN
				SELECT 0 as 'status', 'Customer Account is already exists.' as message
		  END
		
	END
	ELSE
	BEGIN
	    IF EXISTS (select * from tbl_customerAccounts where id!=@id AND customer_name=TRIM(@customer_name) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Customer already Exists.' as message
		END
		ELSE
		BEGIN
			UPDATE tbl_customerAccounts 
			SET customer_name = @customer_name,
				poc_name = @poc_name,
				email = @email,
				phone = @phone,
				fax= @fax,
				mobile = @mobile,
				whatsapp = @whatsapp,
				website = @website,
				address = @address,
				gst_registration_type = @gst_registration_type,
				gstin = @gstin,
				pan_or_tan = @pan_or_tan,
				bank_account_number = @bank_account_number,
				opening_balance = @opening_balance,
				as_of = @as_of,
				terms = @terms,
				notes = @notes

				WHERE id = @id

				SELECT 1 as 'status', 'Customer Account Updated successfully.' as message
		END
	END
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', ERROR_MESSAGE() as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveExpenditure]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveExpenditure](
@id bigint,
@payment_head nvarchar(max),
@description nvarchar(max),
@payment_reference nvarchar(max),
@date datetime,
@amount decimal(18,2),
@gst_id bigint,
@total_amount decimal(18,2),
@prev_total_amount decimal(18,2)=0,
@is_regular_expenditure bit,
@debit_account bigint,
@payment_mode nvarchar(max)
)
AS
BEGIN

BEGIN TRY
	DECLARE @balance decimal(18,2)
	DECLARE @new_balance decimal(18,2)

	IF @id = 0
	BEGIN
		insert into tbl_Expenditures(payment_head,description,payment_reference,date,amount,gst_id,is_regular_expenditure,debit_account,payment_mode)
		values (@payment_head,@description,@payment_reference,@date,@amount,@gst_id,@is_regular_expenditure,@debit_account,@payment_mode)
	
		--Company Account entry
		SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		SET @new_balance = (@balance-@total_amount)
		INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@debit_account,(SELECT GETDATE()),'Expenditure - '+@payment_head+'','Expenditure',''+@payment_mode+' - '+@payment_reference+'',0,@total_amount,@new_balance)
		
		SELECT 1 as 'status', 'Expenditure Added successfully.' as message
	END
	ELSE
	BEGIN
	    DECLARE @prev_debit_account bigint
	    DECLARE @prev_payment_head nvarchar(max)
	    DECLARE @prev_payment_mode nvarchar(max)
	    DECLARE @prev_payment_reference nvarchar(max)


		SET @prev_debit_account = (SELECT debit_account FROM tbl_expenditures WHERE id=@id)
		SET @prev_payment_head = (SELECT payment_head FROM tbl_expenditures WHERE id=@id)
		SET @prev_payment_mode = (SELECT payment_mode FROM tbl_expenditures WHERE id=@id)
		SET @prev_payment_reference = (SELECT payment_reference FROM tbl_expenditures WHERE id=@id)


		UPDATE tbl_expenditures SET 
				payment_head=@payment_head,
				description=@description,
				payment_reference=@payment_reference,
				date=@date,
				amount=@amount,
				gst_id=@gst_id,
				is_regular_expenditure=@is_regular_expenditure,
				debit_account=@debit_account,
				payment_mode=@payment_mode

			WHERE id=@id

		  --Removed from Company Account entry
			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @prev_debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance+@prev_total_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@prev_debit_account,(SELECT GETDATE()),'Expenditure Revoked(Edited) - '+@prev_payment_head+'','Expenditure Revoked',''+@prev_payment_mode+' - '+@prev_payment_reference+'',@prev_total_amount,0,@new_balance)
		

			SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance-@total_amount)
			INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@debit_account,(SELECT GETDATE()),'Expenditure - '+@payment_head+'','Expenditure',''+@payment_mode+' - '+@payment_reference+'',0,@total_amount,@new_balance)
		

		SELECT 1 as 'status', 'Expenditure Updated successfully.' as message
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving Expenditure. Please try again.' as message
END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_SaveIntoPinnedShortcuts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_SaveIntoPinnedShortcuts](
@login_id nvarchar(max),
@shortcut_title nvarchar(max),
@shortcut_url nvarchar(max),
@shortcut_icon nvarchar(max)
)
AS
BEGIN

IF NOT EXISTS (select * from tbl_PinnedShortcuts where login_id=@login_id and isDeleted=0 AND shortcut_title=@shortcut_title)
BEGIN
	INSERT INTO tbl_PinnedShortcuts(login_id,shortcut_title,shortcut_url,shortcut_icon) VALUES (@login_id,@shortcut_title,@shortcut_url,@shortcut_icon)
END
ELSE
BEGIN
	update tbl_PinnedShortcuts set 
		shortcut_title=@shortcut_title,
		shortcut_url=@shortcut_url,
		shortcut_icon=@shortcut_icon 
		WHERE login_id=@login_id and isDeleted=0 AND shortcut_title=@shortcut_title
END

SELECT 1 as 'status', 'Pinned - '+@shortcut_title+'' as message
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveMyProfile]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveMyProfile](
@login_id nvarchar(max),
@full_name nvarchar(max),
@email nvarchar(max)='',
@mobile nvarchar(max)='',
@current_password nvarchar(max),
@new_password nvarchar(max)=''
)
AS
BEGIN

BEGIN TRY
	    DECLARE @password nvarchar(max)
		SET @password =(select password from tbl_Users where login_id=@login_id and isDeleted=0 and password=@current_password)
		IF @password is NULL
		BEGIN
				SELECT 0 as 'status', 'Failed : Wrong Current Password Provided.' as message
		END
		ELSE
		BEGIN
			IF (LOWER(@password)) = (LOWER(@current_password))
			BEGIN
				IF @new_password = ''
				BEGIN
					UPDATE tbl_Users SET 
						full_name= @full_name,
						email= @email,
						mobile= @mobile
					WHERE login_id=@login_id
				END
				ELSE
				BEGIN
					UPDATE tbl_Users SET 
						full_name= @full_name,
						email= @email,
						mobile= @mobile,
						password= @new_password
					WHERE login_id=@login_id
				END
				SELECT 1 as 'status', 'Profile has been updated successfully.' as message
			END
			ELSE
			BEGIN
				SELECT 0 as 'status', 'Failed : Your current password is not valid.' as message
			END
		END
		
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving user profile. Please try again.' as message
END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_saveProduction]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveProduction]
(
	@date datetime,
	@production_unit_id bigint,
	@functioning_hours int,
	@sale_product_id bigint,
	@production_quantity decimal(18,2)
)
AS
BEGIN
	BEGIN TRY
	    DECLARE @sale_product_name nvarchar(max)
		SET @sale_product_name = (SELECT item_name FROM tbl_SaleProducts WHERE id=@sale_product_id)
		
		--Insert into main table
		INSERT INTO tbl_Productions(date,production_unit_id,functioning_hours,sale_product_id,production_quantity,isDeleted) 
		VALUES (@date,@production_unit_id,@functioning_hours,@sale_product_id,@production_quantity,0)

		-- Manage Sale Product Stock
		DECLARE @balance_quantity decimal(18,2)
		SET @balance_quantity = (SELECT top 1 balance_quantity FROM tbl_SaleProductStock WHERE item_id=@sale_product_id ORDER BY id DESC)
		if(@balance_quantity is null)
		BEGIN
			SET @balance_quantity = 0
		END
		SET @balance_quantity = (@balance_quantity+@production_quantity)
			INSERT INTO tbl_SaleProductStock(item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@sale_product_id,@date, 'Production Entry',@production_quantity,0,@balance_quantity)


		SELECT 1 as 'status', 'Production entry successfully.' as message
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed Production Entry. Please try again' as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveProductionUnit]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveProductionUnit](
@id bigint,
@unit_name nvarchar(max),
@unit_description nvarchar(max),
@production_capacity_per_hour decimal(18,2)
)
AS
BEGIN

BEGIN TRY
	IF @id = 0
	BEGIN
		IF EXISTS (SELECT * FROM tbl_ProductionUnitsAndCapacity WHERE unit_name=TRIM(@unit_name) AND isDeleted=0)
		BEGIN
				SELECT 0 as 'status', 'Production Unit already exists.' as message
		END
		ELSE
		BEGIN
			INSERT INTO tbl_ProductionUnitsAndCapacity (unit_name,unit_description,production_capacity_per_hour,isDeleted)
			VALUES(@unit_name,@unit_description,@production_capacity_per_hour,0)
	
			SELECT 1 as 'status', 'Production Unit Added successfully.' as message
		END
	END
	ELSE
	BEGIN
		IF EXISTS (select * from tbl_ProductionUnitsAndCapacity where id!=@id AND unit_name=TRIM(@unit_name) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Production Unit already Exists.' as message
		END
		ELSE
		BEGIN
			UPDATE tbl_ProductionUnitsAndCapacity SET 
					unit_name=@unit_name,
					unit_description = @unit_description,
					production_capacity_per_hour= @production_capacity_per_hour
				WHERE id=@id

			SELECT 1 as 'status', 'Production Unit Updated successfully.' as message
	    END
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving Production Unit. Please try again.' as message
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_savePurchaseOrder]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_savePurchaseOrder]  
@id bigint = 0,  
@supplier_id bigint=0,  
@invoice_no nvarchar(max),  
@purchase_date date,  
@email nvarchar(max),  
@whatsapp nvarchar(max) ='',  
@shipping_via nvarchar(max) ='',  
@supplier_mailing_address nvarchar(max),  
@shipping_to nvarchar(max),  
@memo nvarchar(max) ='' ,  
@message_to_spplier nvarchar(max) ='' ,  
@raw_materials nvarchar(max),  
@delivery_status int,  
@payment_status int  
AS  
BEGIN  
 BEGIN TRY  
 IF @id = 0  
 BEGIN  
  INSERT INTO tbl_PurchaseOrder  
   (  
   supplier_id,invoice_no,purchase_date,email,whatsapp,shipping_via,supplier_mailing_address,shipping_to,memo,message_to_spplier,raw_materials,delivery_status,  
   payment_status  
   )  
   VALUES(  
   @supplier_id,@invoice_no,@purchase_date,@email,@whatsapp,@shipping_via,@supplier_mailing_address,@shipping_to,@memo,@message_to_spplier,@raw_materials,@delivery_status,  
   @payment_status  
   )  
   DECLARE @last_inserted_order_id bigint  
   SET @last_inserted_order_id = (SELECT SCOPE_IDENTITY())  

   SELECT 1 as 'status', 'Purchase Order created successfully.' as message,@last_inserted_order_id as id
 END  
 ELSE  
 BEGIN  
  
   UPDATE tbl_PurchaseOrder   
   SET supplier_id = @supplier_id,   
    invoice_no = @invoice_no,  
    purchase_date = @purchase_date,  
    email = @email,  
    whatsapp= @whatsapp,  
    shipping_via = @shipping_via,  
    supplier_mailing_address = @supplier_mailing_address,  
    shipping_to = @shipping_to,  
    memo = @memo,  
    message_to_spplier = @message_to_spplier,  
    raw_materials = @raw_materials,  
    delivery_status = @delivery_status,  
    payment_status = @payment_status  
  
    WHERE id = @id  
  
    SELECT 1 as 'status', 'Purchase Order updated successfully.' as message,@id as id
 END  
 END TRY  
 BEGIN CATCH  
  SELECT 0 as 'status', ERROR_MESSAGE() as message  
 END CATCH  
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveRawMaterial]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveRawMaterial](
@id bigint,
@name nvarchar(max),
@description nvarchar(max),
@item_type nvarchar(max),
@item_group nvarchar(max)='',
@unit bigint,
@rate bigint,
@gst bigint,
@low_stock_alert decimal(18,2)=0
)
AS
BEGIN

BEGIN TRY
	IF @id = 0
	BEGIN
		
		IF EXISTS (SELECT * FROM tbl_RawMaterials WHERE item_name=TRIM(@name) AND isDeleted=0)
		BEGIN
				SELECT 0 as 'status', 'Item already exists.' as message
		END
		ELSE
		BEGIN
			INSERT INTO tbl_RawMaterials (item_name,description,item_type,item_group,unit,rate,gst,low_stock_alert,isDeleted)
			VALUES(@name,@description,@item_type,@item_group,@unit,@rate,@gst,@low_stock_alert,0)
	
			DECLARE @item_id bigint
			SET @item_id = (SELECT SCOPE_IDENTITY())

			INSERT INTO tbl_RawMaterialStock (item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()),'Newly Added Item',0,0,0)
			SELECT 1 as 'status', 'Item Added successfully.' as message
		END
	END
	ELSE
	BEGIN
	 IF EXISTS (select * from tbl_RawMaterials where id!=@id AND item_name=TRIM(@name) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Raw Material already Exists.' as message
		END
		ELSE
		BEGIN
		UPDATE tbl_RawMaterials SET 
				item_name=@name,
				description = @description,
				item_type= @item_type,
				item_group = @item_group,
				unit = @unit,
				rate = @rate,
				gst=@gst,
				low_stock_alert = @low_stock_alert
			WHERE id=@id

		SELECT 1 as 'status', 'Item Updated successfully.' as message
	END
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving Item. Please try again.' as message
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveSaleProduct]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveSaleProduct](
@id bigint,
@name nvarchar(max),
@description nvarchar(max),
@item_type nvarchar(max),
@item_group nvarchar(max)='',
@unit bigint,
@rate bigint,
@gst bigint,
@low_stock_alert decimal(18,2)=0
)
AS
BEGIN

BEGIN TRY
	IF @id = 0
	BEGIN
	   IF EXISTS (SELECT * FROM tbl_SaleProducts WHERE item_name=TRIM(@name) AND isDeleted=0)
		BEGIN
				SELECT 0 as 'status', 'Item already exists.' as message
		END
		ELSE
		BEGIN
			INSERT INTO tbl_SaleProducts (item_name,description,item_type,item_group,unit,rate,gst,low_stock_alert,isDeleted)
			VALUES(@name,@description,@item_type,@item_group,@unit,@rate,@gst,@low_stock_alert,0)
	
			DECLARE @item_id bigint
			SET @item_id = (SELECT SCOPE_IDENTITY())

			INSERT INTO tbl_SaleProductStock (item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()),'Newly Added Item',0,0,0)
		
			SELECT 1 as 'status', 'Item Added successfully.' as message
		END
	END
	ELSE
	BEGIN
	 IF EXISTS (select * from tbl_SaleProducts where id!=@id AND item_name=TRIM(@name) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Sale Product already Exists.' as message
		END
		ELSE
		BEGIN
		UPDATE tbl_SaleProducts SET 
				item_name=@name,
				description = @description,
				item_type= @item_type,
				item_group = @item_group,
				unit = @unit,
				rate = @rate,
				gst=@gst,
				low_stock_alert = @low_stock_alert
			WHERE id=@id

		SELECT 1 as 'status', 'Item Updated successfully.' as message
		END
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving Item. Please try again.' as message
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveSalesOrder]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveSalesOrder]  
@id bigint = 0,  
@customer_id bigint=0,  
@invoice_no nvarchar(max),  
@sales_date date,  
@email nvarchar(max),  
@whatsapp nvarchar(max) ='',  
@shipping_via nvarchar(max) ='',  
@customer_mailing_address nvarchar(max),  
@shipping_to nvarchar(max),  
@memo nvarchar(max) ='' ,  
@message_to_customer nvarchar(max) ='' ,  
@sale_products nvarchar(max),  
@delivery_status int,  
@payment_status int  
AS  
BEGIN  
 BEGIN TRY  
 IF @id = 0  
 BEGIN  
  INSERT INTO tbl_salesOrder  
   (  
   customer_id,invoice_no,sales_date,email,whatsapp,shipping_via,customer_mailing_address,shipping_to,memo,message_to_customer,sale_products,delivery_status,  
   payment_status  
   )  
   VALUES(  
   @customer_id,@invoice_no,@sales_date,@email,@whatsapp,@shipping_via,@customer_mailing_address,@shipping_to,@memo,@message_to_customer,@sale_products,@delivery_status,  
   @payment_status  
   )  
   DECLARE @last_inserted_order_id bigint  
   SET @last_inserted_order_id = (SELECT SCOPE_IDENTITY())  

   SELECT 1 as 'status', 'Sales Order created successfully.' as message,@last_inserted_order_id as id
 END  
 ELSE  
 BEGIN  
  
   UPDATE tbl_salesOrder   
   SET customer_id = @customer_id,   
    invoice_no = @invoice_no,  
    sales_date = @sales_date,  
    email = @email,  
    whatsapp= @whatsapp,  
    shipping_via = @shipping_via,  
    customer_mailing_address = @customer_mailing_address,  
    shipping_to = @shipping_to,  
    memo = @memo,  
    message_to_customer = @message_to_customer,  
    sale_products = @sale_products,  
    delivery_status = @delivery_status,  
    payment_status = @payment_status  
  
    WHERE id = @id  
  
    SELECT 1 as 'status', 'Sales Order updated successfully.' as message, @id as id
 END  
 END TRY  
 BEGIN CATCH  
  SELECT 0 as 'status', ERROR_MESSAGE() as message  
 END CATCH  
END  
GO
/****** Object:  StoredProcedure [dbo].[usp_saveSupplierAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveSupplierAccount]
@id bigint = 0,
@supplier_name nvarchar(max)='',
@poc_name nvarchar(max)='',
@email nvarchar(100)='',
@phone nvarchar(max)='' ,
@fax nvarchar(max)='' ,
@mobile nvarchar(max)='',
@whatsapp nvarchar(max) ='',
@website nvarchar(max) ='',
@address nvarchar(max) ='' ,
@gst_registration_type nvarchar(max) ='' ,
@gstin nvarchar(max)='' ,
@pan_or_tan nvarchar(max) ='',
@bank_account_number nvarchar(max)='' ,
@opening_balance decimal =0 ,
@as_of date = '',
@terms int=0 ,
@notes nvarchar(max) ='' ,
@date_of_registration date =''
AS
BEGIN
	BEGIN TRY
	IF @id = 0
	BEGIN
		  IF NOT EXISTS (SELECT * FROM tbl_supplierAccounts WHERE supplier_name = TRIM(@supplier_name) AND isDeleted=0)
		   BEGIN
			   INSERT INTO tbl_supplierAccounts
				(
				supplier_name,poc_name,email,phone,fax,mobile,whatsapp,website,address,gst_registration_type,gstin,pan_or_tan,bank_account_number,
				opening_balance,as_of,terms,notes,date_of_registration
				)
				VALUES(
				@supplier_name,@poc_name,@email,@phone,@fax,@mobile,@whatsapp,@website,@address,@gst_registration_type,@gstin,@pan_or_tan,@bank_account_number,
				@opening_balance,@as_of,@terms,@notes,@date_of_registration
				)

				DECLARE @supplier_id bigint
				SET @supplier_id = (SELECT SCOPE_IDENTITY())

				INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
				VALUES (@supplier_id,@as_of,'Opening Balance','Balanced entry','Balanced entry',@opening_balance,0,@opening_balance)

				SELECT 1 as 'status', 'Supplier Account Created successfully.' as message
		  END
		  ELSE
		  BEGIN
				SELECT 0 as 'status', 'Supplier Account is already exists.' as message
		  END
		
	END
	ELSE
	BEGIN
	    IF EXISTS (select * from tbl_supplierAccounts where id!=@id AND supplier_name=TRIM(@supplier_name) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Supplier already Exists.' as message
		END
		ELSE
		BEGIN
			UPDATE tbl_supplierAccounts 
			SET supplier_name = @supplier_name,
				poc_name = @poc_name,
				email = @email,
				phone = @phone,
				fax= @fax,
				mobile = @mobile,
				whatsapp = @whatsapp,
				website = @website,
				address = @address,
				gst_registration_type = @gst_registration_type,
				gstin = @gstin,
				pan_or_tan = @pan_or_tan,
				bank_account_number = @bank_account_number,
				opening_balance = @opening_balance,
				as_of = @as_of,
				terms = @terms,
				notes = @notes

				WHERE id = @id

				SELECT 1 as 'status', 'Supplier Account Updated successfully.' as message
		END
	END
	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', ERROR_MESSAGE() as message
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveUsersAndRoles]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveUsersAndRoles](
@id bigint,
@full_name nvarchar(max),
@login_id nvarchar(max),
@password nvarchar(max),
@role_id bigint,
@email nvarchar(max)='',
@mobile nvarchar(max)='',
@is_active bit
)
AS
BEGIN

BEGIN TRY
	IF @id = 0
	BEGIN
		IF NOT EXISTS (select * from tbl_Users where login_id=TRIM(@login_id) and isDeleted=0)
		BEGIN
			insert into tbl_Users(login_id,password,role_id,is_active,full_name,email,mobile) 
					VALUES (@login_id,@password,@role_id,@is_active,@full_name,@email,@mobile)
	
			SELECT 1 as 'status', 'User has been created successfully. Password has been sent to the email of the user.' as message
		END
		ELSE
		BEGIN
			SELECT 0 as 'status', 'User Already Exists.' as message
		END
		
	END
	ELSE
	BEGIN
		IF EXISTS (select * from tbl_Users where id!=@id AND login_id=TRIM(@login_id) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'User Already Exists.' as message
		END
		ELSE
		BEGIN
			UPDATE tbl_Users SET 
					login_id=@login_id,
					role_id = @role_id,
					is_active= @is_active,
					full_name= @full_name,
					email= @email,
					mobile= @mobile
				WHERE id=@id
			
			SELECT 1 as 'status', 'User Updated successfully.' as message
		END
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving users & roles. Please try again.' as message
END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_saveWastage]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveWastage](
@id bigint,
@name nvarchar(max),
@description nvarchar(max),
@item_type nvarchar(max),
@item_group nvarchar(max)='',
@unit bigint,
@rate bigint,
@gst bigint
)
AS
BEGIN

BEGIN TRY
	IF @id = 0
	BEGIN
		IF EXISTS (SELECT * FROM tbl_Wastages WHERE item_name=TRIM(@name) AND isDeleted=0)
		BEGIN
				SELECT 0 as 'status', 'Item already exists.' as message
		END
		ELSE
		BEGIN
			INSERT INTO tbl_Wastages (item_name,description,item_type,item_group,unit,rate,gst,isDeleted)
			VALUES(@name,@description,@item_type,@item_group,@unit,@rate,@gst,0)
	
			DECLARE @item_id bigint
			SET @item_id = (SELECT SCOPE_IDENTITY())

			INSERT INTO tbl_WastageStock (item_id,date,reference,in_quantity,out_quantity,balance_quantity)
				VALUES(@item_id,(SELECT GETDATE()),'Newly Added Item',0,0,0)
		
			SELECT 1 as 'status', 'Item Added successfully.' as message
		END
	END
	ELSE
	BEGIN
	  IF EXISTS (select * from tbl_Wastages where id!=@id AND item_name=TRIM(@name) and isDeleted=0)
		BEGIN
			SELECT 0 as 'status', 'Wastage Item already Exists.' as message
		END
		ELSE
		BEGIN
		UPDATE tbl_Wastages SET 
				item_name=@name,
				description = @description,
				item_type= @item_type,
				item_group = @item_group,
				unit = @unit,
				rate = @rate,
				gst=@gst
			WHERE id=@id

		SELECT 1 as 'status', 'Item Updated successfully.' as message
		END
	END
END TRY
BEGIN CATCH
		SELECT 0 as 'status', 'Failed saving Item. Please try again.' as message
END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[usp_transferAmountWithinCompanyAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_transferAmountWithinCompanyAccount]
(
@debit_account bigint,
@credit_account bigint,
@amount decimal(18,2),
@payment_mode nvarchar(max),
@payment_reference nvarchar(max)
)
AS
BEGIN

	BEGIN TRY
		DECLARE @balance decimal(18,2)
		DECLARE @new_balance decimal(18,2)
		DECLARE @debit_account_name nvarchar(max)
		DECLARE @credit_account_name nvarchar(max)

		SET @debit_account_name = (select account_title from tbl_CompanyAccount where id = @debit_account AND isDeleted=0)
		SET @credit_account_name = (select account_title from tbl_CompanyAccount where id = @credit_account AND isDeleted=0)


		--Credit 
		SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @credit_account ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		SET @new_balance = (@balance+@amount)
		INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@credit_account,(SELECT GETDATE()),'Transfered From - '+@debit_account_name+'','Transfer',@payment_reference,@amount,0,@new_balance)

		--Debit 
		SET @balance = (select top 1 balance from tbl_CompanyPassbook where account_id = @debit_account ORDER BY id DESC)
		IF (@balance is null)
		BEGIN
			SET @balance = 0
		END
		SET @new_balance = (@balance-@amount)
		INSERT INTO tbl_CompanyPassbook (account_id,date,payment_head,operation,reference,credit,debit,balance)
					VALUES (@debit_account,(SELECT GETDATE()),'Transfered To - '+@credit_account_name+'','Transfer',@payment_reference,0,@amount,@new_balance)


		SELECT 1 as 'status', 'Ammount has been transfered successfuly.' as message 

	END TRY
	BEGIN CATCH
		SELECT 0 as 'status', 'Failed transferring amount. Please try again.'+ERROR_MESSAGE() as message 
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_updateFilterConfiguration]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_updateFilterConfiguration]
(
	 @id bigint,
	 @fy bigint,
	 @default_filter_view_type nvarchar(max),
	 @default_filter_ranger int
)
AS
BEGIN
BEGIN TRY
 UPDATE tbl_SubscriberProfile SET 
 fy=@fy,
 default_filter_view_type=@default_filter_view_type,
 default_filter_ranger=@default_filter_ranger
 WHERE id=@id
 SELECT 1 as 'status', 'Filter has been configured successfully.' as message
 END TRY
BEGIN CATCH
	SELECT 0 as 'status', 'Failed configuring Filter. please try again.'+ERROR_MESSAGE() as message
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_updatePurchaseDeliveryStatus]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_updatePurchaseDeliveryStatus](
@id bigint,
@invoice_no nvarchar(max) null,
@delivery_status int,
@grand_total decimal(18,2)
)
AS
BEGIN

BEGIN TRY
	UPDATE tbl_PurchaseOrder SET invoice_no=@invoice_no, delivery_status=@delivery_status WHERE id=@id
	DECLARE @supplier_id bigint
	DECLARE @balance decimal(18,2)
	DECLARE @new_balance decimal(18,2)
	DECLARE @payment_head nvarchar(max)
	DECLARE @invoice_prev_credit_payment decimal(18,2)

	IF @delivery_status = 2
	BEGIN

		SET @supplier_id = (select supplier_id from tbl_PurchaseOrder where id=@id)

		SET @invoice_prev_credit_payment = (SELECT top 1 credit FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Purchase Order%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

		IF @invoice_prev_credit_payment > 0
		BEGIN
			IF @invoice_prev_credit_payment != @grand_total
			BEGIN
				--updation of delivered
				SET @payment_head = 'Purchase Order - Adjusted'

				SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @new_balance = (@balance-@invoice_prev_credit_payment)
				INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@supplier_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,0,@invoice_prev_credit_payment,@new_balance)

				SET @balance = @new_balance
				SET @new_balance = (@balance+@grand_total)
				INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@supplier_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,@grand_total,0,@new_balance)
			END
		END
		ELSE
		BEGIN
			--newly added of delivered
			SET @payment_head = (SELECT top 1 payment_head FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Purchase Order%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
			IF (@payment_head is null or @payment_head = '')
			BEGIN
				SET @payment_head = 'Purchase Order'
			END
			SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance+@grand_total)
			INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@supplier_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,@grand_total,0,@new_balance)
		END

	END
	ELSE
	BEGIN
		SET @supplier_id = (select supplier_id from tbl_PurchaseOrder where id=@id)

		SET @invoice_prev_credit_payment = (SELECT top 1 credit FROM tbl_SupplierPassbook WHERE supplier_id = @supplier_id AND payment_head like '%Purchase Order%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

		IF @invoice_prev_credit_payment > 0
		BEGIN
			--Change back draft/ordered
			SET @payment_head = 'Purchase Order - Adjusted'

			SET @balance = (select top 1 balance from tbl_SupplierPassbook where supplier_id = @supplier_id ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance-@invoice_prev_credit_payment)
			INSERT INTO tbl_SupplierPassbook (supplier_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@supplier_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,0,@invoice_prev_credit_payment,@new_balance)

		END	
	END
	SELECT 1 as 'status', 'Delivery Status Updated Successfully.' as message
END TRY
BEGIN CATCH
	SELECT 0 as 'status', 'Failed updating delivery status. please try again.'+ERROR_MESSAGE() as message
END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[usp_updateSalesDeliveryStatus]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_updateSalesDeliveryStatus](
@id bigint,
@invoice_no nvarchar(max) null,
@delivery_status int,
@grand_total decimal(18,2)
)
AS
BEGIN

BEGIN TRY
	UPDATE tbl_salesOrder SET invoice_no=@invoice_no, delivery_status=@delivery_status WHERE id=@id
	DECLARE @customer_id bigint
	DECLARE @balance decimal(18,2)
	DECLARE @new_balance decimal(18,2)
	DECLARE @payment_head nvarchar(max)
	DECLARE @invoice_prev_credit_payment decimal(18,2)

	IF @delivery_status = 2
	BEGIN

		SET @customer_id = (select customer_id from tbl_salesOrder where id=@id)

		SET @invoice_prev_credit_payment = (SELECT top 1 credit FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%sales Order%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

		IF @invoice_prev_credit_payment > 0
		BEGIN
			IF @invoice_prev_credit_payment != @grand_total
			BEGIN
				--updation of delivered
				SET @payment_head = 'Sales Order - Adjusted'

				SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
				IF (@balance is null)
				BEGIN
					SET @balance = 0
				END
				SET @new_balance = (@balance-@invoice_prev_credit_payment)
				INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@customer_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,0,@invoice_prev_credit_payment,@new_balance)

				SET @balance = @new_balance
				SET @new_balance = (@balance+@grand_total)
				INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
							VALUES (@customer_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,@grand_total,0,@new_balance)
			END
		END
		ELSE
		BEGIN
			--newly added of delivered
			SET @payment_head = (SELECT top 1 payment_head FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%sales Order%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)
			IF (@payment_head is null or @payment_head = '')
			BEGIN
				SET @payment_head = 'Sales Order'
			END
			SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance+@grand_total)
			INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@customer_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,@grand_total,0,@new_balance)
		END

	END
	ELSE
	BEGIN
		SET @customer_id = (select customer_id from tbl_salesOrder where id=@id)

		SET @invoice_prev_credit_payment = (SELECT top 1 credit FROM tbl_customerPassbook WHERE customer_id = @customer_id AND payment_head like '%sales Order%' AND operation = 'INVOICE :'+@invoice_no ORDER BY id DESC)

		IF @invoice_prev_credit_payment > 0
		BEGIN
			--Change back draft/ordered
			SET @payment_head = 'Sales Order - Adjusted'

			SET @balance = (select top 1 balance from tbl_customerPassbook where customer_id = @customer_id ORDER BY id DESC)
			IF (@balance is null)
			BEGIN
				SET @balance = 0
			END
			SET @new_balance = (@balance-@invoice_prev_credit_payment)
			INSERT INTO tbl_customerPassbook (customer_id,date,payment_head,operation,reference,credit,debit,balance)
						VALUES (@customer_id,(SELECT GETDATE()),@payment_head,'INVOICE :'+@invoice_no,'INVOICE :'+@invoice_no,0,@invoice_prev_credit_payment,@new_balance)

		END	
	END
	SELECT 1 as 'status', 'Delivery Status Updated Successfully.' as message
END TRY
BEGIN CATCH
	SELECT 0 as 'status', 'Failed updating delivery status. please try again.'+ERROR_MESSAGE() as message
END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[usp_updateSubscriberProfile]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_updateSubscriberProfile]
(
	 @id bigint,
	 @business_name nvarchar(max),
	 @logo_url nvarchar(max)='',
	 @email nvarchar(max)='',
	 @mobile nvarchar(max) ='',
	 @whatsapp nvarchar(max) ='',
	 @website nvarchar(max) ='',
	 @gst_number nvarchar(max) ='',
	 @business_address nvarchar(max) ='',
	 @currency_name nvarchar(max),
	 @currency_symbol nvarchar(max),
	 @invoice_prefix nvarchar(max)
)
AS
BEGIN
BEGIN TRY
 UPDATE tbl_SubscriberProfile SET 
 business_name=@business_name,
 logo_url=@logo_url,
 email=@email,
 mobile=@mobile,
 whatsapp=@whatsapp,
 website=@website,
 gst_number=@gst_number,
 business_address=@business_address,
 currency_name=@currency_name,
 currency_symbol=N''+@currency_symbol+'',
 invoice_prefix=@invoice_prefix 
 WHERE id=@id
 SELECT 1 as 'status', 'Profile has been updated Successfully.' as message
 END TRY
BEGIN CATCH
	SELECT 0 as 'status', 'Failed updating profile. please try again.'+ERROR_MESSAGE() as message
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_getMandatoryActions]    Script Date: 19-Jul-21 10:21:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getMandatoryActions]
AS
BEGIN
	DECLARE @raw_materials bigint
	DECLARE @sale_products bigint
	DECLARE @wastages bigint
	DECLARE @compositions bigint
	DECLARE @suppliers bigint
	DECLARE @production_units bigint
	DECLARE @company_accounts bigint
	
	SET @raw_materials = (select count(*) from tbl_RawMaterials where isDeleted=0)
	SET @sale_products = (select count(*) from tbl_SaleProducts where isDeleted=0)
	SET @wastages = (select count(*) from tbl_Wastages where isDeleted=0)
	SET @compositions = (select count(*) from tbl_CompositionAndWastage where isDeleted=0)

	SET @suppliers = (select count(*) from tbl_SupplierAccounts where isDeleted=0)
	SET @production_units = (select count(*) from tbl_ProductionUnitsAndCapacity where isDeleted=0)
	SET @company_accounts = (select count(*) from tbl_CompanyAccount where isDeleted=0)

	DECLARE @TempData TABLE
	(
		 action_name nvarchar(max),
		 is_required bit,
		 action_link nvarchar(max)
	)

	INSERT INTO @TempData
	SELECT 'Raw Material',(SELECT CASE WHEN @raw_materials = 0 THEN 1 ELSE 0 END),'/stock/raw_material_stock'
	INSERT INTO @TempData
	SELECT 'Sales Product',(SELECT CASE WHEN @sale_products = 0 THEN 1 ELSE 0 END),'/stock/sale_product_stock'
	INSERT INTO @TempData
	SELECT 'Wastage',(SELECT CASE WHEN @wastages = 0 THEN 1 ELSE 0 END),'/stock/wastage_stock'
	INSERT INTO @TempData
	SELECT 'Production Composition',(SELECT CASE WHEN @compositions = 0 THEN 1 ELSE 0 END),'/stock/composition_wastage'
	INSERT INTO @TempData
	SELECT 'Supplier',(SELECT CASE WHEN @suppliers = 0 THEN 1 ELSE 0 END),'/purchases/supplier_accounts'
	INSERT INTO @TempData
	SELECT 'Production Unit',(SELECT CASE WHEN @production_units = 0 THEN 1 ELSE 0 END),'/production/production_units'
	INSERT INTO @TempData
	SELECT 'Company Account',(SELECT CASE WHEN @company_accounts = 0 THEN 1 ELSE 0 END),'/company_account/open_companyaccounts'

	SELECT * FROM @TempData
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getTerms]    Script Date: 19-Jul-21 11:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getTerms]
AS
BEGIN
SELECT id,term_name,due_days FROM tbl_Terms ORDER by ID asc
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveTerms]    Script Date: 19-Jul-21 11:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_saveTerms]
(
@term_name nvarchar(max),
@due_days int
)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM tbl_Terms WHERE term_name=@term_name OR due_days=@due_days)
	BEGIN
		INSERT INTO tbl_Terms(term_name,due_days) VALUES(@term_name,@due_days)
		SELECT 1 as 'status', 'Term has been added successfuly.' as message 
	END
	ELSE
	BEGIN
		SELECT 0 as 'status', 'Term is already exists. Please try with other Term Name and Due Days.' as message 
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCustomerSummary]    Script Date: 20-Jul-21 2:49:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCustomerSummary]
(
@startDate date,
@endDate date
)
AS
BEGIN
	select COALESCE(sum(credit),0) as sales_amount ,COALESCE(sum(debit),0) as recieved_amount,COALESCE((sum(credit)-sum(debit)),0) as pending_amount 
	from tbl_CustomerPassbook
	where date>=@startDate and date<=@endDate
	option (maxrecursion 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getSupplierSummary]    Script Date: 20-Jul-21 2:49:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getSupplierSummary]
(
@startDate date,
@endDate date
)
AS
BEGIN
	select COALESCE(sum(credit),0) as purchase_amount ,COALESCE(sum(debit),0) as paid_amount,COALESCE((sum(credit)-sum(debit)),0) as unpaid_amount 
	from tbl_SupplierPassbook
	where date>=@startDate and date<=@endDate
	option (maxrecursion 0)
END
GO