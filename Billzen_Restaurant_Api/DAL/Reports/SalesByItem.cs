using Billzen_Restaurant_Api.Models.SalesReportByCategoryName;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Reports
{
    public class SalesByItem
    {
        public IList<SalesByItemModel> GetSalesByItem(DateTime fromDate, DateTime toDate)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("rpt_Sales_SalesByItem", new List<SqlStoreProcedureEntity>()
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

                });

                return (IList<SalesByItemModel>)dataTable.AsEnumerable().Select<DataRow, SalesByItemModel>((Func<DataRow, SalesByItemModel>)(row => new SalesByItemModel()
                {
                    item_name = row.Field<string>("item_name"),
                    Quantity = row.Field<decimal>("Quantity").ToString(),
                    Discount = row.Field<decimal>("Discount").ToString(),
                    Complementary = row.Field<decimal>("Complementary").ToString(),
                    SGST = row.Field<decimal>("SGST").ToString(),
                    CGST = row.Field<decimal>("CGST").ToString(),
                    GrossAmount = row.Field<decimal>("GrossAmount").ToString(),
                    NetAmount = row.Field<decimal>("NetAmount").ToString(),

                })).ToList<SalesByItemModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}