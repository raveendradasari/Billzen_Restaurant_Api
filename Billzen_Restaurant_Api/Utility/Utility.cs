using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Web;

namespace Billzen_Restaurant_Api.Utility
{
    public static class Extentsions
    {
        public static bool JsonbIsNullOREmpty(this string str)
        {
            bool result = false;
            if (str == "" || str == null || str == "{}" || str == "[]")
            {
                result = true;
            }
            return result;
        }
        public static dynamic GetJsonbData(this string str)
        {
            dynamic result = null;
            try
            {
                if (str == "" || str == null || str == "{}" || str == "[]")
                {
                    return result;
                }
                result = JsonConvert.DeserializeObject<ExpandoObject>((str ?? "").Replace('\"', '"'), new ExpandoObjectConverter());
            }
            catch (Exception ex)
            {
                result = ReturnsNull();
            }
            return (result != null ? (result.data != null ? result.data : null) : null);
        }
        private static dynamic ReturnsNull()
        {
            return null;
        }
        public static bool IsNullOrEmpty(this JToken token)
        {
            return (token == null)
            || (token.Type == JTokenType.Array && !token.HasValues)
            || (token.Type == JTokenType.Object && !token.HasValues)
            || (token.Type == JTokenType.String && token.ToString() == String.Empty)
            || (token.Type == JTokenType.Null)
            || (token.Type == JTokenType.Property && ((JProperty)token).Value.ToString() == string.Empty);
        }
        public static T ConvertToType<T>(this object value) where T : class
        {
            var jsonData = JsonConvert.SerializeObject(value);
            return JsonConvert.DeserializeObject<T>(jsonData);
        }
    }
}