using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class PageModel
    {

        public long page_id { get; set; }
        public string page_name { get; set; }
        public bool Status { get; set; }

    }
}