using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class LoginModel
    {
        public string login_id { get; set; }
        public string password { get; set; }
        public long role_id { get; set; }

    }
}