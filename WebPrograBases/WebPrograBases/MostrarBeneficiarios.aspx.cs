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
            }
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
            }

        }


        protected void tblBeneficiarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName.Equals("AddNew"))
                {
                    using (SqlConnection sqlCon = new SqlConnection(connectionString))
                    {
                        sqlCon.Open();
                        string query = "INSERT INTO PhoneBook (FirstName,LastName,Contact,Email) VALUES (@FirstName,@LastName,@Contact,@Email)";
                        SqlCommand sqlCmd = new SqlCommand(query, sqlCon);
                        sqlCmd.Parameters.AddWithValue("@FirstName", (tblBeneficiarios.FooterRow.FindControl("txtNombreFooter") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@LastName", (tblBeneficiarios.FooterRow.FindControl("txtIDParentezcoFooter") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@Contact", (tblBeneficiarios.FooterRow.FindControl("txtPorcentajeFooter") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtFechaNacimientoFooter") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtValorDocIdentidadFooter") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtEmailFooter") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtTelefono1Footer") as TextBox).Text.Trim());
                        sqlCmd.Parameters.AddWithValue("@Email", (tblBeneficiarios.FooterRow.FindControl("txtTelefono2Footer") as TextBox).Text.Trim());
                        sqlCmd.ExecuteNonQuery();
                        PopulateGridview();
                        lblSuccessMessage.Text = "New Record Added";
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
    }
}