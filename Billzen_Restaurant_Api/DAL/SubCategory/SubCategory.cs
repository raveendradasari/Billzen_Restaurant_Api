using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.SubCategory
{
    public class SubCategory
    {
        public IList<SubCategoryModel> GetSubCategorys()
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getAllSubCategorys", new List<SqlStoreProcedureEntity>()
                {
                    //new SqlStoreProcedureEntity()
                    //{
                    //    name = "id",
                    //    datatype = SqlDbType.BigInt,
                    //    value = id.ToString()
                    //},
                });

                return (IList<SubCategoryModel>)dataTable.AsEnumerable().Select<DataRow, SubCategoryModel>((Func<DataRow, SubCategoryModel>)(row => new SubCategoryModel()
                {
                    subcategoryId = row.Field<long>("subcategoryId"),
                    categoryId = row.Field<long>("categoryId"),
                    categoryName = row.Field<string>("categoryName"),
                    subcategoryName = row.Field<string>("subcategoryName"),
                    isActive = row.Field<bool>("isActive"),
                })).ToList<SubCategoryModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public IList<SubCategoryModel> GetSubCategoryById(long subcategoryId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getSubCategorys", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "subcategoryId",
                        datatype = SqlDbType.BigInt,
                        value = subcategoryId.ToString()
                    },
                });

                return (IList<SubCategoryModel>)dataTable.AsEnumerable().Select<DataRow, SubCategoryModel>((Func<DataRow, SubCategoryModel>)(row => new SubCategoryModel()
                {
                    subcategoryId = row.Field<long>("subcategoryId"),
                    categoryId = row.Field<long>("categoryId"),
                    categoryName = row.Field<string>("categoryName"),
                    subcategoryName = row.Field<string>("subcategoryName"),
                    isActive = row.Field<bool>("isActive"),
                })).ToList<SubCategoryModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveSubCategory(SubCategoryModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveSubCategorys", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "subcategoryId",
                    datatype = SqlDbType.BigInt,
                    value = Request.subcategoryId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "categoryId",
                    datatype = SqlDbType.BigInt,
                    value = Request.categoryId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "subcategoryName",
                    datatype = SqlDbType.NVarChar,
                    value = Request.subcategoryName
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "isActive",
                    datatype = SqlDbType.Bit,
                    value = Request.isActive.ToString()
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

        public DBResponse UpadateIsActive(SubCategoryModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateSubCategoryStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "subcategoryId",
                    datatype = SqlDbType.BigInt,
                    value =Request.subcategoryId.ToString()
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