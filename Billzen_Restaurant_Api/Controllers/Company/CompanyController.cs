using Billzen_Restaurant_Api.DAL.Company;
using Billzen_Restaurant_Api.DAL.SubCategory;
using Billzen_Restaurant_Api.DAL.Units;
using Billzen_Restaurant_Api.Models;
using Billzen_Restaurant_Api.Models.Company;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class CompanyController : ApiController
    {
        [HttpGet]
        public IList<CompanyModel> Get(long companyid)
        {
            return new Company().GetCompany(companyid);
        }
        [HttpPost]
        public DBResponse Post([FromBody] CompanyModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Company request = new Company();
                response = request.SaveCompany(_model);
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
        public DBResponse Put([FromBody] CompanyModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Company request = new Company();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
