using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class GreetingModel
    {
        public long greeting_id { get; set; }
        //public long transactionId { get; set; }
        public string greeting_message { get; set; }
        public string shift_start_date { get; set; }
        public string shift_start_time { get; set; }
        public string shift_end_date { get; set; }
        public string shift_end_time { get; set; }
        public bool isactive { get; set; }

        public IList<GreetingTransactionModel> TransactionGreeting { get; set; }


    }
}