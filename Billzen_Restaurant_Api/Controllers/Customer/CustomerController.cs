using Billzen_Restaurant_Api.DAL.Customer;
using Billzen_Restaurant_Api.DAL.Staff;
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
    public class CustomerController : ApiController
    {
        [HttpGet]
        public IList<CustomerModel> Get(long customerId)
        {
            return new Customer().GetCustomer(customerId);
        }
        [HttpPost]
        public DBResponse Post([FromBody] CustomerModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Customer request = new Customer();
                response = request.SaveCustomer(_model);
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
        public DBResponse Put([FromBody] CustomerModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Customer request = new Customer();
                response = request.UpadateIsActive(_model);
            }
            return response;
        }
    }
}
