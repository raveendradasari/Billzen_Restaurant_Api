﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models.SalesReportByCategoryName
{
    public class SalesByCategoryModel
    {
        public string item_name { get; set; }
        public string Quantity { get; set; }
        public string Discount { get; set; }
        public string Complementary { get; set; }
        public string SGST { get; set; }
        public string CGST { get; set; }
        public string GrossAmount { get; set; }
        public string NetAmount { get; set; }



    }
}