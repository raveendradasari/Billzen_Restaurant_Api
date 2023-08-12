using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class TransactionModel
    {

        public long transactionId { get; set; }
        public string transactionName { get; set; }
        public bool isActive { get; set; }
    }
}