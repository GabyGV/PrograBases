<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsultaNegativo.aspx.cs" Inherits="WebPrograBases.ConsultaNegativo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta por Saldo Negativo</title>
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
                <small class="text-muted">En esta consulta se muestran las cuentas objetivo en las que no se pudo realizar un retiro debido a 
                    que el saldo era negativo, su código de la cuenta, ID de la cuenta objetivo, descripción, cantidad de retiros realizados, 
                    cantidad de retiros si se hubieran realizados todos, suma del monto debitado real, suma del monto debitado si se hubieran realizado todos los retiros.</small>
            </h3>
        </div>
        <div>
            <h1>Resultado:</h1>
            <div>
                <asp:GridView ID="ConsultaPorNegativos" runat="server" AutoGenerateColumns="false" >
                    <Columns>
                        <asp:BoundField DataField="NumCuenta" HeaderText ="Número de cuenta" />
                        <asp:BoundField DataField="IDCuentaO" HeaderText ="ID de cuenta objetivo" />
                        <asp:BoundField DataField="Descripcion" HeaderText ="Descripción" />
                        <asp:BoundField DataField="CantRetirosRealizados" HeaderText ="Cantidad de retiros realizados" />
                        <asp:BoundField DataField="CantRetirosIntentos" HeaderText ="Cantidad de intentos de retiros" />
                        <asp:BoundField DataField="MontoReal" HeaderText ="Monto real" />
                        <asp:BoundField DataField="MontoConRetiros" HeaderText ="Monto con intentos de retiro" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkSelect" Text="Más detalles" runat="server" CommandArgument='<%# Eval("NumCuenta") %>' OnClick="lnkSelect_Click"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
