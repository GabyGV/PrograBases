<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Segunda.aspx.cs" Inherits="WebPrograBases.Segunda" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cuenta</title>
    <style>
        body{
            background-color:#B9BFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Bienvenido(a)</h1>
            <asp:Label ID="lblUserDetails" runat="server" Text=""></asp:Label>
        <br />
        </div>
        <div>
            <p>
                Haga click sobre la operación que desea realizar
            </p>
            <tr>
                <td></td>
                <td>
                <asp:Button ID="btnEstadosCuenta" runat="server" Text=" Ver estados de cuenta" OnClick="btnEstadosCuenta_Click" />
                <asp:Button ID="btnBeneficiarios" runat="server" Text="Consultar beneficiarios" OnClick="btnBeneficiarios_Click" /> </td>
            </tr>
        </div>
    </form>
</body>
</html>
