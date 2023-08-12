using Billzen_Restaurant_Api.DAL.Category;
using Billzen_Restaurant_Api.DAL.SubCategory;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class SubCatagoryController : ApiController
    {
        [HttpGet]
        public IList<SubCategoryModel> Get()
        {
            return new SubCategory().GetSubCategorys();
        }

        [HttpPost]
        public DBResponse Post([FromBody] SubCategoryModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                SubCategory request = new SubCategory();
                response = request.SaveSubCategory(_model);
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
        public DBResponse Put([FromBody] SubCategoryModel _model)
        {
            DBResponse response = new DBResponse();
            {
                SubCategory request = new SubCategory();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }
    }
}
