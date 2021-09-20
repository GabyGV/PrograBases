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
            <h1>Su estado de cuenta:</h1>
            <div>
                <asp:GridView ID="Cuentas" runat="server" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="NumCuenta" HeaderText ="Número de cuenta" />
                        <asp:BoundField DataField="Fecha" HeaderText ="Fecha de Creación" />
                        <asp:BoundField DataField="Saldo" HeaderText ="Saldo" />
                        <asp:BoundField DataField="DocIdent" HeaderText ="Documento de Identidad" />
                        <asp:BoundField DataField="TipoCuenta" HeaderText ="Tipo de Cuenta" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkSelect" Text="Select" runat="server" CommandArgument='<%# Eval("PhoneBookID") %>' OnClick="lnkSelect_Click"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
