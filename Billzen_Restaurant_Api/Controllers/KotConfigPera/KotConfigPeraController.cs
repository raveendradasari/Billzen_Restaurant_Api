using Billzen_Restaurant_Api.DAL.KotConfig;
using Billzen_Restaurant_Api.DAL.KotConfigPera;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class KotConfigPeraController : ApiController
    {

        [HttpGet]
        public IList<KotConfigPeraModel> Get(long kotConfigPeraId)
        {
            return new KotConfigPera().GetKotConfigPera(kotConfigPeraId);
        }


        [HttpPut]
        public DBResponse Put([FromBody] KotConfigPeraModel _model)
        {
            DBResponse response = new DBResponse();
            {
                KotConfigPera request = new KotConfigPera();
                response = request.UpadateIsActive(_model);
            }

            return response;
        }
    }
}
