using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace WebPrograBases
{
    public partial class Principal : System.Web.UI.Page
    {
        public static int Usuario;
        protected void Page_Load(object sender, EventArgs e)
        {
            lblErrorMessage.Visible = false;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            /*
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                string query = "SELECT COUNT(1) FROM Usuario WHERE Username=@IN_username AND Pass=@IN_password";
                SqlCommand sqlCmd = new SqlCommand(query, sqlCon);
                sqlCmd.Parameters.AddWithValue("@IN_username", txtUserName.Text.Trim());
                sqlCmd.Parameters.AddWithValue("@IN_password", txtPassword.Text.Trim());
                int count = Convert.ToInt32(sqlCmd.ExecuteScalar());
                if (count == 1)
                {
                    Session["username"] = txtUserName.Text.Trim();
                    Response.Redirect("Segunda.aspx");
                }
                else { lblErrorMessage.Visible = true; }
            }*/
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("loginUsuario", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@in_username", SqlDbType.NVarChar).Value = txtUserName.Text.Trim();
                sql_cmnd.Parameters.AddWithValue("@in_Pass", SqlDbType.NVarChar).Value = txtPassword.Text.Trim();
                int count = Convert.ToInt32(sql_cmnd.ExecuteScalar());
                sqlCon.Close();
                if (count == 1)
                {
                    //Usuario = txtUserName.Text.Trim();
                    Session["username"] = txtUserName.Text.Trim();
                    Response.Redirect("Segunda.aspx");
                }
                else { lblErrorMessage.Visible = true; }
            }
            
        }

        protected void btnConsultas_Click(object sender, EventArgs e)
        {
            Response.Redirect("MenuConsultas.aspx");
        }
    }
}