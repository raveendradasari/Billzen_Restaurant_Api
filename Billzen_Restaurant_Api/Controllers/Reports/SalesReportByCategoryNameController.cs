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
    public class SalesReportByCategoryNameController : ApiController
    {
        [HttpGet]
        public IList<SalesReportByCategoryNameModel> Get(DateTime fromDate, DateTime toDate)
        {
            return new SalesReportByCategoryName().GetSalesReportByCategoryName(fromDate, toDate);
        }

    }
}
