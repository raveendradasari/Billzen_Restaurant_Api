using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class TransactionItemModel
    {
        public long transactionItemId { get; set; }
        public long transactionId { get; set; }
        public long itemId { get; set; }
        public decimal transactionItemCost { get; set; }
    }
}