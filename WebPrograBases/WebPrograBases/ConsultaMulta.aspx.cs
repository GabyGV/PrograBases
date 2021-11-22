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
    public partial class ConsultaMulta : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            int dias = Convert.ToInt32(this.txtCantDias.Text);
            //revisar in and out y nombre
            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("ConsultarMultaPorATM", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inNumDias", SqlDbType.Int).Value = dias;
                DataTable dtbl = new DataTable();
                dtbl.Load(sql_cmnd.ExecuteReader());
                ConsultaPorMulta.DataSource = dtbl;
                ConsultaPorMulta.DataBind();
            }
        }
    }
}