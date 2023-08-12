using Billzen_Restaurant_Api.DAL.Shift;
using Billzen_Restaurant_Api.DAL.Staff;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class StaffController : ApiController
    {
        [HttpGet]
        public IList<StaffModel> Get(long staffId)
        {
            return new Staff().GetStaff(staffId);
        }
        [HttpPost]
        public DBResponse Post([FromBody] StaffModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Staff request = new Staff();
                response = request.SaveStaff(_model);
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
        public DBResponse Put([FromBody] StaffModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Staff request = new Staff();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }

    }
}
