using Billzen_Restaurant_Api.DAL.Item;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class GetAllItemController : ApiController
    {
        [HttpGet]
        public IList<GetAllItemModel> Get()
        {
            return new GetAllItem().GetAllItm();
        }

    }
}
