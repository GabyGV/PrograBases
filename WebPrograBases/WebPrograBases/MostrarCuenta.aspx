<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MostrarCuenta.aspx.cs" Inherits="WebPrograBases.MostrarCuenta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mostrar Cuenta</title>
    <style>
        body{
            background-color:#B9BFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Elija su cuenta:</h1>
            <asp:DropDownList ID="numCuenta" runat="server" Height="27px" Width="207px"></asp:DropDownList>
            <asp:Button ID="btnConsultar" runat="server" Text="Realizar consulta" OnClick="btnConsultar_Click" Width="156px" />
        </div>
        <div>
            <h1>Su estado de cuenta:</h1>
            <div>
                <asp:GridView ID="Cuentas" runat="server" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="IDValorDocIdentidad" HeaderText ="Documento de identidad" />
                        <asp:BoundField DataField="IDTCuenta" HeaderText ="Tipo de Cuenta" />
                        <asp:BoundField DataField="NumeroCuenta" HeaderText ="Número de Cuenta" />
                        <asp:BoundField DataField="FechaCreacion" HeaderText ="Fecha de Creación" />
                        <asp:BoundField DataField="Saldo" HeaderText ="Saldo" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
