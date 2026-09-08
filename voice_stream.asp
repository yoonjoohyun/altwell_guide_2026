<%@ Language=VBScript CodePage=65001 %>
<%
Option Explicit
Response.Buffer = True

Dim seriesId, sceneNum, filePath, fso, stream, ext, contentType
Dim allowedSeries, i, ok

seriesId = Trim(Request("series"))
sceneNum = Trim(Request("scene"))

If seriesId = "" Or sceneNum = "" Then
  Response.Status = "404 Not Found"
  Response.End
End If

If Not RegExpTest("^[a-zA-Z0-9_]+$", seriesId) Then
  Response.Status = "404 Not Found"
  Response.End
End If

If Not RegExpTest("^[0-9]{2}$", sceneNum) Then
  Response.Status = "404 Not Found"
  Response.End
End If

allowedSeries = Array("guide01", "03_sep_growth")
ok = False
For i = 0 To UBound(allowedSeries)
  If LCase(seriesId) = LCase(allowedSeries(i)) Then
    ok = True
    Exit For
  End If
Next
If Not ok Then
  Response.Status = "404 Not Found"
  Response.End
End If

Set fso = Server.CreateObject("Scripting.FileSystemObject")

If LCase(seriesId) = "guide01" Then
  filePath = Server.MapPath("voice/guide_season01/guide01/guide01_scene_" & sceneNum & ".mp3")
Else
  filePath = Server.MapPath("voice/" & seriesId & "/scene" & sceneNum & ".mp4")
End If

If Not fso.FileExists(filePath) Then
  Response.Status = "404 Not Found"
  Response.End
End If

ext = LCase(fso.GetExtensionName(filePath))
If ext = "mp4" Or ext = "m4a" Then
  contentType = "audio/mp4"
ElseIf ext = "mp3" Then
  contentType = "audio/mpeg"
Else
  Response.Status = "404 Not Found"
  Response.End
End If

Response.ContentType = contentType
Response.AddHeader "Cache-Control", "public, max-age=86400"
Response.AddHeader "Accept-Ranges", "bytes"

Set stream = Server.CreateObject("ADODB.Stream")
stream.Type = 1
stream.Open
stream.LoadFromFile filePath
Response.BinaryWrite stream.Read()
stream.Close
Set stream = Nothing
Set fso = Nothing
Response.End

Function RegExpTest(pattern, value)
  Dim re
  Set re = New RegExp
  re.Pattern = pattern
  re.IgnoreCase = True
  RegExpTest = re.Test(value)
End Function
%>
