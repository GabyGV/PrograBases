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
    public partial class Segunda : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
                Response.Redirect("login.aspx");
            lblUserDetails.Text = "Username : " + Session["username"];

            Session["idPersona"] = ;
        }

        protected void btnEstadosCuenta_Click(object sender, EventArgs e)
        {
            Response.Redirect("MostrarCuenta.aspx");
        }

        protected void btnBeneficiarios_Click(object sender, EventArgs e)
        {
            Response.Redirect("MostrarBeneficiarios.aspx");
        }

        protected int optenerIDPersona()
        {
            sqlCon.Open();
            SqlCommand sql_cmnd = new SqlCommand("loginUsuario", sqlCon);
            sql_cmnd.CommandType = CommandType.StoredProcedure;
            sql_cmnd.Parameters.AddWithValue("@in_username", SqlDbType.NVarChar).Value = txtUserName.Text.Trim();
            sql_cmnd.Parameters.AddWithValue("@in_Pass", SqlDbType.NVarChar).Value = txtPassword.Text.Trim();
            return 0;
        }
    }
}