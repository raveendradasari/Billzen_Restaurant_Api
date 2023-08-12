using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.User
{
    public class User
    {
        public DBResponse SaveUser(UserModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveUsers", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "id",
                    datatype = SqlDbType.BigInt,
                    value = Request.id.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "role_id",
                    datatype = SqlDbType.BigInt,
                    value = Request.role_id.ToString()
                  },
                  
                  new SqlStoreProcedureEntity()
                  {
                    name = "login_id",
                    datatype = SqlDbType.NVarChar,
                    value = Request.login_id
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "password",
                    datatype = SqlDbType.NVarChar,
                    value = Request.password
                  },
                 
                  new SqlStoreProcedureEntity()
                  {
                    name = "full_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.full_name
                  },
                   
                    new SqlStoreProcedureEntity()
                  {
                    name = "is_active",
                    datatype = SqlDbType.Bit,
                    value = Request.is_active.ToString()
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

        public IList<UserModel> GetUsers(long id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getUsers", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "id",
                        datatype = SqlDbType.BigInt,
                        value = id.ToString()
                    },
                });

                return (IList<UserModel>)dataTable.AsEnumerable().Select<DataRow, UserModel>((Func<DataRow, UserModel>)(row => new UserModel()
                {
                    id = row.Field<long>("id"),
                    role_id = row.Field<long>("role_id"),
                    login_id = row.Field<string>("login_id"),
                    password = row.Field<string>("password"),
                    full_name = row.Field<string>("full_name"),
                    is_active = row.Field<bool>("is_active"),

                })).ToList<UserModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse UpadateIsActive(UserModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateUserStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "id",
                    datatype = SqlDbType.BigInt,
                    value =Request.id.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "is_active",
                    datatype = SqlDbType.Bit,
                    value =Request.is_active.ToString()
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