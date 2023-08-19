using Billzen_Restaurant_Api.DAL.Discount;
using Billzen_Restaurant_Api.DAL.Page;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class PageController : ApiController
    {
        [HttpGet]
        public IList<PageModel> Get(long page_id)
        {
            return new Page().GetPage(page_id);
        }
    }
}
