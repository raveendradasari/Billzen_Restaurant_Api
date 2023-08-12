using Billzen_Restaurant_Api.DAL.AcessPermissions;
using Billzen_Restaurant_Api.DAL.Category;
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
    public class CategoryController : ApiController
    {
        [HttpGet]
        public IList<CategoryModel> Get()
        {
            return new Category().GetCategory();
        }

        [HttpPost]
        public DBResponse Post([FromBody] CategoryModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Category request = new Category();
                response = request.SaveCategory(_model);
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
        public DBResponse Put([FromBody] CategoryModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Category request = new Category();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
