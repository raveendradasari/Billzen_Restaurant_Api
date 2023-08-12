using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Models
{
    public class SectionRatesModel
    {
        public long sectionRateId { get; set; }
        public long sectionId { get; set; }
        public long itemId { get; set; }
        public decimal itemRate { get; set; }

    }
}