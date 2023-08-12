using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Printer
{
    public class Printer
    {
        public IList<PrinterModel> GetPrinter()
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_GetAllPrinters", new List<SqlStoreProcedureEntity>()
                {
                    // new SqlStoreProcedureEntity()
                    //{
                    //    name = "id",
                    //     datatype = SqlDbType.BigInt,
                    //    value = id.ToString()
                    //},

                });

                return (IList<PrinterModel>)dataTable.AsEnumerable().Select<DataRow, PrinterModel>((Func<DataRow, PrinterModel>)(row => new PrinterModel()
                {
                    printer_id = row.Field<long>("printer_id"),
                    printer_name = row.Field<string>("printer_name"),
                })).ToList<PrinterModel>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SavePrinter(PrinterModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_SavePrinter", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "printer_id",
                    datatype = SqlDbType.BigInt,
                    value = Request.printer_id.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "printer_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.printer_name
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

        public DBResponse DeletePrinter(PrinterModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_DeletePrinterById", new List<SqlStoreProcedureEntity>()
                {
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


    }
}