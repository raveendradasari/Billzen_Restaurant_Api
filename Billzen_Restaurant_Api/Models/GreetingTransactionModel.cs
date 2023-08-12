using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class GreetingTransactionModel
    {
        public long transactionGreetingId { get; set; }
        public long greeting_id { get; set; }
        public long transactionId { get; set; }
        public string transactionName { get; set; }
        public bool isactive { get; set; }
    }
}