using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class KotConfigModel
    {

        public long kotConfigId { get; set; }
        public string KotConfig { get; set; }
        public bool isActive { get; set; }

    }
}