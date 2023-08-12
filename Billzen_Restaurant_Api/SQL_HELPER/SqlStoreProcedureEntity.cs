using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api
{
    public class SqlStoreProcedureEntity
    {
        public string name { get; set; }

        public SqlDbType datatype { get; set; }

        public string value { get; set; }
    }
}