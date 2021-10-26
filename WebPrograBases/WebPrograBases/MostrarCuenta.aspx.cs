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
        protected void Page_Load(object sender, EventArgs e)
        {
            ddFill();
        }

        protected void btnConsultar_Click(object sender, EventArgs e)
        {
            int numCuenta = 0;
            //agregar el resultado del número de cuenta
            numCuenta = Convert.ToInt32(this.ddnumCuenta.SelectedValue);
            this.cargarTabla(numCuenta);
        }

        protected void ddFill()
        {
            //Hacer llamada a la base
            //devolver lista
            //con un for agregar al dropdwon
            //DropDownList1.Items.Insert(0, new ListItem("Add New", ""));
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerNumCuentas", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inIDPersona", SqlDbType.Int).Value = 5; //Session["idPersona"];
                /*DataTable dtbl = new DataTable();
                dtbl.Load(sql_cmnd.ExecuteReader());
                Cuentas.DataSource = dtbl;
                Cuentas.DataBind();*/
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

        protected void cargarTabla(int numCuenta)
        {
            //modificar para aceptar numCuenta
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
    }
}