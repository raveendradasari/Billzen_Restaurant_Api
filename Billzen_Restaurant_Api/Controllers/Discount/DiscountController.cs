using Billzen_Restaurant_Api.DAL.Discount;
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
    public class DiscountController : ApiController
    {
        [HttpGet]
        public IList<DiscountModel> Get(long discountId)
        {
            return new Discount().GetDiscount(discountId);
        }
        [HttpPost]
        public DBResponse Post([FromBody] DiscountModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Discount request = new Discount();
                response = request.SaveDiscount(_model);
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
        public DBResponse Put([FromBody] DiscountModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Discount request = new Discount();
                response = request.UpadateIsActive(_model);
            }

            return response;
        }
    }
}
