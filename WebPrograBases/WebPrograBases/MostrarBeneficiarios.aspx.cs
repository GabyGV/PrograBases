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
    public partial class MostrarBeneficiarios : System.Web.UI.Page
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
                SqlCommand sql_cmnd = new SqlCommand("VerBeneficiarios", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@inNumeroCuenta", SqlDbType.Int).Value = Session["numCuenta"];
                dtbl.Load(sql_cmnd.ExecuteReader());
            }
            if (dtbl.Rows.Count > 0)
            {
                tblBeneficiarios.DataSource = dtbl;
                tblBeneficiarios.DataBind();
            }/*
            else
            {
                dtbl.Rows.Add(dtbl.NewRow());
                tblBeneficiarios.DataSource = dtbl;
                tblBeneficiarios.DataBind();
                tblBeneficiarios.Rows[0].Cells.Clear();
                tblBeneficiarios.Rows[0].Cells.Add(new TableCell());
                tblBeneficiarios.Rows[0].Cells[0].ColumnSpan = dtbl.Columns.Count;
                tblBeneficiarios.Rows[0].Cells[0].Text = "No Data Found ..!";
                tblBeneficiarios.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
            }*/

        }

        /*
        protected void tblBeneficiarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName.Equals("AddNew"))
                {
                    using (SqlConnection sqlCon = new SqlConnection(connectionString)) 
                    {
                        sqlCon.Open();
                        SqlCommand sql_cmnd = new SqlCommand("AgregarBeneficiario", sqlCon); //insert
                        sql_cmnd.CommandType = CommandType.StoredProcedure; //cambiar nombres de parámetros
                        sql_cmnd.Parameters.AddWithValue("@FirstName", (tblBeneficiarios.FooterRow.FindControl("txtNombreFooter") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@LastName", (tblBeneficiarios.FooterRow.FindControl("txtIDParentezcoFooter") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@Contact", (tblBeneficiarios.FooterRow.FindControl("txtPorcentajeFooter") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtFechaNacimientoFooter") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtValorDocIdentidadFooter") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtEmailFooter") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtTelefono1Footer") as TextBox).Text.Trim());
                        sql_cmnd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtTelefono2Footer") as TextBox).Text.Trim());
                        sql_cmnd.ExecuteNonQuery();
                        PopulateGridview();
                        lblSuccessMessage.Text = "Nuevo beneficiario agregado";
                        lblErrorMessage.Text = "";
                    }
                }
            }
            catch (Exception ex)
            {
                lblSuccessMessage.Text = "";
                lblErrorMessage.Text = ex.Message;
            }
        }
        */

        protected void tblBeneficiarios_RowEditing(object sender, GridViewEditEventArgs e)
        {
            tblBeneficiarios.EditIndex = e.NewEditIndex;
            PopulateGridview();
        }

        protected void tblBeneficiarios_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            tblBeneficiarios.EditIndex = -1;
            PopulateGridview();
        }



        protected void tblBeneficiarios_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            try
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    SqlCommand sql_cmnd = new SqlCommand("ActualizarBeneficiarios", sqlCon);
                    sql_cmnd.CommandType = CommandType.StoredProcedure; //cambiar nombres de parámetros
                    sql_cmnd.Parameters.AddWithValue("@inValorDocumentoIdentidad", Convert.ToInt32((tblBeneficiarios.Rows[e.RowIndex].FindControl("txtValorDocIdentidad") as TextBox).Text.Trim()));
                    sql_cmnd.Parameters.AddWithValue("@inNombre", (tblBeneficiarios.Rows[e.RowIndex].FindControl("txtNombre") as TextBox).Text.Trim());
                    sql_cmnd.Parameters.AddWithValue("@inIDParentezco", Convert.ToInt32((tblBeneficiarios.Rows[e.RowIndex].FindControl("txtIDParentezco") as TextBox).Text.Trim()));
                    sql_cmnd.Parameters.AddWithValue("@inPorcentaje", Convert.ToInt32((tblBeneficiarios.Rows[e.RowIndex].FindControl("txtPorcentaje") as TextBox).Text.Trim()));
                    sql_cmnd.Parameters.AddWithValue("@inFechaNacimiento", (tblBeneficiarios.Rows[e.RowIndex].FindControl("txtFechaNacimiento") as TextBox).Text.Trim());
                    sql_cmnd.Parameters.AddWithValue("@inValorDocIdentidad", Convert.ToInt32((tblBeneficiarios.Rows[e.RowIndex].FindControl("txtValorDocIdentidad") as TextBox).Text.Trim()));
                    sql_cmnd.Parameters.AddWithValue("@inEmail", (tblBeneficiarios.Rows[e.RowIndex].FindControl("txtEmail") as TextBox).Text.Trim());
                    sql_cmnd.Parameters.AddWithValue("@inTelefono1", (tblBeneficiarios.Rows[e.RowIndex].FindControl("txtTelefono1") as TextBox).Text.Trim());
                    sql_cmnd.Parameters.AddWithValue("@inTelefono2", (tblBeneficiarios.Rows[e.RowIndex].FindControl("txtTelefono2") as TextBox).Text.Trim());
                    sql_cmnd.ExecuteNonQuery();
                    tblBeneficiarios.EditIndex = -1;
                    PopulateGridview();
                    lblSuccessMessage.Text = "Información actualizada correctamente";
                    lblErrorMessage.Text = "";
                }
            }
            catch (Exception ex)
            {
                lblSuccessMessage.Text = "";
                lblErrorMessage.Text = ex.Message;
            }
        }


        protected void tblBeneficiarios_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    SqlCommand sql_cmnd = new SqlCommand("EliminarBeneficiario", sqlCon);
                    sql_cmnd.CommandType = CommandType.StoredProcedure;
                    sql_cmnd.Parameters.AddWithValue("@inValorDocumentoIdentidad", Convert.ToInt32(tblBeneficiarios.DataKeys[e.RowIndex].Value.ToString()));
                    sql_cmnd.ExecuteNonQuery();
                    PopulateGridview();
                    lblSuccessMessage.Text = "El beneficiario fue eliminado exitosamente.";
                    lblErrorMessage.Text = "";
                }
            }
            catch (Exception ex)
            {
                lblSuccessMessage.Text = "";
                //lblErrorMessage.Text = ex.Message;
                Console.WriteLine(ex.StackTrace);
            }
        }

        private int validarPorcentaje()
        {
            int porcentaje = 0;

            using (SqlConnection sqlCon = new SqlConnection("Initial Catalog = PrograBases; Data Source=localhost;Integrated Security=SSPI;"))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand("loginUsuario", sqlCon);
                sql_cmnd.CommandType = CommandType.StoredProcedure;
                sql_cmnd.Parameters.AddWithValue("@in_username", SqlDbType.NVarChar).Value = txtUserName.Text.Trim();
                sql_cmnd.Parameters.AddWithValue("@in_Pass", SqlDbType.NVarChar).Value = txtPassword.Text.Trim();
                int count = Convert.ToInt32(sql_cmnd.ExecuteScalar());
                sqlCon.Close();
            }

            return porcentaje;
        }
    }

    
}