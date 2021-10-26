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
            this.lblMov.Visible = false;
            int admin = Convert.ToInt32(Session["EsAdministrador"]);
            if(admin == 1)
            {
                ddFillAdmin();
            }
            else
            {
                ddFill();
            }
            
        }

        protected void btnConsultar_Click(object sender, EventArgs e)
        {
            int numCuenta = 0;
            //agregar el resultado del número de cuenta
            numCuenta = Convert.ToInt32(this.ddnumCuenta.SelectedValue);
            this.cuentaActual = numCuenta;
            this.cargarTablaEst(numCuenta);
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

        protected void cargarTablaMov(string fecha)
        {
            //modificar para aceptar numCuenta
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerMovimientos", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inNumCuenta", SqlDbType.Int).Value = this.cuentaActual;
                sql_cmnd.Parameters.AddWithValue("@inFecha", SqlDbType.NVarChar).Value = fecha;
                DataTable dtbl = new DataTable();
                dtbl.Load(sql_cmnd.ExecuteReader());
                EstadoCuenta.DataSource = dtbl;
                EstadoCuenta.DataBind();
            }
        }

        protected void EstadoCuenta_SelectedIndexChanged(object sender, EventArgs e)
        {
            /*
            TextBoxUserID.Text = GridView1.SelectedRow.Cells[1].Text;
            TextBoxUserName.Text = GridView1.SelectedRow.Cells[2].Text; */
            string fecha = EstadoCuenta.SelectedRow.Cells[1].Text;
            this.lblMov.Visible = true;
            cargarTablaMov(fecha);

        }
    }
}