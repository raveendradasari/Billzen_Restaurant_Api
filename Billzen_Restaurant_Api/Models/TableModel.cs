using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class TableModel
    {
        public long tableId { get; set; }
        public string name { get; set; }
        public long sectionId { get; set; }
        public string Section_name { get; set; }
        public bool isactive { get; set; }

    }
}