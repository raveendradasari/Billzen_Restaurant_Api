--CREATE DATABASE <<database_name_of_the_subscriber>>
--USE <<database_name_of_the_subscriber>>

/****** Object:  Table [dbo].[tbl_ActivityLog]    Script Date: 18-Jul-21 10:30:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ActivityLog](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[action_performer_name] [nvarchar](max) NOT NULL,
	[action_performer_login_id] [nvarchar](max) NOT NULL,
	[action_title] [nvarchar](max) NOT NULL,
	[action_content] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CompanyAccount]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CompanyAccount](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[account_title] [nvarchar](max) NOT NULL,
	[account_number] [nvarchar](max) NOT NULL,
	[account_type] [nvarchar](max) NOT NULL,
	[account_ifsc_code] [nvarchar](max) NOT NULL,
	[opening_balance] [decimal](18, 2) NOT NULL,
	[is_default] [bit] NOT NULL,
	[isDeleted] [bit] NOT NULL,
 CONSTRAINT [PK__tbl_Comp__3213E83F9F1AF1D1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CompanyPassbook]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CompanyPassbook](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[account_id] [bigint] NOT NULL,
	[date] [date] NOT NULL,
	[payment_head] [nvarchar](max) NOT NULL,
	[operation] [nvarchar](max) NULL,
	[reference] [nvarchar](max) NULL,
	[credit] [decimal](18, 2) NULL,
	[debit] [decimal](18, 2) NULL,
	[balance] [decimal](18, 2) NULL,
 CONSTRAINT [PK__tbl_Comp__3213E83F00F1A514] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CompositionAndWastage]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CompositionAndWastage](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[sale_product_id] [bigint] NULL,
	[raw_material_id] [bigint] NULL,
	[wastage_id] [bigint] NULL,
	[utilize_quantity] [decimal](18, 2) NOT NULL,
	[wastage_quantity] [decimal](18, 2) NOT NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK__tbl_Comp__3213E83F90112253] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CustomerAccounts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CustomerAccounts](
	[id] [bigint] IDENTITY(100,1) NOT NULL,
	[customer_name] [nvarchar](max) NOT NULL,
	[poc_name] [nvarchar](max) NOT NULL,
	[email] [nvarchar](100) NULL,
	[phone] [nvarchar](max) NULL,
	[fax] [nvarchar](max) NULL,
	[mobile] [nvarchar](max) NOT NULL,
	[whatsapp] [nvarchar](max) NULL,
	[website] [nvarchar](max) NULL,
	[address] [nvarchar](max) NOT NULL,
	[gst_registration_type] [nvarchar](max) NOT NULL,
	[gstin] [nvarchar](max) NULL,
	[pan_or_tan] [nvarchar](max) NULL,
	[bank_account_number] [nvarchar](max) NULL,
	[opening_balance] [decimal](18, 0) NOT NULL,
	[as_of] [date] NULL,
	[terms] [int] NOT NULL,
	[notes] [nvarchar](max) NOT NULL,
	[date_of_registration] [date] NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CustomerPassbook]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CustomerPassbook](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[customer_id] [bigint] NOT NULL,
	[date] [date] NOT NULL,
	[payment_head] [nvarchar](max) NOT NULL,
	[operation] [nvarchar](max) NULL,
	[reference] [varchar](max) NULL,
	[credit] [decimal](18, 2) NULL,
	[debit] [decimal](18, 2) NULL,
	[balance] [decimal](18, 2) NULL,
 CONSTRAINT [PK__tbl_Supp__3213E83F1B6A57Bs3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Expenditures]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Expenditures](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[payment_head] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
	[payment_reference] [nvarchar](max) NOT NULL,
	[date] [datetime] NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[gst_id] [bigint] NULL,
	[is_regular_expenditure] [bit] NOT NULL,
	[debit_account] [bigint] NOT NULL,
	[payment_mode] [nvarchar](max) NULL,
	[isDeleted] [bit] NOT NULL,
 CONSTRAINT [PK__tbl_expe__3213E83FE1E277A9] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_FY]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_FY](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[display_name] [nvarchar](max) NOT NULL,
	[start_day] [int] NOT NULL,
	[start_month] [int] NOT NULL,
	[end_day] [int] NOT NULL,
	[end_month] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Gst]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Gst](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[rate] [decimal](18, 2) NOT NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK__tbl_Gst__3213E83F8694F8AA] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Notifications]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Notifications](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[is_important] [bit] NULL,
	[isDeleted] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_PinnedShortcuts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_PinnedShortcuts](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[login_id] [nvarchar](max) NOT NULL,
	[shortcut_title] [nvarchar](max) NOT NULL,
	[shortcut_url] [nvarchar](max) NOT NULL,
	[shortcut_icon] [nvarchar](max) NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Productions]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Productions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[production_unit_id] [bigint] NULL,
	[functioning_hours] [int] NULL,
	[sale_product_id] [bigint] NULL,
	[production_quantity] [decimal](18, 2) NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK__tbl_Prod__3213E83F075590A0] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_ProductionUnitsAndCapacity]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ProductionUnitsAndCapacity](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[unit_name] [nvarchar](max) NOT NULL,
	[unit_description] [nvarchar](max) NOT NULL,
	[production_capacity_per_hour] [decimal](18, 2) NOT NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK__tbl_Prod__3213E83F50F79334] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_PurchaseOrder]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_PurchaseOrder](
	[id] [bigint] IDENTITY(100,1) NOT NULL,
	[supplier_id] [bigint] NULL,
	[invoice_no] [nvarchar](max) NOT NULL,
	[purchase_date] [date] NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[whatsapp] [nvarchar](max) NULL,
	[shipping_via] [nvarchar](max) NULL,
	[supplier_mailing_address] [nvarchar](max) NOT NULL,
	[shipping_to] [nvarchar](max) NOT NULL,
	[memo] [nvarchar](max) NULL,
	[message_to_spplier] [nvarchar](max) NULL,
	[raw_materials] [nvarchar](max) NOT NULL,
	[delivery_status] [int] NOT NULL,
	[payment_status] [int] NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_RawMaterials]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_RawMaterials](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[item_name] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[item_type] [nvarchar](max) NULL,
	[item_group] [nvarchar](max) NULL,
	[unit] [bigint] NOT NULL,
	[rate] [decimal](18, 2) NOT NULL,
	[gst] [bigint] NOT NULL,
	[low_stock_alert] [decimal](18, 0) NULL,
	[isDeleted] [bit] NOT NULL,
 CONSTRAINT [PK__tbl_RawM__3213E83F45DC2F5D] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_RawMaterialStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_RawMaterialStock](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[item_id] [bigint] NOT NULL,
	[date] [date] NOT NULL,
	[reference] [nvarchar](max) NULL,
	[in_quantity] [decimal](18, 2) NULL,
	[out_quantity] [decimal](18, 2) NULL,
	[balance_quantity] [decimal](18, 2) NULL,
 CONSTRAINT [PK__tbl_RawM__3213E83F107BB9A4] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Roles]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Roles](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](max) NOT NULL,
	[role_description] [nvarchar](max) NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SaleProducts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SaleProducts](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[item_name] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[item_type] [nvarchar](max) NULL,
	[item_group] [nvarchar](max) NULL,
	[unit] [bigint] NOT NULL,
	[rate] [decimal](18, 2) NOT NULL,
	[gst] [bigint] NOT NULL,
	[low_stock_alert] [decimal](18, 0) NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SaleProductStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SaleProductStock](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[item_id] [bigint] NOT NULL,
	[date] [date] NOT NULL,
	[reference] [nvarchar](max) NULL,
	[in_quantity] [decimal](18, 2) NULL,
	[out_quantity] [decimal](18, 2) NULL,
	[balance_quantity] [decimal](18, 2) NULL,
 CONSTRAINT [PK__tbl_Sale__3213E83F7F90A4DA] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SalesOrder]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SalesOrder](
	[id] [bigint] IDENTITY(100,1) NOT NULL,
	[customer_id] [bigint] NULL,
	[invoice_no] [nvarchar](max) NOT NULL,
	[sales_date] [date] NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[whatsapp] [nvarchar](max) NULL,
	[shipping_via] [nvarchar](max) NULL,
	[customer_mailing_address] [nvarchar](max) NOT NULL,
	[shipping_to] [nvarchar](max) NOT NULL,
	[memo] [nvarchar](max) NULL,
	[message_to_customer] [nvarchar](max) NULL,
	[sale_products] [nvarchar](max) NOT NULL,
	[delivery_status] [int] NOT NULL,
	[payment_status] [int] NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SubscriberProfile]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SubscriberProfile](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[business_name] [nvarchar](max) NOT NULL,
	[logo_url] [nvarchar](max) NULL,
	[email] [nvarchar](max) NULL,
	[mobile] [nvarchar](max) NULL,
	[whatsapp] [nvarchar](max) NULL,
	[website] [nvarchar](max) NULL,
	[gst_number] [nvarchar](max) NULL,
	[business_address] [nvarchar](max) NULL,
	[currency_name] [nvarchar](max) NOT NULL,
	[currency_symbol] [nvarchar](max) NOT NULL,
	[invoice_prefix] [nvarchar](max) NOT NULL,
	[status] [bit] NOT NULL,
	[service_provider_message] [nvarchar](max) NULL,
	[fy] [bigint] NOT NULL,
	[default_filter_view_type] [nvarchar](10) NOT NULL,
	[default_filter_ranger] [int] NOT NULL,
 CONSTRAINT [PK__tbl_Subs__3213E83F7BE197EA] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SupplierAccounts]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SupplierAccounts](
	[id] [bigint] IDENTITY(100,1) NOT NULL,
	[supplier_name] [nvarchar](max) NOT NULL,
	[poc_name] [nvarchar](max) NOT NULL,
	[email] [nvarchar](100) NULL,
	[phone] [nvarchar](max) NULL,
	[fax] [nvarchar](max) NULL,
	[mobile] [nvarchar](max) NOT NULL,
	[whatsapp] [nvarchar](max) NULL,
	[website] [nvarchar](max) NULL,
	[address] [nvarchar](max) NOT NULL,
	[gst_registration_type] [nvarchar](max) NOT NULL,
	[gstin] [nvarchar](max) NULL,
	[pan_or_tan] [nvarchar](max) NULL,
	[bank_account_number] [nvarchar](max) NULL,
	[opening_balance] [decimal](18, 0) NOT NULL,
	[as_of] [date] NULL,
	[terms] [int] NOT NULL,
	[notes] [nvarchar](max) NOT NULL,
	[date_of_registration] [date] NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SupplierPassbook]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SupplierPassbook](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[supplier_id] [bigint] NOT NULL,
	[date] [date] NOT NULL,
	[payment_head] [nvarchar](max) NOT NULL,
	[operation] [nvarchar](max) NULL,
	[reference] [varchar](max) NULL,
	[credit] [decimal](18, 2) NULL,
	[debit] [decimal](18, 2) NULL,
	[balance] [decimal](18, 2) NULL,
 CONSTRAINT [PK__tbl_Supp__3213E83F1B6A57B3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Units]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Units](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[isDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Users]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Users](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[login_id] [nvarchar](max) NOT NULL,
	[password] [nvarchar](max) NOT NULL,
	[role_id] [bigint] NOT NULL,
	[is_active] [bit] NULL,
	[full_name] [nvarchar](max) NOT NULL,
	[email] [nvarchar](max) NULL,
	[mobile] [nvarchar](max) NULL,
	[last_login] [nvarchar](max) NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Wastages]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Wastages](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[item_name] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[item_type] [nvarchar](max) NULL,
	[item_group] [nvarchar](max) NULL,
	[unit] [bigint] NOT NULL,
	[rate] [decimal](18, 2) NOT NULL,
	[gst] [bigint] NOT NULL,
	[isDeleted] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_WastageStock]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_WastageStock](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[item_id] [bigint] NOT NULL,
	[date] [date] NOT NULL,
	[reference] [nvarchar](max) NULL,
	[in_quantity] [decimal](18, 2) NULL,
	[out_quantity] [decimal](18, 2) NULL,
	[balance_quantity] [decimal](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_WasteSale]    Script Date: 18-Jul-21 10:30:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_WasteSale](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[sale_amount] [decimal](18, 2) NOT NULL,
	[linked_details] [nvarchar](max) NOT NULL,
	[comment] [nvarchar](max) NOT NULL,
	[isDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Terms]    Script Date: 19-Jul-21 11:48:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Terms](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[term_name] [nvarchar](max) NOT NULL,
	[due_days] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_CompanyAccount] ADD  CONSTRAINT [DF_tbl_CompanyAccount_is_default]  DEFAULT ((0)) FOR [is_default]
GO
ALTER TABLE [dbo].[tbl_CompanyAccount] ADD  CONSTRAINT [DF__tbl_Compa__isDel__6D0D32F4]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_CustomerAccounts] ADD  CONSTRAINT [DF_tbl_CustomerAccounts_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_Expenditures] ADD  CONSTRAINT [DF__tbl_expen__is_re__70A8B9AE]  DEFAULT ((1)) FOR [is_regular_expenditure]
GO
ALTER TABLE [dbo].[tbl_Expenditures] ADD  CONSTRAINT [DF__tbl_expen__isDel__719CDDE7]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_Gst] ADD  CONSTRAINT [DF__tbl_Gst__isDelet__3E52440B]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_Notifications] ADD  DEFAULT ((0)) FOR [is_important]
GO
ALTER TABLE [dbo].[tbl_Notifications] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_PinnedShortcuts] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_PurchaseOrder] ADD  DEFAULT ((0)) FOR [delivery_status]
GO
ALTER TABLE [dbo].[tbl_PurchaseOrder] ADD  DEFAULT ((0)) FOR [payment_status]
GO
ALTER TABLE [dbo].[tbl_PurchaseOrder] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_RawMaterials] ADD  CONSTRAINT [DF__tbl_RawMa__isDel__45F365D3]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_Roles] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_SalesOrder] ADD  CONSTRAINT [DF_tbl_SalesOrder_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_SubscriberProfile] ADD  CONSTRAINT [DF_tbl_SubscriberProfile_status]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[tbl_SubscriberProfile] ADD  CONSTRAINT [DF_tbl_SubscriberProfile_fy]  DEFAULT ((1)) FOR [fy]
GO
ALTER TABLE [dbo].[tbl_SubscriberProfile] ADD  CONSTRAINT [DF_tbl_SubscriberProfile_default_filter_view_type]  DEFAULT (N'Month') FOR [default_filter_view_type]
GO
ALTER TABLE [dbo].[tbl_SubscriberProfile] ADD  CONSTRAINT [DF_tbl_SubscriberProfile_default_filter_ranger]  DEFAULT ((-1)) FOR [default_filter_ranger]
GO
ALTER TABLE [dbo].[tbl_SupplierAccounts] ADD  DEFAULT ((0)) FOR [opening_balance]
GO
ALTER TABLE [dbo].[tbl_SupplierAccounts] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_Units] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_Users] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_Users] ADD  DEFAULT ('') FOR [last_login]
GO
ALTER TABLE [dbo].[tbl_Users] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[tbl_WasteSale] ADD  DEFAULT ((0)) FOR [isDeleted]