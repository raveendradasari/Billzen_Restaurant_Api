using Billzen_Restaurant_Api.DAL.Category;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class CategoryModel
    {
        public long categoryId { get; set; }
        public string categoryName { get; set; }
        public bool isActive { get; set; }

    }
}