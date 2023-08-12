using Billzen_Restaurant_Api.Models;
using Billzen_Restaurant_Api.Models.Company;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Company
{
    public class Company
    {
        public IList<CompanyModel> GetCompany(long companyid)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getcompany", new List<SqlStoreProcedureEntity>()
                {
                     new SqlStoreProcedureEntity()
                  {
                    name = "companyid",
                    datatype = SqlDbType.BigInt,
                    value =companyid.ToString()
                  },
                });

                return (IList<CompanyModel>)dataTable.AsEnumerable().Select<DataRow, CompanyModel>((Func<DataRow, CompanyModel>)(row => new CompanyModel()
                {
                    companyid = row.Field<long>("companyid"),
                    companyname = row.Field<string>("companyname"),
                    logo = row.Field<string>("logo"),
                    contactnumber = row.Field<string>("contactnumber"),
                    email = row.Field<string>("email"),
                    address = row.Field<string>("address"),
                    gstnumber = row.Field<string>("gstnumber"),
                    isactive = row.Field<bool>("isactive")

                })).ToList<CompanyModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveCompany(CompanyModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_savecompany", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "companyid",
                    datatype = SqlDbType.BigInt,
                    value = Request.companyid.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "companyname",
                    datatype = SqlDbType.NVarChar,
                    value = Request.companyname
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "logo",
                    datatype = SqlDbType.NVarChar,
                    value = Request.logo    
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "contactnumber",
                    datatype = SqlDbType.NVarChar,
                    value = Request.contactnumber
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "email",
                    datatype = SqlDbType.NVarChar,
                    value = Request.email
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "address",
                    datatype = SqlDbType.NVarChar,
                    value = Request.address 
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "gstnumber",
                    datatype = SqlDbType.NVarChar,
                    value = Request.gstnumber
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
        public DBResponse UpadateIsActive(CompanyModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateCompanyStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "companyid",
                    datatype = SqlDbType.BigInt,
                    value =Request.companyid.ToString()
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