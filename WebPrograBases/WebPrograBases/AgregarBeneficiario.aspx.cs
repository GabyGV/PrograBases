﻿using System;
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
            int doc = Convert.ToInt32(txtDocIdentidadB.Text.Trim());
            int entrada = Convert.ToInt32(txtPorcentaje.Text.Trim());
            int porcen = validarPorcentaje(entrada, doc);

            if (porcen <= 100)
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
                            sql_cmnd.Parameters.AddWithValue("@inPorcentaje", SqlDbType.Int).Value = Convert.ToInt32(txtPorcentaje.Text.Trim());
                            sql_cmnd.Parameters.AddWithValue("@inValorDocumentoIdentidad", SqlDbType.Int).Value = Convert.ToInt32(txtDocIdentidadB.Text.Trim());
                            sql_cmnd.Parameters.AddWithValue("@inIDNumeroCuenta", SqlDbType.Int).Value = Convert.ToInt32(txtNumCuenta.Text.Trim());
                            sql_cmnd.Parameters.AddWithValue("@inIDParentezco", SqlDbType.Int).Value = Convert.ToInt32(txtParentezco.Text.Trim());
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
                    sql_cmnd.Parameters.AddWithValue("@inValorDocumentoIdentidad", SqlDbType.Int).Value = Convert.ToInt32(txtDocIdentidadP.Text.Trim());
                    sql_cmnd.Parameters.AddWithValue("@inNombre", SqlDbType.NVarChar).Value = txtNombre.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inFechaNacimiento", SqlDbType.NVarChar).Value = txtFechaNacimiento.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inEmail", SqlDbType.NVarChar).Value = txtEmail.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inTelefono1", SqlDbType.NVarChar).Value = txtTelefono1.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inTelefono2", SqlDbType.NVarChar).Value = txtTelefono2.Text.Trim();
                    sql_cmnd.Parameters.AddWithValue("@inTDocumento", SqlDbType.Int).Value = Convert.ToInt32(txtTipoDocumento.Text.Trim());
                    sql_cmnd.ExecuteNonQuery();
                    tblAgregarBeneficiarios.EditIndex = -1;
                    PopulateGridview();
                    Label1.Text = "Información agregada correctamente";
                    Label1.Text = "";
                }
            }
            catch (Exception ex)
            {
                Label2.Text = "Algo salió muy mal";
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
                    this.lblErrorMessage.Text = "Error al calcular porcentajes";
                    this.lblErrorMessage.Text = ex.Message;
                    this.lblErrorMessage.Visible = true;
                    porcentaje = entrada;
                }
                sqlCon.Close();
            }

            return porcentaje;
        }

        private int validarPorcentaje2(int entrada, int doc)
        {
            int porcentaje = 0;
            
            foreach(TableRow row in tblAgregarBeneficiarios.Rows)
            {
                foreach(TableCell cell in row.Cells)
                {
                    foreach(Control ctrl in cell.Controls)
                    {
                        if (ctrl.ID == "txtPorcentaje")
                        {
                            porcentaje = porcentaje + Convert.ToInt32((TextBox)ctrl);
                        }
                    }
                }
            }

            return porcentaje + entrada;
        }

    }
}