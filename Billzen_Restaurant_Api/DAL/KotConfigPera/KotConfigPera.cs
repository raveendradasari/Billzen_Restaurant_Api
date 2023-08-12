using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.KotConfigPera
{
    public class KotConfigPera
    {

        public IList<KotConfigPeraModel> GetKotConfigPera(long kotConfigPeraId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getKotConfigPera", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "kotConfigPeraId",
                        datatype = SqlDbType.BigInt,
                        value = kotConfigPeraId.ToString()
                    },
                });

                return (IList<KotConfigPeraModel>)dataTable.AsEnumerable().Select<DataRow, KotConfigPeraModel>((Func<DataRow, KotConfigPeraModel>)(row => new KotConfigPeraModel()
                {
                    kotConfigPeraId = row.Field<long>("kotConfigPeraId"),
                    kotConfigId = row.Field<long>("kotConfigId"),
                    KotConfig = row.Field<string>("KotConfig"),
                    kotConfigPera = row.Field<string>("kotConfigPera"),
                    isActive = row.Field<bool>("isActive"),
                })).ToList<KotConfigPeraModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DBResponse UpadateIsActive(KotConfigPeraModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateKotConfigPeraStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "kotConfigPeraId",
                    datatype = SqlDbType.BigInt,
                    value =Request.kotConfigPeraId.ToString()
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