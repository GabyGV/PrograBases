<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Configuracion.aspx.cs" Inherits="WebPrograBases.Configuracion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Configuración</title>
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
            <asp:Button ID="btnEliminar" runat="server" Text="Eliminar cuenta" Width="156px" CausesValidation="False" OnClick="btnEliminar_Click" />
        </div>
    </form>
</body>
</html>
