using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class AcessPermissionsModel
    {
        public long acess_Id { get; set; }
        public long user_id { get; set; }
        public string acess_name { get; set; }
        public bool isactive { get; set; }


    }
}