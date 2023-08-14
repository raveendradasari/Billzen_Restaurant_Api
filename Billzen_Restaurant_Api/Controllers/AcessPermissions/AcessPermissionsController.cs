using Billzen_Restaurant_Api.DAL.AcessPermissions;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class AcessPermissionsController : ApiController
    {

        [HttpPost]
        public DBResponse Post([FromBody] List<AcessPermissionsModel> _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                AcessPermissions request = new AcessPermissions();

                foreach (var x in _model)
                {
                    response = request.SaveAcessPermissions(x);

                }
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
        public DBResponse Put([FromBody] AcessPermissionsModel _model)
        {
            DBResponse response = new DBResponse();
            {
                AcessPermissions request = new AcessPermissions();
                response = request.UpadateAcessPermissions(_model);
            }

            return response;
        }


        [HttpGet]
        public IList<AcessPermissionsModel> Get(long user_id)
        {
            return new AcessPermissions().GetAcessPermissionByRoleid(user_id);
        }

    }
}
