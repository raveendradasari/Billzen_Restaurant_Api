using Billzen_Restaurant_Api.Models;
using Billzen_Restaurant_Api.Models.SalesReportByCategoryName;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Reports
{
    public class SalesReportByCategoryName
    {
        public IList<SalesReportByCategoryNameModel> GetSalesReportByCategoryName(DateTime fromDate, DateTime toDate)
        {
            try
            {
                DataSet ds = new SqlQueryDataSet().Execute("rpt_Sales_SalesByCategroryName", new List<SqlStoreProcedureEntity>()
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
                return (IList<SalesReportByCategoryNameModel>)ds.Tables[0].AsEnumerable().Select<DataRow, SalesReportByCategoryNameModel>((Func<DataRow, SalesReportByCategoryNameModel>)(row => new SalesReportByCategoryNameModel()
                {
                    CategoryName = row.Field<string>("CategoryName"),
                    Quantity = row.Field<decimal>("Quantity").ToString(),
                    GrossAmount = row.Field<decimal>("GrossAmount").ToString(),
                    Discount = row.Field<decimal>("Discount").ToString(),
                    Complementary = row.Field<decimal>("Complementary").ToString(),
                    SGST = row.Field<decimal>("SGST").ToString(),
                    CGST = row.Field<decimal>("CGST").ToString(),
                    NetAmount = row.Field<decimal>("NetAmount").ToString(),

                    SalesSummary = ds.Tables[1].AsEnumerable().Select<DataRow, SalesSummaryModel>((Func<DataRow, SalesSummaryModel>)(ssum => new SalesSummaryModel()
                    {
                        Quantity = ssum.Field<decimal>("Quantity").ToString(),
                        GrossAmount = ssum.Field<decimal>("GrossAmount").ToString(),
                        Discount = ssum.Field<decimal>("Discount").ToString(),
                        Complementary = ssum.Field<decimal>("Complementary").ToString(),
                        SGST = ssum.Field<decimal>("SGST").ToString(),
                        CGST = ssum.Field<decimal>("CGST").ToString(),
                        NetAmount = ssum.Field<decimal>("NetAmount").ToString(),
                    })).ToList(),
                })).ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}