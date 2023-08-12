using Billzen_Restaurant_Api.DAL.Customer;
using Billzen_Restaurant_Api.DAL.Discount;
using Billzen_Restaurant_Api.DAL.KotPrinterConfig;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class KotPrinterConfigController : ApiController
    {
        [HttpGet]
        public IList<KotPrinterConfigModel> Get(long kotPrintId)
        {
            return new KotPrinterConfig().GetKotPrinterConfig(kotPrintId);
        }


        [HttpPost]
        public DBResponse Post([FromBody] KotPrinterConfigModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                KotPrinterConfig request = new KotPrinterConfig();
                response = request.SaveKotPrinterCongig(_model);
                return response;
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message=ex.Message.ToString();
                return response;
            }
        }

        [HttpDelete]
        public DBResponse Delete(long transactionId,long subcategoryId,long itemId,long printer_id)
        {
            DBResponse response = new DBResponse();
            try
            {
                KotPrinterConfig request = new KotPrinterConfig();
                response = request.DeleteKotPrinterConfig(transactionId,subcategoryId,itemId,printer_id);
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
