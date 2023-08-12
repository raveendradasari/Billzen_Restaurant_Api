using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api
{
    public class DBResponse
    {
        public bool status { get; set; }
        public string message { get; set; }
        public long id { get; set; }
        public string file_path { get; set; }
    }

    public static class Connection
    {
        public static SqlConnection sqlConnection = null;
        public static void EstablishSqlConnection()
        {
            try
            {
                sqlConnection = new SqlConnection();
                sqlConnection.ConnectionString = ConfigurationManager.ConnectionStrings["sqlconnectionstring"].ConnectionString;
                sqlConnection.Open();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static bool TerminateConnection(SqlConnection connection)
        {
            try
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
    public class SqlQuery
    {
        public DataTable Execute(
          string StoreProcedureName,
          List<SqlStoreProcedureEntity> Parameters)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlCommand selectCommand = new SqlCommand())
                {
                    selectCommand.Connection = Connection.sqlConnection;
                    selectCommand.CommandType = CommandType.StoredProcedure;
                    selectCommand.CommandText = StoreProcedureName;
                    if (Parameters != null)
                    {
                        foreach (SqlStoreProcedureEntity parameter in Parameters)
                            selectCommand.Parameters.Add("@" + parameter.name, parameter.datatype).Value = (object)parameter.value;
                    }
                    using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand))
                    {
                        sqlDataAdapter.Fill(dataTable);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dataTable;
        }
    }
    public class SqlQueryDataSet
    {
        public DataSet Execute(
          string StoreProcedureName,
          List<SqlStoreProcedureEntity> Parameters)
        {
            DataSet ds = new DataSet();
            try
            {
                using (SqlCommand selectCommand = new SqlCommand())
                {
                    selectCommand.Connection = Connection.sqlConnection;
                    selectCommand.CommandType = CommandType.StoredProcedure;
                    selectCommand.CommandText = StoreProcedureName;
                    if (Parameters != null)
                    {
                        foreach (SqlStoreProcedureEntity parameter in Parameters)
                            selectCommand.Parameters.Add("@" + parameter.name, parameter.datatype).Value = (object)parameter.value;
                    }
                    using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand))
                    {
                        sqlDataAdapter.Fill(ds);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ds;
        }
    }
}