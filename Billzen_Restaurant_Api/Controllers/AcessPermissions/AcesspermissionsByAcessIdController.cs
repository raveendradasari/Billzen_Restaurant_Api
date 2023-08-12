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
    public class AcesspermissionsByAcessIdController : ApiController
    {
        [HttpGet]
        public IList<AcessPermissionsModel> Get(long acess_Id)
        {
            return new AcessPermisssionsByAcessId().GetAcessPermissionByAcessid(acess_Id);
        }
    }
}
