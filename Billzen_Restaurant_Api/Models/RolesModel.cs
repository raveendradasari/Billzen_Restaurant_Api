using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class RolesModel
    {
        public long id { get; set; }
        public string role_name { get; set; }
        public string role_description { get; set; }
        public bool isactive { get; set; }

    }
}