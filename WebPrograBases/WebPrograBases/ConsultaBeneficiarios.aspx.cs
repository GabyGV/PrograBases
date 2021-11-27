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
    public partial class ConsultaBeneficiarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
                {
                    sqlCon.Open();
                    SqlCommand sql_cmnd = new SqlCommand("ConsultarBeneficiarios", sqlCon);
                    sql_cmnd.CommandType = CommandType.StoredProcedure;
                    DataTable dtbl = new DataTable();
                    dtbl.Load(sql_cmnd.ExecuteReader());
                    ConsultaPorBeneficiario.DataSource = dtbl;
                    ConsultaPorBeneficiario.DataBind();
                }
            }
        }

        protected void lnkSelect_Click(object sender, EventArgs e)
        {
            
        }
    }

}