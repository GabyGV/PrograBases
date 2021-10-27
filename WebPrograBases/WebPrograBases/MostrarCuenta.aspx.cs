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
    public partial class MostrarCuenta : System.Web.UI.Page
    {
        int cuentaActual;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.lblMov.Visible = false;
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

        protected void cargarTablaEst(int numCuenta)
        {
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerEstadosCuenta", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inNumCuenta", SqlDbType.Int).Value = numCuenta;
                DataTable dtbl = new DataTable();
                dtbl.Load(sql_cmnd.ExecuteReader());
                EstadoCuenta.DataSource = dtbl;
                EstadoCuenta.DataBind();
            }
        }

        protected void cargarTablaMov(string fecha, int numCuenta)
        {
            this.lblMov.Visible = true;
            fecha = fecha.Split(' ')[0];
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerMovimientos", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inNumCuenta", SqlDbType.Int).Value = numCuenta;
                sql_cmnd.Parameters.AddWithValue("@inFecha", SqlDbType.DateTime).Value = fecha;
                DataTable dtbl = new DataTable();
                dtbl.Load(sql_cmnd.ExecuteReader());
                tblMovimientos.DataSource = dtbl;
                tblMovimientos.DataBind();
            }
        }

        protected void lnkSelect_Click(object sender, EventArgs e)
        {
            string fecha = (sender as LinkButton).CommandArgument;

            //this.lblMov.Text = fecha;
            this.lblMov.Visible = true;
            int numCuenta = 0;
            numCuenta = Convert.ToInt32(this.ddnumCuenta.SelectedItem.Text);
            cargarTablaMov(fecha, numCuenta);
        }

        protected void btnConsultar_Click(object sender, EventArgs e)
        {
            int numCuenta = 0;
            numCuenta = Convert.ToInt32(this.ddnumCuenta.SelectedItem.Text);
            this.cuentaActual = numCuenta;
            this.cargarTablaEst(numCuenta);
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
