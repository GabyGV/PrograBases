<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsultaBeneficiarios.aspx.cs" Inherits="WebPrograBases.ConsultaBeneficiarios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta por Beneficiarios</title>
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
                <small class="text-muted">En esta consulta se muestran los beneficiarios, la cantidad de dinero que recibirán,
                    la cuenta que aporta la mayor cantidad y la cantidad de cuentas de las que recibirá dinero.</small>
            </h3>
        </div>
        <div>
            <h1>Resultado:</h1>
            <div>
                <asp:GridView ID="ConsultaPorBeneficiario" runat="server" AutoGenerateColumns="false" >
                    <Columns>
                        <asp:BoundField DataField="NumDocIdentidad" HeaderText ="Número de documento de identidad" />
                        <asp:BoundField DataField="CantDinero" HeaderText ="Cantidad de dinero a recibir" />
                        <asp:BoundField DataField="NumCuentaMayor" HeaderText ="Número de cuenta con mayor aporte" />
                        <asp:BoundField DataField="CantCuentas" HeaderText ="Cantidad de cuentas" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkSelect" Text="Más detalles" runat="server" CommandArgument='<%# Eval("Fecha") %>' OnClick="lnkSelect_Click"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
