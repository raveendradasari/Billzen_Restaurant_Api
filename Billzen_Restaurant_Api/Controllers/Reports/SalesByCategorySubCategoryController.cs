﻿using Billzen_Restaurant_Api.DAL.Reports;
using Billzen_Restaurant_Api.Models.SalesReportByCategoryName;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class SalesByCategorySubCategoryController : ApiController
    {

        [HttpGet]
        public IList<SalesByCategorySubCategoryModel> Get(DateTime fromDate, DateTime toDate, long categoryId, long subcategory_id)
        {
            return new SalesByCategorySubCategory().GetSalesBySubCategory(fromDate, toDate, categoryId, subcategory_id);
        }
    }
}
