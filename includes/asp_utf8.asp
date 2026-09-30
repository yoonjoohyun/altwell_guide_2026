<%
' guide_page ? UTF-8 response (include after @CODEPAGE=65001 on entry ASP)
Response.CodePage = 65001
Response.Charset = "utf-8"

' 앱이 사이트 루트(/)가 아니라 하위 폴더에 있어도 브라우저 경로가 맞게 한다.
' /series/... 페이지는 series 앞까지가 앱 루트, 그 외 페이지는 파일명만 뺀 폴더.
Function GuideAppRoot()
  Dim path, p, slash
  path = Request.ServerVariables("SCRIPT_NAME")
  p = InStr(1, LCase(path), "/series/", 1)
  If p > 1 Then
    GuideAppRoot = Left(path, p - 1)
  ElseIf p = 1 Then
    GuideAppRoot = ""
  Else
    slash = InStrRev(path, "/")
    If slash > 1 Then
      GuideAppRoot = Left(path, slash - 1)
    Else
      GuideAppRoot = ""
    End If
  End If
End Function
%>
