<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsultaMulta.aspx.cs" Inherits="WebPrograBases.ConsultaMulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta por Multa</title>
    <style>
        body{
            background-color:#B9BFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h3>
                Descripción: 
                <small class="text-muted">En esta consulta se muestran las cuentas con multas por exceso de operaciones en cajeros automáticos.</small>
            </h3>
        </div>
        <div>
            <table style="margin:auto;border:5px solid white">
                <tr>
                    <td>
                        <p class="lead">
                          Ingrese la cantidad de días a buscar
                        </p>
                    </td>
                    <td>
                        <asp:TextBox ID="txtCantDias" runat="server" MaxLength="2" TextMode="Number" Text="1"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" OnClick="btnBuscar_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <h1>Resultado:</h1>
            <div>
                <asp:GridView ID="ConsultaPorMulta" runat="server" AutoGenerateColumns="false" >
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText ="ID de cuenta" />
                        <asp:BoundField DataField="Promedio" HeaderText ="Promedio de operaciones ATM" />
                        <asp:BoundField DataField="FechaMax" HeaderText ="Fecha con la mayor cantidad de operaciones ATM" />
                        <asp:TemplateField>
                            <%--<ItemTemplate>
                                <asp:LinkButton ID="lnkSelect" Text="Más detalles" runat="server" CommandArgument='<%# Eval("ID") %>' OnClick="lnkSelect_Click"/>
                            </ItemTemplate>--%>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
