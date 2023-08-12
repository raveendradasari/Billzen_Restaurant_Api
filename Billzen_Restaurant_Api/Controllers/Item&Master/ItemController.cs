using Billzen_Restaurant_Api.DAL.Item;
using Billzen_Restaurant_Api.DAL.Shift;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Billzen_Restaurant_Api.Controllers
{
    public class ItemController : ApiController
    {

        [HttpGet]
        public IList<ItemModel> Get(long itemId = 0)
        {
            return new Item().GetAllItems(itemId);
        }



        [HttpPost]
        public DBResponse Post([FromBody] ItemModel _model)
        {

            DBResponse response = new DBResponse();
            try
            {
                Item request = new Item();
                response = request.SaveItem(_model);


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
        public DBResponse Put([FromBody] ItemModel _model)
        {
            DBResponse response = new DBResponse();
            {
                Item request = new Item();
                response = request.UpadateIsActive(_model);
            }

            return response;
        }
    }
}
