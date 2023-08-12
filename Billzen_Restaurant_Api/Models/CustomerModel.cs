using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class CustomerModel
    {
        public long customerId { get; set; }
        public string customer_name { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string pincode { get; set; }
        public string country { get; set; }
        public string Mobilenumber { get; set; }
        public string billing_address { get; set; }
        public string account_type { get; set; }
        public decimal opening_balance { get; set; }
        public string credit_allowed { get; set; }
        public decimal credit_limit { get; set; }
        public string pan_no { get; set; }
        public string Gstin { get; set; }
        public bool isactive { get; set; }

    }
}