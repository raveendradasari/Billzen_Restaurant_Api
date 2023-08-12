using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Transaction
{
    public class Transaction
    {
        public IList<TransactionModel> GetTransaction(long transactionId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getTransaction", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "transactionId",
                        datatype = SqlDbType.BigInt,
                        value = transactionId.ToString()
                    },
                });

                return (IList<TransactionModel>)dataTable.AsEnumerable().Select<DataRow, TransactionModel>((Func<DataRow, TransactionModel>)(row => new TransactionModel()
                {
                    transactionId = row.Field<long>("transactionId"),
                    transactionName = row.Field<string>("transactionName"),
                    isActive = row.Field<bool>("isActive"),

                })).ToList<TransactionModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveTransaction(TransactionModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_SaveTransaction", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "transactionId",
                    datatype = SqlDbType.BigInt,
                    value = Request.transactionId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "transactionName",
                    datatype = SqlDbType.NVarChar,
                    value = Request.transactionName
                  },
                   
                    new SqlStoreProcedureEntity()
                  {
                    name = "isActive",
                    datatype = SqlDbType.Bit,
                    value = Request.isActive.ToString()
                  }

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

        public DBResponse UpadateIsActive(TransactionModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateTransactionStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "transactionId",
                    datatype = SqlDbType.BigInt,
                    value =Request.transactionId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "isActive",
                    datatype = SqlDbType.Bit,
                    value =Request.isActive.ToString()
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