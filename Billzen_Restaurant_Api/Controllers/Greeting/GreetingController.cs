using Billzen_Restaurant_Api.DAL.Greeting;
using Billzen_Restaurant_Api.DAL.Tax;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class GreetingController : ApiController
    {
        [HttpGet]
        public IList<GreetingModel> Get(long greeting_id)
        {
            return new Greeting().GetGreeting(greeting_id);
        }

        [HttpPost]
        public DBResponse Post([FromBody] GreetingModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Greeting request = new Greeting();
                response = request.SaveGreeting(_model);
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
        public DBResponse Put([FromBody] GreetingModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Greeting request = new Greeting();
                response = request.UpadateIsActive(_model);
            }

            return response;
        }
    }
}
