using Org.BouncyCastle.Asn1.X509;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class ShiftModel
    {
        public long shiftId { get; set; }
        public string shift_name { get; set; }
        public string shift_start_date { get; set; }
        public string shift_end_date { get; set; }
        public string shift_start_time { get; set; }
        public string shift_end_time { get; set; }
        public bool isactive { get; set; }
    
}
}