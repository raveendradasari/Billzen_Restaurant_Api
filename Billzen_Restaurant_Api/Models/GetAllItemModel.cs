using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class GetAllItemModel
    {
        public long itemId { get; set; }
        public long categoryId { get; set; }
        public long subcategoryId { get; set; }
        public long sectionId { get; set; }
        public long taxId { get; set; }
        public long unitId { get; set; }
        public string name { get; set; }
        public string categoryName { get; set; }
        public string subcategoryName { get; set; }
        public string item_name { get; set; }
        public string barCode { get; set; }
        public string hsnCode { get; set; }
        public decimal salePrice { get; set; }
        public string taxRate { get; set; }
        //public decimal txnDineInRate { get; set; }
        //public decimal txnTakeAwayRate { get; set; }
        //public decimal txnHomeDeliveryRate { get; set; }
        //public decimal txnOnlineRate { get; set; }
        //public decimal itemRate { get; set; }




    }
}