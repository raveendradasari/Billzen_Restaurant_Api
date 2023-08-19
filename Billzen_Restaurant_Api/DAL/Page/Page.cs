using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Page
{
    public class Page
    {
        public IList<PageModel> GetPage(long page_id)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getPage", new List<SqlStoreProcedureEntity>()
                {
                    new SqlStoreProcedureEntity()
                    {
                        name = "page_id",
                        datatype = SqlDbType.BigInt,
                        value = page_id.ToString()
                    },
                });

                return (IList<PageModel>)dataTable.AsEnumerable().Select<DataRow, PageModel>((Func<DataRow, PageModel>)(row => new PageModel()
                {
                    page_id = row.Field<long>("page_id"),
                    page_name = row.Field<string>("page_name"),
                    Status = row.Field<bool>("Status"),
                })).ToList<PageModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}