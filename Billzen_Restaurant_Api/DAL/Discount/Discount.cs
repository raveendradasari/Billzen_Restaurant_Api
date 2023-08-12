using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Discount
{
    public class Discount
    {
        public IList<DiscountModel> GetDiscount(long discountId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getDiscount", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "discountId",
                        datatype = SqlDbType.BigInt,
                        value = discountId.ToString()
                    },
                });

                return (IList<DiscountModel>)dataTable.AsEnumerable().Select<DataRow, DiscountModel>((Func<DataRow, DiscountModel>)(row => new DiscountModel()
                {
                    discountId = row.Field<long>("discountId"),
                    discountPercentage = row.Field<string>("discountPercentage"),
                    discountCategory = row.Field<string>("discountCategory"),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<DiscountModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveDiscount(DiscountModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveDiscount", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "discountId",
                    datatype = SqlDbType.BigInt,
                    value = Request.discountId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "discountPercentage",
                    datatype = SqlDbType.NVarChar,
                    value = Request.discountPercentage
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "discountCategory",
                    datatype = SqlDbType.NVarChar,
                    value = Request.discountCategory
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

        public DBResponse UpadateIsActive(DiscountModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateDiscountStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "discountId",
                    datatype = SqlDbType.BigInt,
                    value =Request.discountId.ToString()
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