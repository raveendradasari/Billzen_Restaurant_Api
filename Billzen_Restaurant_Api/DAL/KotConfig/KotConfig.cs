using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.KotConfig
{
    public class KotConfig
    {

        public IList<KotConfigModel> GetKotConfig()
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getKotConfig", new List<SqlStoreProcedureEntity>()
                {
                   
                });

                return (IList<KotConfigModel>)dataTable.AsEnumerable().Select<DataRow, KotConfigModel>((Func<DataRow, KotConfigModel>)(row => new KotConfigModel()
                {
                    kotConfigId = row.Field<long>("kotConfigId"),
                    KotConfig = row.Field<string>("KotConfig"),
                    isActive = row.Field<bool>("isActive"),
                })).ToList<KotConfigModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DBResponse UpadateIsActive(KotConfigModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateKotConfigStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "kotConfigId",
                    datatype = SqlDbType.BigInt,
                    value =Request.kotConfigId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "isActive",
                    datatype = SqlDbType.Bit,
                    value =Request.isActive.ToString()
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