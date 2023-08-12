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
    public class SubCatagoryByIdController : ApiController
    {
        [HttpGet]
        public IList<SubCategoryModel> Get(long subcategoryId)
        {
            return new SubCategory().GetSubCategoryById(subcategoryId);
        }
}
}
