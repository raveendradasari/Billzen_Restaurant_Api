using Billzen_Restaurant_Api.Models.SalesReportByCategoryName;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Reports
{
    public class SalesByCategorySubCategory
    {
        public IList<SalesByCategorySubCategoryModel> GetSalesBySubCategory(DateTime fromDate, DateTime toDate, long categoryId, long subcategory_id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("rpt_Sales_SalesByCategorySubCategory", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                  {
                    name = "fromDate",
                    datatype = SqlDbType.Date,
                    value = fromDate.ToString()
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "toDate",
                    datatype = SqlDbType.Date,
                    value = toDate.ToString()
                  },

                     new SqlStoreProcedureEntity()
                  {
                    name = "categoryId",
                    datatype = SqlDbType.BigInt,
                    value = categoryId.ToString()
                  },
                     new SqlStoreProcedureEntity()
                  {
                    name = "subcategory_id",
                    datatype = SqlDbType.BigInt,
                    value = subcategory_id.ToString()
                  },
                });

                return (IList<SalesByCategorySubCategoryModel>)dataTable.AsEnumerable().Select<DataRow, SalesByCategorySubCategoryModel>((Func<DataRow, SalesByCategorySubCategoryModel>)(row => new SalesByCategorySubCategoryModel()
                {
                    CategoryName = row.Field<string>("CategoryName"),
                    SubCategoryName = row.Field<string>("SubCategoryName"),
                    ItemName = row.Field<string>("ItemName"),
                    Quantity = row.Field<decimal>("Quantity").ToString(),
                    Discount = row.Field<decimal>("Discount").ToString(),
                    Complementary = row.Field<decimal>("Complementary").ToString(),
                    SGST = row.Field<decimal>("SGST").ToString(),
                    CGST = row.Field<decimal>("CGST").ToString(),
                    GrossAmount = row.Field<decimal>("GrossAmount").ToString(),
                    NetAmount = row.Field<decimal>("NetAmount").ToString(),

                })).ToList<SalesByCategorySubCategoryModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}