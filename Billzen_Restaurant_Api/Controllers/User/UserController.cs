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
    public class UserController : ApiController
    {
        [HttpPost]
        public DBResponse Post([FromBody] UserModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                User request = new User();
                response = request.SaveUser(_model);
                return response;
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
                return response;
            }
        }

        [HttpGet]
        public IList<UserModel> Get(long id)
        {
            return new User().GetUsers(id);
        }

        [HttpPut]
        public DBResponse Put([FromBody] UserModel _model)
        {
            DBResponse response = new DBResponse();
            {
                User request = new User();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
