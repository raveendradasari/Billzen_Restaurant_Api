using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class KotPrinterConfigModel
    {
        public long kotPrintId { get; set; }
        public long transactionId { get; set; }
        public long subcategoryId { get; set; }
        public long itemId { get; set; }
        public long printer_id { get; set; }


    }
}