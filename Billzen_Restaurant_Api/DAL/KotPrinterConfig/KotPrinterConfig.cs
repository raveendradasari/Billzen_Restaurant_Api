using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.KotPrinterConfig
{
    public class KotPrinterConfig
    {
        public DBResponse SaveKotPrinterCongig(KotPrinterConfigModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveKotPrinterConfig", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "kotPrintId",
                    datatype = SqlDbType.BigInt,
                    value = Request.kotPrintId.ToString()
                  },

                 new SqlStoreProcedureEntity()
                  {
                    name = "transactionId",
                    datatype = SqlDbType.BigInt,
                    value = Request.transactionId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "subcategoryId",
                    datatype = SqlDbType.BigInt,
                    value = Request.subcategoryId.ToString()
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "itemId",
                    datatype = SqlDbType.BigInt,
                    value = Request.itemId.ToString()
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "printer_id",
                    datatype = SqlDbType.BigInt,
                    value = Request.printer_id.ToString()
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
        public IList<KotPrinterConfigModel> GetKotPrinterConfig(long kotPrintId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_GetKotPrinterConfig", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "kotPrintId",
                        datatype = SqlDbType.BigInt,
                        value = kotPrintId.ToString()
                    },
                });

                return (IList<KotPrinterConfigModel>)dataTable.AsEnumerable().Select<DataRow, KotPrinterConfigModel>((Func<DataRow, KotPrinterConfigModel>)(row => new KotPrinterConfigModel()
                {
                    kotPrintId = row.Field<long>("kotPrintId"),
                    transactionId = row.Field<long>("transactionId"),
                    subcategoryId = row.Field<long>("subcategoryId"),
                    itemId = row.Field<long>("itemId"),
                    printer_id = row.Field<long>("printer_id"),

                })).ToList<KotPrinterConfigModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse DeleteKotPrinterConfig(long? transactionId, long? subcategoryId, long? itemId, long? printerId)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("USP_DeleteKotPrinterConfig", new List<SqlStoreProcedureEntity>()
        {
            new SqlStoreProcedureEntity()
            {
                name = "transactionId",
                datatype = SqlDbType.BigInt,
                value = transactionId.HasValue ? transactionId.Value.ToString() : null
            },
            new SqlStoreProcedureEntity()
            {
                name = "subcategoryId",
                datatype = SqlDbType.BigInt,
                value = subcategoryId.HasValue ? subcategoryId.Value.ToString() : null
            },
            new SqlStoreProcedureEntity()
            {
                name = "itemId",
                datatype = SqlDbType.BigInt,
                value = itemId.HasValue ? itemId.Value.ToString() : null
            },
            new SqlStoreProcedureEntity()
            {
                name = "printer_id",
                datatype = SqlDbType.BigInt,
                value = printerId.HasValue ? printerId.Value.ToString() : null
            }
        });

                if (dataTable.Rows.Count > 0)
                {
                    response.status = Convert.ToInt32(dataTable.Rows[0]["status"]) == 1;
                    response.message = dataTable.Rows[0]["message"].ToString();
                }
                else
                {
                    response.status = false; // Status indicating no result
                    response.message = "No result from the stored procedure.";
                }
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message;
            }
            return response;
        }



    }
}