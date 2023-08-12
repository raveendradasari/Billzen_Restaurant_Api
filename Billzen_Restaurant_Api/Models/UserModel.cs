using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class UserModel
    {
        public long id { get; set; }
        public long role_id { get; set; }
        public string login_id { get; set; } 
        public string password { get; set; } 
        public string full_name { get; set; } 
        public bool is_active { get; set; } 
    }
}