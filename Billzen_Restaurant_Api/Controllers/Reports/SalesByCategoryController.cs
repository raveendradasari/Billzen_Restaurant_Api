using Billzen_Restaurant_Api.DAL.Reports;
using Billzen_Restaurant_Api.Models.SalesReportByCategoryName;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class SalesByCategoryController : ApiController
    {

        [HttpGet]
        public IList<SalesByCategoryModel> Get(DateTime fromDate, DateTime toDate,long category_id)
        {
            return new SalesByCategory().GetSalesByCategory(fromDate, toDate, category_id);
        }
    }
}
