<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MostrarBeneficiarios.aspx.cs" Inherits="WebPrograBases.MostrarBeneficiarios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Beneficiarios</title>
    <style>
        body{
            background-color:#B9BFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Beneficiarios</h1>
            <asp:GridView ID="tblBeneficiarios" runat="server" AutoGenerateColumns="false" DataKeyNames="ValorDocIdentidad"
                ShowHeaderWhenEmpty="true"

                OnRowEditing="tblBeneficiarios_RowEditing" OnRowCancelingEdit="tblBeneficiarios_RowCancelingEdit"
                OnRowUpdating="tblBeneficiarios_RowUpdating" OnRowDeleting="tblBeneficiarios_RowDeleting"

                BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                <%-- Theme Properties --%>
                <%--<FooterStyle BackColor="White" ForeColor="#000066" />--%>
                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                <RowStyle ForeColor="#000066" />
                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#007DBB" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#00547E" />
                
                <Columns>
                    <asp:TemplateField HeaderText="Nombre">
                        <ItemTemplate>
                            <asp:Label ID="Label1" Text='<%# Bind("Nombre") %>' runat="server"></asp:Label> />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtNombre" Text='<%# Bind("Nombre") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Parentezco">
                        <ItemTemplate>
                            <asp:Label ID="Label2" Text='<%# Bind("IDParentezco") %>' runat="server"></asp:Label> />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtIDParentezco" Text='<%# Bind("IDParentezco") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Porcentaje">
                        <ItemTemplate>
                            <asp:Label ID="Label3" Text='<%# Bind("Porcentaje") %>' runat="server" ></asp:Label>/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtPorcentaje" Text='<%# Bind("Porcentaje") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha Nacimiento">
                        <ItemTemplate>
                            <asp:Label ID="Label4" Text='<%# Bind("FechaNacimiento") %>' runat="server"></asp:Label> />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtFechaNacimiento" Text='<%# Bind("FechaNacimiento") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Valor Documento de Identidad">
                        <ItemTemplate>
                            <asp:Label ID="Label5" Text='<%# Bind("ValorDocIdentidad") %>' runat="server"></asp:Label> />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtValorDocIdentidad" Text='<%# Bind("ValorDocIdentidad") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Email">
                        <ItemTemplate>
                            <asp:Label ID="Label6" Text='<%# Bind("Email") %>' runat="server"></asp:Label> />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEmail" Text='<%# Bind("Email") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Telefono 1">
                        <ItemTemplate>
                            <asp:Label ID="Label7" Text='<%# Bind("Telefono1") %>' runat="server" ></asp:Label>/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtTelefono1" Text='<%# Bind("Telefono1") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Telefono 2">
                        <ItemTemplate>
                            <asp:Label ID="Label8" Text='<%# Bind("Telefono2") %>' runat="server"></asp:Label> />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtTelefono2" Text='<%# Bind("Telefono2") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ImageUrl="~/Images/edit.png" runat="server" CommandName="Edit" ToolTip="Edit" Width="20px" Height="20px"/>
                            <asp:ImageButton ImageUrl="~/Images/delete.png" runat="server" CommandName="Delete" ToolTip="Delete" Width="20px" Height="20px"/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:ImageButton ImageUrl="~/Images/save.png" runat="server" CommandName="Update" ToolTip="Update" Width="20px" Height="20px"/>
                            <asp:ImageButton ImageUrl="~/Images/cancel.png" runat="server" CommandName="Cancel" ToolTip="Cancel" Width="20px" Height="20px"/>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <asp:Label ID="lblSuccessMessage" Text="" runat="server" ForeColor="Green" />
            <br />
            <asp:Label ID="lblErrorMessage" Text="" runat="server" ForeColor="Red" />
            <br />
            <asp:Label ID="lblPorcentaje" Text="" runat="server" ForeColor="Red" />
        </div>
    </form>
</body>
</html>
