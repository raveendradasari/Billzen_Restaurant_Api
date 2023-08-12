using Billzen_Restaurant_Api.DAL.Tax;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Units
{
    public class Units
    {
        public IList<UnitsModel> GetUnis(long id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getUnits", new List<SqlStoreProcedureEntity>()
                {
                     new SqlStoreProcedureEntity()
                    {
                        name = "id",
                         datatype = SqlDbType.BigInt,
                        value = id.ToString()
                    },

                });

                return (IList<UnitsModel>)dataTable.AsEnumerable().Select<DataRow, UnitsModel>((Func<DataRow, UnitsModel>)(row => new UnitsModel()
                {
                    id = row.Field<long>("id"),
                    name = row.Field<string>("name"),
                    isactive = row.Field<bool>("isactive")
                })).ToList<UnitsModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveUnits(UnitsModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_SaveUnits", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "id",
                    datatype = SqlDbType.BigInt,
                    value = Request.id.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.name
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

        public DBResponse UpadateIsActive(UnitsModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateUnitStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "id",
                    datatype = SqlDbType.BigInt,
                    value =Request.id.ToString()
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