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
            <asp:DropDownList ID="ddnumCuenta" runat="server" Height="27px" Width="207px" ></asp:DropDownList>
            <asp:Button ID="btnConsultar" runat="server" Text="Realizar consulta" Width="156px" CausesValidation="False" OnClick="btnConsultar_Click"/>
            <asp:Button ID="btnEliminar" runat="server" Text="Eliminar cuenta" OnClick="btnEliminar_Click" />
        </div>
        <div>
            <h1>Su estado de cuenta:</h1>
            <div>
                <asp:GridView ID="EstadoCuenta" runat="server" AutoGenerateColumns="false" >
                    <Columns>
                        <asp:BoundField DataField="Fecha" HeaderText ="Fecha" />
                        <asp:BoundField DataField="SaldoMinimo" HeaderText ="Saldo Minimo" />
                        <asp:BoundField DataField="SaldoInicio" HeaderText ="Saldo Inicial" />
                        <asp:BoundField DataField="SaldoFinal" HeaderText ="Saldo Final" />
                        <asp:BoundField DataField="CantOperacionesATM" HeaderText ="OperacionesATM" />
                        <asp:BoundField DataField="CantOperacionesCajeroHumano" HeaderText ="Operaciones Cajero Humano" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkSelect" Text="Select" runat="server" CommandArgument='<%# Eval("Fecha") %>' OnClick="lnkSelect_Click"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div>
            <h1></h1>
            <asp:Label ID="lblMov" runat="server" Text="Detalles de Movimientos:"></asp:Label>
            <div>
                <asp:GridView ID="tblMovimientos" runat="server" AutoGenerateColumns="false" >
                    <Columns>
                        <asp:BoundField DataField="Fecha" HeaderText ="Fecha" />
                        <asp:BoundField DataField="Cambio" HeaderText ="Descripcion del cambio" />
                        <asp:BoundField DataField="Compra" HeaderText ="Tipo de Cambio Compra" />
                        <asp:BoundField DataField="Venta" HeaderText ="Tipo de Cambio Venta" />
                        <asp:BoundField DataField="MontoMovimiento" HeaderText ="Monto en la Moneda del Movimiento" />
                        <asp:BoundField DataField="MontoCuenta" HeaderText ="Monto afectado de la cuenta" />
                        <asp:BoundField DataField="Descripcion" HeaderText ="Descripcion" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
