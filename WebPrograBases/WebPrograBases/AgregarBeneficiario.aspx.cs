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
    public partial class AgregarBeneficiario : System.Web.UI.Page
    {
        string connectionString = "Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateGridview();
            }
        }

        void PopulateGridview()
        {
            DataTable dtbl = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("VerBeneficiariosMini", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inIDCuenta", SqlDbType.Int).Value = Session["numCuenta"];
                dtbl.Load(sql_cmnd.ExecuteReader());
            }
            if (dtbl.Rows.Count > 0)
            {
                tblAgregarBeneficiarios.DataSource = dtbl;
                tblAgregarBeneficiarios.DataBind();
            }

        }

        protected void btnPorcentajes_Click(object sender, EventArgs e)
        {

        }

        protected void btnBeneficiario1_Click(object sender, EventArgs e)
        {
            int doc = Convert.ToInt32(TextBox1.Text.Trim());
            int entrada = Convert.ToInt32(TextBox0.Text.Trim());
            int porcen = validarPorcentaje(entrada, doc);

            if (porcen < 100)
            {
                if (contBeneficiarios() < 3)
                {
                    lblErrorMessage.Text = "";
                    try
                    {
                        using (SqlConnection sqlCon = new SqlConnection(connectionString))
                        {
                            sqlCon.Open();
                            SqlCommand sql_cmnd = new SqlCommand("AgregarBeneficiario", sqlCon);
                            sql_cmnd.CommandType = CommandType.StoredProcedure; //cambiar nombres de parámetros
                            sql_cmnd.Parameters.AddWithValue("@inPorcentaje", SqlDbType.Int).Value = Convert.ToInt32(TextBox0.Text.Trim());
                            sql_cmnd.Parameters.AddWithValue("@inIDDocumentoIdentidad", SqlDbType.Int).Value = Convert.ToInt32(TextBox1.Text.Trim());
                            sql_cmnd.Parameters.AddWithValue("@inIDNumeroCuenta", SqlDbType.Int).Value = Convert.ToInt32(TextBox2.Text.Trim());
                            sql_cmnd.Parameters.AddWithValue("@inIDParentezco", SqlDbType.Int).Value = Convert.ToInt32(TextBox3.Text.Trim());
                            sql_cmnd.ExecuteNonQuery();
                            tblAgregarBeneficiarios.EditIndex = -1;
                            PopulateGridview();
                            lblSuccessMessage.Text = "Información agregada correctamente";
                            lblErrorMessage.Text = "";
                        }
                    }
                    catch (Exception ex)
                    {
                        lblSuccessMessage.Text = ex.Message;
                        lblErrorMessage.Text = "Debe agregar una persona con el Valor de Documento de Identidad para lograr ingresar un nuevo beneficiario";
                    }
                }
                else
                {
                    lblErrorMessage.Text = "La cuenta ya tiene tres beneficiarios activos";
                }
            }
            else
            {
                lblErrorMessage.Text = "Su porcentaje total no debe ser mayor que 100 por favor corregirlo y volver a intentar.";
            }
            
            
        }

        protected void btnAgregarPersona_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    SqlCommand sql_cmnd = new SqlCommand("AgregarPersona", sqlCon);
                    sql_cmnd.CommandType = CommandType.StoredProcedure; //cambiar nombres de parámetros
                    sql_cmnd.Parameters.AddWithValue("@inIDDocumentoIdentidad", SqlDbType.Int).Value = Convert.ToInt32(TextBox18.Text.Trim());
                    sql_cmnd.Parameters.AddWithValue("@inNombre", SqlDbType.NVarChar).Value = TextBox17.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inFechaNacimiento", SqlDbType.NVarChar).Value = TextBox16.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inEmail", SqlDbType.NVarChar).Value = TextBox15.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inTelefono1", SqlDbType.NVarChar).Value = TextBox14.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inTelefono2", SqlDbType.NVarChar).Value = TextBox13.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inTDocumento", SqlDbType.Int).Value = Convert.ToInt32(TextBox12.Text.Trim());
                    sql_cmnd.ExecuteNonQuery();
                    tblAgregarBeneficiarios.EditIndex = -1;
                    PopulateGridview();
                    Label1.Text = "Información agregada correctamente";
                    Label1.Text = "";
                }
            }
            catch (Exception ex)
            {
                Label2.Text = "Estas trippeando bro";
                Label2.Text = ex.Message;
            }
        }

        protected int contBeneficiarios()
        {
            int cantidad = 0;

            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("CountBeneficiarios", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inIDCuenta", SqlDbType.Int).Value = Session["numCuenta"];
                cantidad = Convert.ToInt32(sql_cmnd.ExecuteScalar());
                sqlCon.Close();

            }

            return cantidad;
        }
        private int validarPorcentaje(int entrada, int doc)
        {
            int porcentaje = 0;

            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("SumarPorcentajes", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inIDCuenta", SqlDbType.NVarChar).Value = Session["numCuenta"];
                sql_cmnd.Parameters.AddWithValue("@inPorcentaje", SqlDbType.NVarChar).Value = entrada;
                sql_cmnd.Parameters.AddWithValue("@inIDDocIndentidad", SqlDbType.NVarChar).Value = doc;
                try
                {
                    porcentaje = Convert.ToInt32(sql_cmnd.ExecuteScalar());
                    porcentaje = porcentaje + entrada;
                }
                catch (Exception ex)
                {
                    porcentaje = entrada;
                }
                sqlCon.Close();
            }

            return porcentaje;
        }
    }
}