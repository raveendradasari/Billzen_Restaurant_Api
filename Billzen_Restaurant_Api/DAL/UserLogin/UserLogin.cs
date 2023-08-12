using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.UserLogin
{
    public class UserLogin
    {
        public string GetUserLogin(string login_id, string password)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("GetUserLogin", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                  {
                    name = "login_id",
                    datatype = SqlDbType.NVarChar,
                    value = login_id
                  },
                      new SqlStoreProcedureEntity()
                  {
                    name = "password",
                    datatype = SqlDbType.NVarChar,
                    value = password
                  },
                });



                string id = dataTable.Rows[0]["id"].ToString();
                return id;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}