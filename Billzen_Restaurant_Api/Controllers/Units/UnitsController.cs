using Billzen_Restaurant_Api.DAL.Units;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class UnitsController : ApiController
    {
        [HttpGet]
        public IList<UnitsModel> Get(long id)
        {
            return new Units().GetUnis(id);
        }
    [HttpPost]
    public DBResponse Post([FromBody] UnitsModel _model)
    {
        DBResponse response = new DBResponse();
        try
        {
                Units request = new Units();
            response = request.SaveUnits(_model);
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
        public DBResponse Put([FromBody] UnitsModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Units request = new Units();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
