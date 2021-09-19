using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPrograBases
{
    public partial class Segunda : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnEstadosCuenta_Click(object sender, EventArgs e)
        {
            Response.Redirect("MostrarCuenta.aspx");
        }

        protected void btnBeneficiarios_Click(object sender, EventArgs e)
        {
            Response.Redirect("MostrarBeneficiarios.aspx");
        }
    }
}