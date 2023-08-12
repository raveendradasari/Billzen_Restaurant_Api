using Billzen_Restaurant_Api.DAL.Shift;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class ShiftController : ApiController
    {
        [HttpGet]
        public IList<ShiftModel> Get(long shiftId)
        {
            return new Shift().GetShift(shiftId);
        }
        [HttpPost]
        public DBResponse Post([FromBody] ShiftModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Shift request = new Shift();
                response = request.SaveShift(_model);
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
        public DBResponse Put([FromBody] ShiftModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Shift request = new Shift();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }

    }
}
