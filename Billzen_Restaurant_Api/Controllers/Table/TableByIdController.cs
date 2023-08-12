using Billzen_Restaurant_Api.DAL.Table;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class TableByIdController : ApiController
    {
        [HttpGet]
        public IList<TableModel> Get(long tableId)
        {
            return new Table().GetTableById(tableId);
        }
    }
}
