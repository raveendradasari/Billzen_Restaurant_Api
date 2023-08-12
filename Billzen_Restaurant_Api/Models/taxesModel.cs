using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class taxesModel
    {
        public long taxId { get; set; }
        public long transactionId { get; set; }
        public string taxName { get; set; }
        public string transactionName { get; set; }
        public string tax_percent { get; set; }
        public bool isactive { get; set; }
    }
}