using Billzen_Restaurant_Api.DAL.Printer;
using Billzen_Restaurant_Api.DAL.Units;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class PrinterController : ApiController
    {
        [HttpGet]
        public IList<PrinterModel> Get()
        {
            return new Printer().GetPrinter();
        }
        [HttpPost]
        public DBResponse Post([FromBody] PrinterModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Printer request = new Printer();
                response = request.SavePrinter(_model);
                return response;
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
                return response;
            }
        }
        [HttpDelete]
        public DBResponse Delete([FromBody] PrinterModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Printer request = new Printer();
                response = request.DeletePrinter(_model);
                return response;
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
                return response;
            }
        }

    }
}
