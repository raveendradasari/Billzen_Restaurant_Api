using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Item
{
    public class Item
    {

        public IList<ItemModel> GetAllItems(long itemId)
        {
            try
            {
                DataSet ds = new SqlQueryDataSet().Execute("usp_getItem", new List<SqlStoreProcedureEntity>()
                {
                     new SqlStoreProcedureEntity()
                  {
                    name = "itemId",
                    datatype = SqlDbType.BigInt,
                    value = itemId.ToString()
                  },

                });
                return (IList<ItemModel>)ds.Tables[0].AsEnumerable().Select<DataRow, ItemModel>((Func<DataRow, ItemModel>)(row => new ItemModel()
                {
                    itemId = row.Field<long>("itemId"),
                    categoryId = row.Field<long>("categoryId"),
                    subcategoryId = row.Field<long>("subcategoryId"),
                    unitId = row.Field<long>("unitId"),
                    item_name = row.Field<string>("item_name"),
                    categoryName = row.Field<string>("categoryName"),
                    subcategoryName = row.Field<string>("subcategoryName"),
                    UnitName = row.Field<string>("UnitName"),
                    barCode = row.Field<string>("barCode"),
                    hsnCode = row.Field<string>("hsnCode"),
                    salePrice = row.Field<decimal>("salePrice"),
                    taxRate = row.Field<string>("taxRate"),
                    discount_percentage = row.Field<string>("discount_percentage"),
                    sequence_num = row.Field<int>("sequence_num"),
                    isActive = row.Field<bool>("isActive"),



                    SectionItemRates = (from stm in ds.Tables[1].AsEnumerable()
                                        where stm.Field<long>("itemId") == row.Field<long>("itemId")
                                        select new SectionRatesModel
                                        {


                                            sectionRateId = stm.Field<long>("sectionRateId"),
                                            sectionId = stm.Field<long>("sectionId"),
                                            itemId = stm.Field<long>("itemId"),
                                            itemRate = stm.Field<decimal>("itemRate"),
                                        }).ToList(),

                    TaxItems = (from ttm in ds.Tables[2].AsEnumerable()
                                where ttm.Field<long>("itemId") == row.Field<long>("itemId")
                                select new TaxModel
                                {
                                    itemTaxId = ttm.Field<long>("itemTaxId"),
                                    itemId = ttm.Field<long>("itemId"),
                                    taxId = ttm.Field<long>("taxId"),
                                    isActive = ttm.Field<bool>("isActive"),
                                }).ToList(),

                    TransactionItems = (from trn in ds.Tables[3].AsEnumerable()
                                        where trn.Field<long>("itemId") == row.Field<long>("itemId")
                                        select new TransactionItemModel
                                        {
                                            transactionItemId = trn.Field<long>("transactionItemId"),
                                            transactionId = trn.Field<long>("transactionId"),
                                            itemId = trn.Field<long>("itemId"),
                                            transactionItemCost = trn.Field<decimal>("transactionItemCost"),
                                        }).ToList(),

                })).ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public DBResponse SaveItem(ItemModel Request)
        {
            DBResponse response = new DBResponse();
            //SqlTransaction objTrans = null;
            try
            {
                // objTrans = Connection.sqlConnection.BeginTransaction();
                DataTable dataTable = new SqlQuery().Execute("usp_saveItem", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "itemId",
                    datatype = SqlDbType.BigInt,
                    value = Request.itemId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "categoryId",
                    datatype = SqlDbType.BigInt,
                    value = Request.categoryId.ToString()
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "subcategoryId",
                    datatype = SqlDbType.BigInt,
                    value = Request.subcategoryId.ToString()
                  },
                     new SqlStoreProcedureEntity()
                  {
                    name = "unitId",
                    datatype = SqlDbType.BigInt,
                    value = Request.unitId.ToString()
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "item_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.item_name
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "barCode",
                    datatype = SqlDbType.NVarChar,
                    value = Request.barCode
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "hsnCode",
                    datatype = SqlDbType.NVarChar,
                    value = Request.hsnCode
                  },
                     new SqlStoreProcedureEntity()
                  {
                    name = "salePrice",
                    datatype = SqlDbType.Decimal,
                    value = Request.salePrice.ToString()
                  },
                      new SqlStoreProcedureEntity()
                  {
                    name = "taxRate",
                    datatype = SqlDbType.NVarChar,
                    value = Request.taxRate
                  },
                       new SqlStoreProcedureEntity()
                  {
                    name = "discount_percentage",
                    datatype = SqlDbType.NVarChar,
                    value = Request.discount_percentage
                  },
                      new SqlStoreProcedureEntity()
                  {
                    name = "sequence_num",
                    datatype = SqlDbType.Int,
                    value = Request.sequence_num.ToString()
                  },
                      new SqlStoreProcedureEntity()
                  {
                    name = "isActive",
                    datatype = SqlDbType.Bit,
                    value = Request.isActive.ToString()
                  },


                });
                long itemId = Convert.ToInt32(dataTable.Rows[0][0]);
                long sectionRateId = Convert.ToInt32(dataTable.Rows[0][0]);

                if (itemId != 0 && sectionRateId != 0)
                {
                    if (Request.SectionItemRates != null)
                    {
                        try
                        {
                            DataTable dataTable1 = new DataTable();

                            foreach (var salp in Request.SectionItemRates)
                            {

                                dataTable1 = new SqlQuery().Execute("usp_saveSectionRates", new List<SqlStoreProcedureEntity>()
                        {
                           new SqlStoreProcedureEntity()
                           {
                               name = "sectionRateId",
                               datatype = SqlDbType.BigInt,
                               value = salp.sectionRateId.ToString()
                           },
                                  new SqlStoreProcedureEntity()
                                  {
                                      name = "itemId",
                                      datatype = SqlDbType.BigInt,
                                      value = itemId.ToString()
                                  },
                              new SqlStoreProcedureEntity()
                              {
                                  name = "sectionId",
                                  datatype = SqlDbType.BigInt,
                                  value = salp.sectionId.ToString()
                              },

                              new SqlStoreProcedureEntity()
                              {
                                  name = "itemRate",
                                  datatype = SqlDbType.Decimal,
                                  value = salp.itemRate.ToString()
                              },

                        });

                            }
                            response.status = false;
                            response.message = "Section saved ";
                        }
                        catch (Exception x)
                        {
                            response.status = false;
                            response.message = "errror in section data";
                        }


                    }
                    long itemTaxId = Convert.ToInt32(dataTable.Rows[0][0]);


                    if (Request.TaxItems != null)
                    {
                        DataTable dataTable1 = new DataTable();
                        try
                        {

                            foreach (var txi in Request.TaxItems)
                            {

                                dataTable1 = new SqlQuery().Execute("usp_saveTaxItem", new List<SqlStoreProcedureEntity>()
                        {
                           new SqlStoreProcedureEntity()
                           {
                               name = "itemTaxId",
                               datatype = SqlDbType.BigInt,
                               value = txi.itemTaxId.ToString()
                           },
                                  new SqlStoreProcedureEntity()
                                  {
                                      name = "itemId",
                                      datatype = SqlDbType.BigInt,
                                      value = itemId.ToString()
                                  },

                               new SqlStoreProcedureEntity()
                           {
                               name = "taxId",
                               datatype = SqlDbType.BigInt,
                               value = txi.taxId.ToString()
                           },
                                new SqlStoreProcedureEntity()
                           {
                               name = "isActive",
                               datatype = SqlDbType.Bit,
                               value = txi.isActive.ToString()
                           },


                        });

                            }
                            response.status = false;
                            response.message = "tax saved";
                        }
                        catch
                        {
                            response.status = false;
                            response.message = "Error in tax data";
                        }

                    }


                    if (Request.TransactionItems != null)
                    {
                        DataTable dataTable1 = new DataTable();
                        try
                        {
                            foreach (var trn in Request.TransactionItems)
                            {

                                dataTable1 = new SqlQuery().Execute("usp_saveTransactionRates", new List<SqlStoreProcedureEntity>()
                        {
                           new SqlStoreProcedureEntity()
                           {
                               name = "transactionItemId",
                               datatype = SqlDbType.BigInt,
                               value = trn.transactionItemId.ToString()
                           },
                            new SqlStoreProcedureEntity()
                           {
                               name = "transactionId",
                               datatype = SqlDbType.BigInt,
                               value = trn.transactionId.ToString()
                           },
                           new SqlStoreProcedureEntity()
                            {
                                name = "itemId",
                                datatype = SqlDbType.BigInt,
                                value = itemId.ToString()
                            },

                            new SqlStoreProcedureEntity()
                            {
                              name = "transactionItemCost",
                              datatype = SqlDbType.Decimal,
                              value = trn.transactionItemCost.ToString()
                            },

                        });


                            }
                            response.status = false;
                            response.message = "transaction saved";
                        }
                        catch
                        {
                            response.status = false;
                            response.message = "error in trannsaction data";
                        }
                    }
                    response.status = true;
                    response.message = dataTable.Rows[0][2].ToString();
                }
                else
                {
                    response.status = false;
                    response.message = "error in item data";
                }


            }

            catch (Exception ex)
            {
                //objTrans.Rollback();
                response.status = false;
                response.message = ex.Message.ToString();
            }
            return response;
        }

        public DBResponse UpadateIsActive(ItemModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updatItemStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "itemId",
                    datatype = SqlDbType.BigInt,
                    value =Request.itemId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "isActive",
                    datatype = SqlDbType.Bit,
                    value =Request.isActive.ToString()
                  },

                });
                response.status = Convert.ToBoolean(dataTable.Rows[0][0]);
                response.message = dataTable.Rows[0][1].ToString();
                //response.indentno = Convert.ToInt64(dataTable.Rows[0][2]);
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
            }
            return response;
        }

    }
}