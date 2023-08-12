﻿using Billzen_Restaurant_Api.DAL.Discount;
using Billzen_Restaurant_Api.DAL.KotConfig;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class KotConfigController : ApiController
    {
        [HttpGet]
        public IList<KotConfigModel> Get()
        {
            return new KotConfig().GetKotConfig();
        }

        [HttpPut]
        public DBResponse Put([FromBody] KotConfigModel _model)
        {
            DBResponse response = new DBResponse();
            {
                KotConfig request = new KotConfig();
                response = request.UpadateIsActive(_model);
            }

            return response;
        }

    }
}
