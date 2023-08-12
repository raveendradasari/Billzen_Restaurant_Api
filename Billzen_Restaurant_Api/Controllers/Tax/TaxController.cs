using Billzen_Restaurant_Api.DAL.Tax;
using Billzen_Restaurant_Api.DAL.User;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class TaxController : ApiController
    {
        [HttpGet]
        public IList<taxesModel> Get(long taxId)
        {
            return new Tax().GetTaxes(taxId);
        }

        [HttpPost]
        public DBResponse Post([FromBody] taxesModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Tax request = new Tax();
                response = request.SaveTax(_model);
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
        public DBResponse Put([FromBody] taxesModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Tax request = new Tax();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
