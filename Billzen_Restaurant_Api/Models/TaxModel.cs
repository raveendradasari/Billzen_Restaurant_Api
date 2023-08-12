using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class TaxModel
    {
        public long itemTaxId { get; set; }
        public long itemId { get; set; }
        public long taxId { get; set; }
        public bool isActive { get; set; }

        //public string tax_percent { get; set; }

    }
}