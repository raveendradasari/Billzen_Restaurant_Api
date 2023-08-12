using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.AcessPermissions
{
    public class AcessPermisssionsByAcessId
    {
        public IList<AcessPermissionsModel> GetAcessPermissionByAcessid(long acess_Id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("GetAcesspermissionsByAccessid", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "acess_Id",
                        datatype = SqlDbType.BigInt,
                        value = acess_Id.ToString()
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