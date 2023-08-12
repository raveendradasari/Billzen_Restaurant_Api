using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class StaffModel
    {
        public long staffId { get; set; }
        public string staff_name { get; set; }
        public string Mobilenumber { get; set; }
        public string address { get; set; }
        public string joiningdate { get; set; }
        public string refferedby { get; set; }
        public string designation { get; set; }
        public string department { get; set; }
        public string document_type { get; set; }
        public string documentdetails { get; set; }
        public bool isactive { get; set; }

    }
}
