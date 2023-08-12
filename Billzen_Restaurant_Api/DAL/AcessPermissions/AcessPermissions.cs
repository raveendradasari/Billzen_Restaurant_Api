using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.AcessPermissions
{
    public class AcessPermissions
    {

        public DBResponse SaveAcessPermissions(AcessPermissionsModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveAcessPermissions", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "acess_Id",
                    datatype = SqlDbType.BigInt,
                    value = Request.acess_Id.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "user_id",
                    datatype = SqlDbType.BigInt,
                    value = Request.user_id.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "acess_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.acess_name
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



        public DBResponse UpadateAcessPermissions(AcessPermissionsModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateAcessPermissions", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "acess_Id",
                    datatype = SqlDbType.BigInt,
                    value =Request.acess_Id.ToString()
                  },
                 
                   new SqlStoreProcedureEntity()
                  {
                    name = "user_id",
                    datatype = SqlDbType.BigInt,
                    value =Request.user_id.ToString()
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "acess_name",
                    datatype = SqlDbType.NVarChar,
                    value =Request.acess_name                  },
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

        public IList<AcessPermissionsModel> GetAcessPermissionByRoleid(long user_id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("GetAcesspermissions", new List<SqlStoreProcedureEntity>()
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

        //public IList<AcessPermissionsModel> GetAcessPermissionByAcessid(long acess_Id)
        //{
        //    try
        //    {
        //        DataTable dataTable = new SqlQuery().Execute("usp_getRoles", new List<SqlStoreProcedureEntity>()
        //        {
        //            new SqlStoreProcedureEntity()
        //            {
        //                name = "acess_Id",
        //                datatype = SqlDbType.BigInt,
        //                value = acess_Id.ToString()
        //            },
        //        });

        //        return (IList<AcessPermissionsModel>)dataTable.AsEnumerable().Select<DataRow, AcessPermissionsModel>((Func<DataRow, AcessPermissionsModel>)(row => new AcessPermissionsModel()
        //        {
        //            acess_Id = row.Field<long>("acess_Id"),
        //            role_id = row.Field<long>("role_id"),
        //            dash_board = row.Field<bool>("dash_board"),
        //            item_master = row.Field<bool>("item_master"),
        //            nc_master = row.Field<bool>("nc_master"),
        //            pay_method = row.Field<bool>("pay_method"),
        //            customer = row.Field<bool>("customer"),
        //            staff = row.Field<bool>("staff"),
        //            tax = row.Field<bool>("tax"),
        //            company = row.Field<bool>("company"),
        //            section = row.Field<bool>("section"),
        //            category = row.Field<bool>("category"),
        //            sub_category = row.Field<bool>("sub_category"),
        //            units = row.Field<bool>("units"),
        //            user_role = row.Field<bool>("user_role"),
        //            tables = row.Field<bool>("tables"),
        //            bulk_table = row.Field<bool>("bulk_table"),
        //            settings = row.Field<bool>("settings")

        //        })).ToList<AcessPermissionsModel>();

        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

    }
}