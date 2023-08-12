using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Customer
{
    public class Customer
    {
        public IList<CustomerModel> GetCustomer(long customerId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getCustomer", new List<SqlStoreProcedureEntity>()
                {
                     new SqlStoreProcedureEntity()
                  {
                    name = "customerId",
                    datatype = SqlDbType.BigInt,
                    value =customerId.ToString()
                  },
                });

                return (IList<CustomerModel>)dataTable.AsEnumerable().Select<DataRow, CustomerModel>((Func<DataRow, CustomerModel>)(row => new CustomerModel()
                {
                    customerId = row.Field<long>("customerId"),
                    customer_name = row.Field<string>("customer_name"),
                    city = row.Field<string>("city"),
                    state = row.Field<string>("state"),
                    pincode = row.Field<string>("pincode"),
                    country = row.Field<string>("country"),
                    Mobilenumber = row.Field<string>("Mobilenumber"),
                    billing_address = row.Field<string>("billing_address"),
                    account_type = row.Field<string>("account_type"),
                    opening_balance = row.Field<decimal>("opening_balance"),
                    credit_allowed = row.Field<string>("credit_allowed"),
                    credit_limit = row.Field<decimal>("credit_limit"),
                    pan_no = row.Field<string>("pan_no"),
                    Gstin = row.Field<string>("Gstin"),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<CustomerModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveCustomer(CustomerModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_savecustomer", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "customerId",
                    datatype = SqlDbType.BigInt,
                    value = Request.customerId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "customer_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.customer_name
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "city",
                    datatype = SqlDbType.NVarChar,
                    value = Request.city
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "state",
                    datatype = SqlDbType.NVarChar,
                    value = Request.state
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "pincode",
                    datatype = SqlDbType.NVarChar,
                    value = Request.pincode
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "country",
                    datatype = SqlDbType.NVarChar,
                    value = Request.country
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "Mobilenumber",
                    datatype = SqlDbType.NVarChar,
                    value = Request.Mobilenumber
                  },
                     new SqlStoreProcedureEntity()
                  {
                    name = "billing_address",
                    datatype = SqlDbType.NVarChar,
                    value = Request.billing_address
                  },
                      new SqlStoreProcedureEntity()
                  {
                    name = "account_type",
                    datatype = SqlDbType.NVarChar,
                    value = Request.account_type
                  },
                       new SqlStoreProcedureEntity()
                  {
                    name = "opening_balance",
                    datatype = SqlDbType.Decimal,
                    value = Request.opening_balance.ToString()
                  },
                       new SqlStoreProcedureEntity()
                  {
                    name = "credit_allowed",
                    datatype = SqlDbType.NVarChar,
                    value = Request.credit_allowed
                  },
                       new SqlStoreProcedureEntity()
                  {
                    name = "credit_limit",
                    datatype = SqlDbType.Decimal,
                    value = Request.credit_limit.ToString()
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "pan_no",
                    datatype = SqlDbType.NVarChar,
                    value = Request.pan_no
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "Gstin",
                    datatype = SqlDbType.NVarChar,
                    value = Request.Gstin
                  },
                     new SqlStoreProcedureEntity()
                  {
                    name = "isactive",
                    datatype = SqlDbType.Bit,
                    value = Request.isactive.ToString()
                  },
                });
                response.status = Convert.ToBoolean(dataTable.Rows[0][0]);
                response.message = dataTable.Rows[0][1].ToString();
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
            }
            return response;
        }

        public DBResponse UpadateIsActive(CustomerModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateCustomerStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "customerId",
                    datatype = SqlDbType.BigInt,
                    value =Request.customerId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "isactive",
                    datatype = SqlDbType.Bit,
                    value =Request.isactive.ToString()
                  },


                });
                response.status = Convert.ToBoolean(dataTable.Rows[0][0]);
                response.message = dataTable.Rows[0][1].ToString();
                //response.indentno = Convert.ToInt64(dataTable.Rows[0][2]);
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
            }
            return response;
        }
    }
}