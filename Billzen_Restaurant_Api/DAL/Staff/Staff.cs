using Billzen_Restaurant_Api.DAL.Customer;
using Billzen_Restaurant_Api.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.DAL.Staff
{
    public class Staff
    {
        public IList<StaffModel> GetStaff(long staffId)
        {
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_getstaff", new List<SqlStoreProcedureEntity>()
                {
                     new SqlStoreProcedureEntity()
                  {
                    name = "staffId",
                         datatype = SqlDbType.BigInt,
                    value =staffId.ToString()
                  },
                });

                return (IList<StaffModel>)dataTable.AsEnumerable().Select<DataRow, StaffModel>((Func<DataRow, StaffModel>)(row => new StaffModel()
                {
                    staffId = row.Field<long>("staffId"),
                    staff_name = row.Field<string>("staff_name"),
                    Mobilenumber = row.Field<string>("Mobilenumber"),
                    address = row.Field<string>("address"),
                    joiningdate = row.Field<DateTime>("joiningdate").ToLongDateString(),
                    refferedby = row.Field<string>("refferedby"),
                    designation = row.Field<string>("designation"),
                    department = row.Field<string>("department"),
                    document_type = row.Field<string>("document_type"),
                    documentdetails = row.Field<string>("documentdetails"),
                    isactive = row.Field<bool>("isactive"),
                })).ToList<StaffModel>();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DBResponse SaveStaff(StaffModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_savestaff", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "staffId",
                    datatype = SqlDbType.BigInt,
                    value = Request.staffId.ToString()
                  },

                  new SqlStoreProcedureEntity()
                  {
                    name = "staff_name",
                    datatype = SqlDbType.NVarChar,
                    value = Request.staff_name
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "Mobilenumber",
                    datatype = SqlDbType.NVarChar,
                    value = Request.Mobilenumber
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "address",
                    datatype = SqlDbType.NVarChar,
                    value = Request.address
                  },
                  new SqlStoreProcedureEntity()
                  {
                    name = "joiningdate",
                    datatype = SqlDbType.DateTime,
                    value = Request.joiningdate.ToString()
                  },
                   new SqlStoreProcedureEntity()
                  {
                    name = "refferedby",
                    datatype = SqlDbType.NVarChar,
                    value = Request.refferedby
                  },
                    new SqlStoreProcedureEntity()
                  {
                    name = "designation",
                    datatype = SqlDbType.NVarChar,
                    value = Request.designation
                  },
                     new SqlStoreProcedureEntity()
                  {
                    name = "department",
                    datatype = SqlDbType.NVarChar,
                    value = Request.department
                  },
                      new SqlStoreProcedureEntity()
                  {
                    name = "document_type",
                    datatype = SqlDbType.NVarChar,
                    value = Request.document_type
                  },
                       new SqlStoreProcedureEntity()
                  {
                    name = "documentdetails",
                    datatype = SqlDbType.NVarChar,
                    value = Request.documentdetails
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
        public DBResponse UpadateIsActive(StaffModel Request)
        {
            DBResponse response = new DBResponse();
            try
            {
                DataTable dataTable = new SqlQuery().Execute("usp_updateStaffStatus", new List<SqlStoreProcedureEntity>()
                {
                  new SqlStoreProcedureEntity()
                  {
                    name = "staffId",
                    datatype = SqlDbType.BigInt,
                    value =Request.staffId.ToString()
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