using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Section
{
    public class Section
    {
        public IList<SectionModel> GetSections(long sectionId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getSectionItem", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                    {
                        name = "sectionId",
                         datatype = SqlDbType.BigInt,
                        value = sectionId.ToString()
                    },

                });

                return (IList<SectionModel>)dataTable.AsEnumerable().Select<DataRow, SectionModel>((Func<DataRow, SectionModel>)(row => new SectionModel()
                {
                    sectionId = row.Field<long>("sectionId"),
                    transactionId=row.Field<long>("transactionId"),
                    name = row.Field<string>("name"),
                    transactionName = row.Field<string>("transactionName"),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<SectionModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveSection(SectionModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_savesection", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "sectionId",
                    datatype = SqlDbType.BigInt,
                    value = Request.sectionId.ToString()
                  },

                    new SqlStoreProcedureEntity()
                  {
                    name = "transactionId",
                    datatype = SqlDbType.BigInt,
                    value = Request.transactionId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.name
                  },
                
                    new SqlStoreProcedureEntity()
                  {
                    name = "isactive",
                    datatype = SqlDbType.Bit,
                    value = Request.isactive.ToString()
                  },
                });
                response.status = Convert.ToBoolean(dataTable.Rows[0][0]);
                response.message = dataTable.Rows[0][1].ToString();
            }
            catch (Exception ex)
            {
                response.status = false;
                response.message = ex.Message.ToString();
            }
            return response;
        }
        public DBResponse UpadateIsActive(SectionModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateSectionStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "sectionId",
                    datatype = SqlDbType.BigInt,
                    value =Request.sectionId.ToString()
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "isactive",
                    datatype = SqlDbType.Bit,
                    value =Request.isactive.ToString()
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