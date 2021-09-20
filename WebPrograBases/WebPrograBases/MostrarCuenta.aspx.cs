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
            Using(SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlDataAdapter sqlDa = new SqlDataAdapter("SELECT * FROM PhoneBook", sqlCon);
                DataTable dtbl = new DataTable();
                sqlDa.Fill(dtbl);
                Cuentas.DataSource = dtbl;
                Cuentas.DataBind();
            }
        }
    }
}