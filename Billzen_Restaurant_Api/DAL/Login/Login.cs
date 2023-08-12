using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Login
{
    public class Login
    {
        public string GetLogin(string login_id,string password)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("GetUserRole", new List<SqlStoreProcedureEntity>()
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

             

                string role_id = dataTable.Rows[0]["role_id"].ToString();
                return role_id; 
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}