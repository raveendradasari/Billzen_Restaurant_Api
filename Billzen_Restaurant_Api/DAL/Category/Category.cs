using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Category
{
    public class Category
    {
        public IList<CategoryModel> GetCategory()
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_ItemCategory", new List<SqlStoreProcedureEntity>()
                {
                    //new SqlStoreProcedureEntity()
                    //{
                    //    name = "id",
                    //    datatype = SqlDbType.BigInt,
                    //    value = id.ToString()
                    //},
                });

                return (IList<CategoryModel>)dataTable.AsEnumerable().Select<DataRow, CategoryModel>((Func<DataRow, CategoryModel>)(row => new CategoryModel()
                {
                    categoryId = row.Field<long>("categoryId"),
                    categoryName = row.Field<string>("categoryName"),
                    isActive = row.Field<bool>("isActive"),

                })).ToList<CategoryModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse SaveCategory(CategoryModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_saveCategorys", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "categoryId",
                    datatype = SqlDbType.BigInt,
                    value = Request.categoryId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "categoryName",
                    datatype = SqlDbType.NVarChar,
                    value = Request.categoryName
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

        public IList<CategoryModel> CategoryById(long categoryId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getCategoriesById", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "categoryId",
                        datatype = SqlDbType.BigInt,
                        value = categoryId.ToString()
                    },
                });

                return (IList<CategoryModel>)dataTable.AsEnumerable().Select<DataRow, CategoryModel>((Func<DataRow, CategoryModel>)(row => new CategoryModel()
                {
                    categoryId = row.Field<long>("categoryId"),
                    categoryName = row.Field<string>("categoryName"),
                    isActive = row.Field<bool>("isActive"),

                })).ToList<CategoryModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DBResponse UpadateIsActive(CategoryModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateCategoryStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "categoryId",
                    datatype = SqlDbType.BigInt,
                    value =Request.categoryId.ToString()
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