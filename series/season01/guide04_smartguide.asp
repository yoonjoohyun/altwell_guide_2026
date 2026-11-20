<%@ Language=VBScript CodePage=65001 %>
<%
Dim q
q = Request.ServerVariables("QUERY_STRING")
If Len(q) > 0 Then q = "?" & q
Response.Redirect "../../guide04_smartguide.asp" & q
%>
