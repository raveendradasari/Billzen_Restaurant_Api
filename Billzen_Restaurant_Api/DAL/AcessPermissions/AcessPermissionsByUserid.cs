using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.AcessPermissions
{
    public class AcessPermissionsByUserid
    {
        public IList<AcessPermissionsModel> GetAcessPermissionByUserid(long user_id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("GetAcesspermissionsByUserId", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "user_id",
                        datatype = SqlDbType.BigInt,
                        value = user_id.ToString()
                    },
                });

                return (IList<AcessPermissionsModel>)dataTable.AsEnumerable().Select<DataRow, AcessPermissionsModel>((Func<DataRow, AcessPermissionsModel>)(row => new AcessPermissionsModel()
                {
                    acess_Id = row.Field<long>("acess_Id"),
                    user_id = row.Field<long>("user_id"),
                    acess_name = row.Field<string>("acess_name"),
                    isactive = row.Field<bool>("isactive")

                })).ToList<AcessPermissionsModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}