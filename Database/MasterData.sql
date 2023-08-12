---------------GST Data---------------
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('CGST - 0.25%',0.25,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('CGST - 5%',5,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('CGST - 12%',12,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('CGST - 18%',18,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('CGST - 28%',28,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('SGST - 0.25%',0.25,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('SGST - 5%',5,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('SGST - 12%',12,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('SGST - 18%',18,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('SGST - 28%',28,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('IGST - 0.25%',0.25,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('IGST - 5%',5,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('IGST - 12%',12,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('IGST - 18%',18,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('IGST - 28%',28,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('UGST - 0.25%',0.25,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('UGST - 5%',5,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('UGST - 12%',12,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('UGST - 18%',18,0)
INSERT INTO tbl_Gst (name,rate,isDeleted) VALUES('UGST - 28%',28,0)

---------------UNITS Data---------------
INSERT INTO tbl_Units (name,isDeleted) VALUES('Kgs.-Kilograms',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Gms.-Grams',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Qntl-Quintals',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Ltr.-Liters',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Ml.-Milliliters',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Pcs.-Pieces',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Bdl.-Bundles',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Pks.-Packs',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Ft.-Feet',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('In.-Inches',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('M.-Meters',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('CM.-Centimeters',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Km.-Kilometers',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Mm.-Millimeters',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Mi.-Micrometers',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Nm.-Nanometers',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Mile',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Yrd.-Yard',0)
INSERT INTO tbl_Units (name,isDeleted) VALUES('Km.-Kilometres',0)

---------------FINANCIAL YEAR Data---------------
INSERT INTO tbl_FY (display_name,start_day,start_month,end_day,end_month) VALUES('01 April - 31 March',1,4,31,3)
INSERT INTO tbl_FY (display_name,start_day,start_month,end_day,end_month) VALUES('01 January - 31 December',1,1,31,12)

---------------SUBSCRIBER PROFILE Data---------------
INSERT INTO tbl_SubscriberProfile
(business_name,logo_url,email,mobile,whatsapp,website,gst_number,business_address,currency_name,currency_symbol,
invoice_prefix,status,service_provider_message,fy,default_filter_view_type,default_filter_ranger) VALUES 
(
'My Manufacturing Company',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Indian Rupees',N'₹','INV-',1,'Welcome to AlongX ERP',1,'Month',0
)

---------------USER ROLES Data---------------
INSERT INTO tbl_Roles (role_name,role_description,isDeleted) VALUES('Admin','Full Control',0)
INSERT INTO tbl_Roles (role_name,role_description,isDeleted) VALUES('Operator','Read & Create Control Except Reports, Company Accounts and Settings',0)
INSERT INTO tbl_Roles (role_name,role_description,isDeleted) VALUES('Reporter','Read Reports Only',0)
INSERT INTO tbl_Roles (role_name,role_description,isDeleted) VALUES('Operator & Reporter','Read,Create and Report Except Company Accounts and Settings',0)

---------------DEFAULT USER Data---------------
INSERT INTO tbl_Users (login_id,password,role_id,is_active,full_name,email,mobile,last_login,isDeleted) 
VALUES ('admin','rmcpxCuV0deO9wURvkSknRGrPnN48/r1EhIt+ifNRJqQovLzxgGwWxJh+PpMYvZi',1,1,'App Admin','admin@noemail.com',NULL,(SELECT GETDATE()),0)
--Password - Welcome2AlongX@2021
---------------NOTIFICATIONS Data---------------
INSERT INTO tbl_Notifications (date,message,is_important,isDeleted) 
VALUES ((SELECt GETDATE()),'Thank you for choosing AlongX smart ERP for your smart manufacturing business.',1,0)
INSERT INTO tbl_Notifications (date,message,is_important,isDeleted) 
VALUES ((SELECt GETDATE()),'Hi Admin, Exciting features comming soon. <a href="http://www.alongx.com" target="_blank">stay tune....</a>',1,1)

---------------TERMS Data---------------
INSERT INTO tbl_Terms(term_name,due_days) VALUES('Due to Reciept',0)
INSERT INTO tbl_Terms(term_name,due_days) VALUES('Net 15',15)
INSERT INTO tbl_Terms(term_name,due_days) VALUES('Net 30',30)
INSERT INTO tbl_Terms(term_name,due_days) VALUES('Net 60',60)