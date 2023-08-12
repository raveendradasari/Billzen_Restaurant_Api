using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Roles
{
    public class Roles
    {
        public IList<RolesModel> GetRoles(long id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getRoles", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "id",
                        datatype = SqlDbType.BigInt,
                        value = id.ToString()
                    },
                });

                return (IList<RolesModel>)dataTable.AsEnumerable().Select<DataRow, RolesModel>((Func<DataRow, RolesModel>)(row => new RolesModel()
                {
                    id = row.Field<long>("id"),
                    role_name = row.Field<string>("role_name"),
                    role_description = row.Field<string>("role_description"),
                    isactive = row.Field<bool>("isactive")
                })).ToList<RolesModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveRoles(RolesModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_SaveRole", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "id",
                    datatype = SqlDbType.BigInt,
                    value = Request.id.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "role_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.role_name
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "role_description",
                    datatype = SqlDbType.NVarChar,
                    value = Request.role_description
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
        public DBResponse UpadateIsActive(RolesModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateRoleStatus", new List<SqlStoreProcedureEntity>()
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