<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgregarBeneficiario.aspx.cs" Inherits="WebPrograBases.AgregarBeneficiario" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style>

        body{
            background-color:#B9BFFF;
        }
        .auto-style1 {
            width: 1026px;
        }
        .auto-style2 {
            height: 26px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="tblAgregarBeneficiarios" runat="server" AutoGenerateColumns="false" DataKeyNames="ValorDocIdentidad"
                               ShowHeaderWhenEmpty="true"

                BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" Width="660px">
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
                    <asp:TemplateField HeaderText="Porcentaje">
                        <ItemTemplate>
                            <asp:Label ID="Label5" Text='<%# Bind("Porcentaje") %>' runat="server" ></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtPorcentaje" Text='<%# Bind("Porcentaje") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Valor Documento de Identidad">
                        <ItemTemplate>
                            <asp:Label ID="Label7" Text='<%# Bind("ValorDocIdentidad") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtValorDocIdentidad" Text='<%# Bind("ValorDocIdentidad") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Numero Cuenta">
                        <ItemTemplate>
                            <asp:Label ID="Label8" Text='<%# Bind("IDNumeroCuenta") %>' runat="server"></asp:Label> 
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtIDNumeroCuenta" Text='<%# Bind("IDNumeroCuenta") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Parentezco">
                        <ItemTemplate>
                            <asp:Label ID="Label9" Text='<%# Bind("IDParentezco") %>' runat="server" ></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtIDParentezco" Text='<%# Bind("IDParentezco") %>' runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
                </asp:GridView>
                <p>
                    <asp:Button ID="btnEstadosCuenta" runat="server" Text=" Actualizar Porcentajes" OnClick="btnPorcentajes_Click" />
                </p>
            <h1>Agregar Beneficiarios</h1>
            <tr>
                <th><h2>Beneficiario </h2></th>
                <th><asp:Button ID="ButtonB1" runat="server" Text=" Agregar" OnClick="btnBeneficiario1_Click" /></th>
            </tr>
            <table class="sortable">
                <Colums>
                    <tr>
                        <th class="auto-style2"><p>Porcentaje</p></th>
                        <th class="auto-style2"> <asp:TextBox ID="txtPorcentaje" Text='' runat="server"  /></th>
                        <th class="auto-style2"></th>
                        <th class="auto-style2"><p>Documento Identidad</p></th>
                        <th class="auto-style2"> <asp:TextBox ID="txtDocIdentidadB" Text='' runat="server" /></th>
                        <th class="auto-style2"></th>
                        <th class="auto-style2"><p>Numero Cuenta</p></th>
                        <th class="auto-style2"> <asp:TextBox ID="txtNumCuenta" Text='' runat="server" /></th>
                        <th class="auto-style2"></th>
                        <th class="auto-style2"><p>Parentezco</p></th>
                        <th class="auto-style2"> <asp:TextBox ID="txtParentezco" Text='' runat="server" /></th>
                        <th class="auto-style2"></th>
                    </tr>
                </Colums>
             </table>
            <asp:Label ID="lblSuccessMessage" Text="" runat="server" ForeColor="Green" />
            <br />
            <asp:Label ID="lblErrorMessage" Text="" runat="server" ForeColor="Red" />
            </div>
            <div id="Divition">
             <table id="tblPersona">
                 <h2 class="auto-style1">Datos de la persona a agregar</h2>
                 <tr>
                     <th><p> ValorDocIdentidad </p></th>
                     <th><p> Nombre </p></th>
                     <th><p> FechaNacimiento </p></th>
                     <th><p> Email </p></th>
                     <th><p> Telefono1 </p></th>
                     <th><p> Telefono2 </p></th>
                     <th><p> Tipo Documento</p></th>
                 </tr>
                  <tr>
                     <th><asp:TextBox ID="txtDocIdentidadP" Text='' runat="server" /></th>
                     <th><asp:TextBox ID="txtNombre" Text='' runat="server" /></th>
                     <th><asp:TextBox ID="txtFechaNacimiento" Text='' runat="server" /></th>
                     <th><asp:TextBox ID="txtEmail" Text='' runat="server" /></th>
                     <th><asp:TextBox ID="txtTelefono1" Text='' runat="server" /></th>
                     <th><asp:TextBox ID="txtTelefono2" Text='' runat="server" /></th>
                     <th><asp:TextBox ID="txtTipoDocumento" Text='' runat="server" /></th>
                 </tr>
             </table>
            <p>
                <asp:Button ID="btnAgregarPersona" runat="server" Text="Agregar Persona" OnClick="btnAgregarPersona_Click" />
             </p>
            <asp:Label ID="Label1" Text="" runat="server" ForeColor="Green" />
            <br />
            <asp:Label ID="Label2" Text="" runat="server" ForeColor="Red" />
        </div>
        
    </form>
</body>
</html>
