using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class KotConfigPeraModel
    {

        public long kotConfigPeraId { get; set; }
        public long kotConfigId { get; set; }
        public string KotConfig { get; set; }
        public string kotConfigPera { get; set; }
        public bool isActive { get; set; }
    }
}