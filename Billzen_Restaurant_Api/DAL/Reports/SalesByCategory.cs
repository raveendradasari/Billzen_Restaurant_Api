using Billzen_Restaurant_Api.Models;
using Billzen_Restaurant_Api.Models.SalesReportByCategoryName;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Reports
{
    public class SalesByCategory
    {
        public IList<SalesByCategoryModel> GetSalesByCategory(DateTime fromDate, DateTime toDate,long category_id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("rpt_Sales_SalesByCategory", new List<SqlStoreProcedureEntity>()
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
                    name = "category_id",
                    datatype = SqlDbType.BigInt,
                    value = category_id.ToString()
                  },
                });

                return (IList<SalesByCategoryModel>)dataTable.AsEnumerable().Select<DataRow, SalesByCategoryModel>((Func<DataRow, SalesByCategoryModel>)(row => new SalesByCategoryModel()
                {
                    item_name = row.Field<string>("item_name"),
                    Quantity = row.Field<decimal>("Quantity").ToString(),
                    Discount = row.Field<decimal>("Discount").ToString(),
                    Complementary = row.Field<decimal>("Complementary").ToString(),
                    SGST = row.Field<decimal>("SGST").ToString(),
                    CGST = row.Field<decimal>("CGST").ToString(),
                    GrossAmount = row.Field<decimal>("GrossAmount").ToString(),
                    NetAmount = row.Field<decimal>("NetAmount").ToString(),

                })).ToList<SalesByCategoryModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}