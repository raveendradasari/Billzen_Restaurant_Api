using Billzen_Restaurant_Api.DAL.UserLogin;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class UserLoginController : ApiController
    {
        [HttpPost]
        public DBResponse Post([FromBody] UserModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                UserLogin request = new UserLogin();
                int UserId = Convert.ToInt32(request.GetUserLogin(_model.login_id, _model.password));
                if (UserId > 0)
                {
                    response.id = UserId;
                    response.message = "Success";
                    response.status = true;
                }
                else
                {
                    response.id = 0;
                    response.message = "Incorrect User Id or password ";
                    response.status = false;
                }
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();

            }
            return response;
        }
    }
}
