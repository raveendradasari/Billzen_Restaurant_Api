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
    public class SalesByItemController : ApiController
    {
        [HttpGet]
        public IList<SalesByItemModel> Get(DateTime fromDate, DateTime toDate)
        {
            return new SalesByItem().GetSalesByItem(fromDate, toDate);
        }
    }
}
