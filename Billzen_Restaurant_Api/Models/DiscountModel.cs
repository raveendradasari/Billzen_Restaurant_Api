using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class DiscountModel
    {
        public long discountId { get; set; }
        public string discountPercentage { get; set; }
        public string discountCategory { get; set; }
        public bool isactive { get; set; }
    }
}