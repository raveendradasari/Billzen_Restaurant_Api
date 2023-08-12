using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Greeting
{
    public class Greeting
    {
        public IList<GreetingModel> GetGreeting(long greeting_id)
        {
            try
            {
                DataSet ds = new SqlQueryDataSet().Execute("usp_getGreetings", new List<SqlStoreProcedureEntity>()
                {
                     new SqlStoreProcedureEntity()
                  {
                    name = "greeting_id",
                    datatype = SqlDbType.BigInt,
                    value = greeting_id.ToString()
                  },

                });
                return (IList<GreetingModel>)ds.Tables[0].AsEnumerable().Select<DataRow, GreetingModel>((Func<DataRow, GreetingModel>)(row => new GreetingModel()
                {
                    greeting_id = row.Field<long>("greeting_id"),
                    greeting_message = row.Field<string>("greeting_message"),
                    shift_start_date = row.Field<DateTime>("shift_start_date").ToString(),
                    shift_start_time = row.Field<TimeSpan>("shift_start_time").ToString(),
                    shift_end_date = row.Field<DateTime>("shift_end_date").ToString(),
                    shift_end_time = row.Field<TimeSpan>("shift_end_time").ToString(),
                    isactive = row.Field<bool>("isactive"),


                    TransactionGreeting = (from tgm in ds.Tables[1].AsEnumerable()
                                        where tgm.Field<long>("greeting_id") == row.Field<long>("greeting_id")
                                        select new GreetingTransactionModel
                                        {
                                            transactionGreetingId = tgm.Field<long>("transactionGreetingId"),
                                            greeting_id = tgm.Field<long>("greeting_id"),
                                            transactionId = tgm.Field<long>("transactionId"),
                                            transactionName = tgm.Field<string>("transactionName"),
                                            isactive = tgm.Field<bool>("isactive"),
                                        }).ToList(),
                })).ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveGreeting(GreetingModel Request)
        {
            DBResponse response = new DBResponse();
            //SqlTransaction objTrans = null;
            try
            {
                // objTrans = Connection.sqlConnection.BeginTransaction();
                DataTable dataTable = new SqlQuery().Execute("usp_saveGreetings", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "greeting_id",
                    datatype = SqlDbType.BigInt,
                    value = Request.greeting_id.ToString()
                  },
                  //new SqlStoreProcedureEntity()
                  //{
                  //  name = "transactionId",
                  //  datatype = SqlDbType.BigInt,
                  //  value = Request.transactionId.ToString()
                  //},

                  new SqlStoreProcedureEntity()
                  {
                    name = "greeting_message",
                    datatype = SqlDbType.NVarChar,
                    value = Request.greeting_message
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "shift_start_date",
                    datatype = SqlDbType.Date,
                    value = Request.shift_start_date.ToString()
                  },

                     new SqlStoreProcedureEntity()
                  {
                    name = "shift_start_time",
                    datatype = SqlDbType.Time,
                    value = Request.shift_start_time.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "shift_end_date",
                    datatype = SqlDbType.Date,
                    value = Request.shift_end_date.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "shift_end_time",
                    datatype = SqlDbType.Time,
                    value = Request.shift_end_time.ToString()
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "isactive",
                    datatype = SqlDbType.Bit,
                    value = Request.isactive.ToString()
                  },

                });
                long greeting_id = Convert.ToInt32(dataTable.Rows[0][0]);
                long transactionGreetingId = Convert.ToInt32(dataTable.Rows[0][0]);

                if (greeting_id != 0 && transactionGreetingId != 0)
                {
                    if (Request.TransactionGreeting != null)
                    {
                        try
                        {
                            DataTable dataTable1 = new DataTable();

                            foreach (var salp in Request.TransactionGreeting)
                            {

                                dataTable1 = new SqlQuery().Execute("usp_saveTransactionGreetings", new List<SqlStoreProcedureEntity>()
                        {
                           new SqlStoreProcedureEntity()
                           {
                               name = "transactionGreetingId",
                               datatype = SqlDbType.BigInt,
                               value = salp.transactionGreetingId.ToString()
                           },
                                  new SqlStoreProcedureEntity()
                                  {
                                      name = "greeting_id",
                                      datatype = SqlDbType.BigInt,
                                      value = greeting_id.ToString()
                                  },
                              new SqlStoreProcedureEntity()
                              {
                                  name = "transactionId",
                                  datatype = SqlDbType.BigInt,
                                  value = salp.transactionId.ToString()
                              },

                              //new SqlStoreProcedureEntity()
                              //  {
                              //    name = "transactionName",
                              //    datatype = SqlDbType.NVarChar,
                              //    value = salp.transactionName
                              //  },

                              new SqlStoreProcedureEntity()
                           {
                               name = "isactive",
                               datatype = SqlDbType.Bit,
                               value = salp.isactive.ToString()
                           },
                        });

                            }
                            response.status = false;
                            response.message = "Transaction Greeting saved ";
                        }
                        catch (Exception x)
                        {
                            response.status = false;
                            response.message = "errror in Transaction Greeting data";
                        }


                    }
                    long itemTaxId = Convert.ToInt32(dataTable.Rows[0][0]);



                    response.status = true;
                    response.message = dataTable.Rows[0][2].ToString();
                }
                else
                {
                    response.status = false;
                    response.message = "error in Greeting data";
                }

            }

            catch (Exception ex)
            {
                //objTrans.Rollback();
                response.status = false;
                response.message = ex.Message.ToString();
            }
            return response;
        }

        public DBResponse UpadateIsActive(GreetingModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateGreetingStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "greeting_id",
                    datatype = SqlDbType.BigInt,
                    value =Request.greeting_id.ToString()
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