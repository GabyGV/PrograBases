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
    public partial class Configuracion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                                int admin = Convert.ToInt32(Session["EsAdministrador"]);
                if (admin == 1)
                {
                    ddFillAdmin();
                }
                else
                {
                    ddFill();
                }
            }
        }

        protected void ddFill()
        {
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerNumCuentas", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inIDPersona", SqlDbType.Int).Value = Session["idPersona"];
                SqlDataAdapter sqlAdapter = new SqlDataAdapter(sql_cmnd);
                DataTable dt = new DataTable();
                sqlAdapter.Fill(dt);
                ddnumCuenta.DataSource = dt;
                ddnumCuenta.DataBind();
                ddnumCuenta.DataTextField = "numeroCuenta";
                ddnumCuenta.DataValueField = "numeroCuenta";
                ddnumCuenta.DataBind();
            }
        }

        protected void ddFillAdmin()
        {
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerNumCuentasAdmin", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter sqlAdapter = new SqlDataAdapter(sql_cmnd);
                DataTable dt = new DataTable();
                sqlAdapter.Fill(dt);
                ddnumCuenta.DataSource = dt;
                ddnumCuenta.DataBind();
                ddnumCuenta.DataTextField = "numeroCuenta";
                ddnumCuenta.DataValueField = "numeroCuenta";
                ddnumCuenta.DataBind();
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            int numCuenta = 0;
            numCuenta = Convert.ToInt32(this.ddnumCuenta.SelectedItem.Text);
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("desactivarCuenta", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inNumCuenta", SqlDbType.Int).Value = numCuenta;
                sql_cmnd.ExecuteReader();
            }
            int admin = Convert.ToInt32(Session["EsAdministrador"]);
            if (admin == 1)
            {
                ddFillAdmin();
            }
            else
            {
                ddFill();
            }
        }
    }
}