using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Table
{
    public class Table
    {
        public IList<TableModel> GetTable()
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_gettable", new List<SqlStoreProcedureEntity>()
                {
                  //   new SqlStoreProcedureEntity()
                  //{
                  //  name = "tableId",
                  //  datatype = SqlDbType.BigInt,
                  //  value =tableId.ToString()
                  //},

                });

                return (IList<TableModel>)dataTable.AsEnumerable().Select<DataRow, TableModel>((Func<DataRow, TableModel>)(row => new TableModel()
                {
                    tableId = row.Field<long>("tableId"),
                    name = row.Field<string>("name"),
                    sectionId = row.Field<long>("sectionId"),
                    Section_name = row.Field<string>("Section_name"),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<TableModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveTable(TableModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_savetable", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "tableId",
                    datatype = SqlDbType.BigInt,
                    value = Request.tableId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.name
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "sectionId",
                    datatype = SqlDbType.BigInt,
                    value = Request.sectionId.ToString()
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

        public IList<TableModel> GetTableById(long tableId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getTableById", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "tableId",
                        datatype = SqlDbType.BigInt,
                        value = tableId.ToString()
                    },
                });

                return (IList<TableModel>)dataTable.AsEnumerable().Select<DataRow, TableModel>((Func<DataRow, TableModel>)(row => new TableModel()
                {
                    tableId = row.Field<long>("tableId"),
                    name = row.Field<string>("name"),

                })).ToList<TableModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse UpadateIsActive(TableModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateTableStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "tableId",
                    datatype = SqlDbType.BigInt,
                    value =Request.tableId.ToString()
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