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
            <asp:DropDownList ID="ddnumCuenta" runat="server" Height="27px" Width="207px"></asp:DropDownList>
            <asp:Button ID="btnConsultar" runat="server" Text="Realizar consulta" OnClick="btnConsultar_Click" Width="156px" />
        </div>
        <div>
            <h1>Su estado de cuenta:</h1>
            <div>
                <asp:GridView ID="EstadoCuenta" runat="server" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Fecha" HeaderText ="Fecha" />
                        <asp:BoundField DataField="SaldoMinimo" HeaderText ="Saldo Minimo" />
                        <asp:BoundField DataField="SaldoInicio" HeaderText ="Saldo Inicial" />
                        <asp:BoundField DataField="SaldoFinal" HeaderText ="Saldo Final" />
                        <asp:BoundField DataField="CantOperacionesATM" HeaderText ="OperacionesATM" />
                        <asp:BoundField DataField="CantOperacionesCajeroHumano" HeaderText ="Operaciones Cajero Humano" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
