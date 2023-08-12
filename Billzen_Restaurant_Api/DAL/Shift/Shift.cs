using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Shift
{
    public class Shift
    {
        public IList<ShiftModel> GetShift(long shiftId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getshift", new List<SqlStoreProcedureEntity>()
                {

                     new SqlStoreProcedureEntity()
                    {
                        name = "shiftId",
                        datatype = SqlDbType.BigInt,
                        value = shiftId.ToString()
                    },
                });

                return (IList<ShiftModel>)dataTable.AsEnumerable().Select<DataRow, ShiftModel>((Func<DataRow, ShiftModel>)(row => new ShiftModel()
                {
                    shiftId = row.Field<long>("shiftId"),
                    shift_name = row.Field<string>("shift_name"),
                    shift_start_date = row.Field<DateTime>("shift_start_date").ToString(),
                    shift_end_date = row.Field<DateTime>("shift_end_date").ToString(),
                    shift_start_time = row.Field<TimeSpan>("shift_start_time").ToString(),
                    shift_end_time = row.Field<TimeSpan>("shift_end_time").ToString(),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<ShiftModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveShift(ShiftModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveshift", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "shiftId",
                    datatype = SqlDbType.BigInt,
                    value = Request.shiftId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "shift_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.shift_name
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "shift_start_date",
                    datatype = SqlDbType.Date,
                    value = Request.shift_start_date.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "shift_end_date",
                    datatype = SqlDbType.Date,
                    value = Request.shift_end_date.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "shift_start_time",
                    datatype = SqlDbType.Time,
                    value = Request.shift_start_time.ToString()
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

        public DBResponse UpadateIsActive(ShiftModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateShiftStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "shiftId",
                    datatype = SqlDbType.BigInt,
                    value =Request.shiftId.ToString()
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