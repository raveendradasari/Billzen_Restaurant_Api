using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Tax
{
    public class Tax
    {
        public IList<taxesModel> GetTaxes(long taxId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getTax", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "taxId",
                        datatype = SqlDbType.BigInt,
                        value = taxId.ToString()
                    },
                });

                return (IList<taxesModel>)dataTable.AsEnumerable().Select<DataRow, taxesModel>((Func<DataRow, taxesModel>)(row => new taxesModel()
                {
                    taxId = row.Field<long>("taxId"),
                    transactionId = row.Field<long>("transactionId"),
                    taxName = row.Field<string>("taxName"),
                    transactionName = row.Field<string>("transactionName"),
                    tax_percent = row.Field<string>("tax_percent"),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<taxesModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveTax(taxesModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveTax", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "taxId",
                    datatype = SqlDbType.BigInt,
                    value = Request.taxId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "transactionId",
                    datatype = SqlDbType.BigInt,
                    value = Request.transactionId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "taxName",
                    datatype = SqlDbType.NVarChar,
                    value = Request.taxName
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "tax_percent",
                    datatype = SqlDbType.NVarChar,
                    value = Request.tax_percent
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
        public DBResponse UpadateIsActive(taxesModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateTaxStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "taxId",
                    datatype = SqlDbType.BigInt,
                    value =Request.taxId.ToString()
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