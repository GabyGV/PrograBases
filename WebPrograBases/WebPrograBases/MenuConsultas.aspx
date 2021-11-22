<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuConsultas.aspx.cs" Inherits="WebPrograBases.MenuConsultas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Menú de consultas</title>
    <style>
        body{
            background-color:#B9BFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="margin:auto;border:5px solid white">
        <tr>
            <td>
                <asp:Label ID="lblTitulo" runat="server" Text="Consultas para el administrador" Font-Bold="true"></asp:Label></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="1) Para cuentas objetivo con saldo negativo"></asp:Label></td>
            <td>
                <asp:Button ID="btnConsultaNegativo" runat="server" Text="Consultar" OnClick="btnConsultaNegativo_Click" /></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="2) Para cuentas con multas"></asp:Label></td>
            <td>
                <asp:Button ID="btnConsultaMulta" runat="server" Text="Consultar" OnClick="btnConsultaMulta_Click" /></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="3) Para lista de beneficiarios"></asp:Label></td>
            <td>
                <asp:Button ID="btnConsultarBeneficiarios" runat="server" Text="Consultar" OnClick="btnConsultarBeneficiarios_Click" /></td>
        </tr>
    </table>
            
        </div>
    </form>
</body>
</html>
