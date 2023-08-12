using Billzen_Restaurant_Api.DAL.Login;
using Billzen_Restaurant_Api.DAL.User;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class LoginController : ApiController
    { 
        [HttpPost]
        public DBResponse Post([FromBody] UserModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Login request = new Login();
                int RoleId = Convert.ToInt32(request.GetLogin(_model.login_id, _model.password));
                    if(RoleId>0)
                {
                    response.id= RoleId;
                    response.message = "Success";
                    response.status = true;
                }    else
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

