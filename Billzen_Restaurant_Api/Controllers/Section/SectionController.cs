using Billzen_Restaurant_Api.DAL.Section;
using Billzen_Restaurant_Api.DAL.Tax;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class SectionController : ApiController
    {
        [HttpGet]
        public IList<SectionModel> Get(long sectionId)
        {
            return new Section().GetSections(sectionId);
        }
        [HttpPost]
        public DBResponse Post([FromBody] SectionModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Section request = new Section();
                response = request.SaveSection(_model);
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
        public DBResponse Put([FromBody] SectionModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Section request = new Section();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}

