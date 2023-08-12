using Billzen_Restaurant_Api.DAL.Category;
using Billzen_Restaurant_Api.DAL.Roles;
using Billzen_Restaurant_Api.DAL.SubCategory;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class RolesController : ApiController
    {
        [HttpGet]
        public IList<RolesModel> Get(long id)
        {
            return new Roles().GetRoles(id);
        }
        [HttpPost]
        public DBResponse Post([FromBody] RolesModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Roles request = new Roles();
                response = request.SaveRoles(_model);
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
        public DBResponse Put([FromBody] RolesModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Roles request = new Roles();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
