using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Item
{
    public class GetAllItem
    {
        public IList<GetAllItemModel> GetAllItm()
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getAllItems", new List<SqlStoreProcedureEntity>()
                {
                    //new SqlStoreProcedureEntity()
                    //{
                    //    name = "id",
                    //    datatype = SqlDbType.BigInt,
                    //    value = id.ToString()
                    //},
                });

                return (IList<GetAllItemModel>)dataTable.AsEnumerable().Select<DataRow, GetAllItemModel>((Func<DataRow, GetAllItemModel>)(row => new GetAllItemModel()
                {
                    itemId = row.Field<long>("itemId"),
                    categoryId = row.Field<long>("categoryId"),
                    subcategoryId = row.Field<long>("subcategoryId"),
                    sectionId = row.Field<long>("sectionId"),
                    taxId = row.Field<long>("taxId"),
                    name = row.Field<string>("name"),
                    categoryName = row.Field<string>("categoryName"),
                    subcategoryName = row.Field<string>("subcategoryName"),
                    //itemRate = row.Field<decimal>("itemRate"),
                    unitId = row.Field<long>("unitId"),
                    item_name = row.Field<string>("item_name"),
                    barCode = row.Field<string>("barCode"),
                    hsnCode = row.Field<string>("hsnCode"),
                    salePrice = row.Field<decimal>("salePrice"),
                    taxRate = row.Field<string>("taxRate"),
                    sequence_num = row.Field<int>("sequence_num"),

                    //txnDineInRate = row.Field<decimal>("txnDineInRate"),
                    //txnTakeAwayRate = row.Field<decimal>("txnTakeAwayRate"),
                    //txnHomeDeliveryRate = row.Field<decimal>("txnHomeDeliveryRate"),
                    //txnOnlineRate = row.Field<decimal>("txnOnlineRate"),

                })).ToList<GetAllItemModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}