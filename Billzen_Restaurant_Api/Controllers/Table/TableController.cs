using Billzen_Restaurant_Api.DAL.Customer;
using Billzen_Restaurant_Api.DAL.Shift;
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
    public class TableController : ApiController
    {
        [HttpGet]
        public IList<TableModel> Get()
        {
            return new Table().GetTable();
        }
        [HttpPost]
        public DBResponse Post([FromBody] TableModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Table request = new Table();
                response = request.SaveTable(_model);
                return response;
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
                return response;

            }
        }

        [HttpPut]
        public DBResponse Put([FromBody] TableModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Table request = new Table();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
