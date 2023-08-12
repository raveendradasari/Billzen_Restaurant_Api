using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models.Company
{
    public class CompanyModel
    {
        public long companyid { get; set; }
        public string companyname { get; set; }
        public string logo { get; set; }
        public string contactnumber { get; set; }
        public string email { get; set; }
        public string address { get; set; }
        public string gstnumber { get; set; }
        public bool isactive { get; set; }

    }
}
