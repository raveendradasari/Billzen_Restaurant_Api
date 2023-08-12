using Billzen_Restaurant_Api.DAL.Transaction;
using Billzen_Restaurant_Api.DAL.User;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class TransactionController : ApiController
    {
        [HttpGet]
        public IList<TransactionModel> Get(long transactionId)
        {
            return new Transaction().GetTransaction(transactionId);
        }


        [HttpPost]
        public DBResponse Post([FromBody] TransactionModel _model)
        {
            DBResponse response = new DBResponse();
            try
            {
                Transaction request = new Transaction();
                response = request.SaveTransaction(_model);
                return response;
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
                return response;
            }
        }

        [HttpPut]
        public DBResponse Put([FromBody] TransactionModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Transaction request = new Transaction();
                response = request.UpadateIsActive(_model);
            }

            return response;


        }

    }
}
