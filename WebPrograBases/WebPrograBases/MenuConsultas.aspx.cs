using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPrograBases
{
    public partial class MenuConsultas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnConsultaNegativo_Click(object sender, EventArgs e)
        {

        }

        protected void btnConsultaMulta_Click(object sender, EventArgs e)
        {
            Response.Redirect("ConsultaMulta.aspx");
        }

        protected void btnConsultarBeneficiarios_Click(object sender, EventArgs e)
        {
            Response.Redirect("ConsultaBeneficiarios.aspx");
        }
    }
}