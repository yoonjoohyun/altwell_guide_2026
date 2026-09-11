<%@ Language=VBScript CodePage=65001 %>
<%
Option Explicit
Response.Buffer = True

Dim seriesId, sceneNum, partId, filePath, fso, stream, ext, contentType
Dim allowedSeries, i, ok, baseName

seriesId = Trim(Request("series"))
sceneNum = Trim(Request("scene"))
partId = LCase(Trim(Request("part")))

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
  filePath = FindGuide01Voice(fso, sceneNum, partId)
Else
  filePath = FindVoiceFile(fso, Server.MapPath("voice/" & seriesId & "/scene" & sceneNum))
End If

If filePath = "" Then
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

Function FindVoiceFile(fso, baseNoExt)
  Dim exts, j, candidate
  exts = Array(".mp4", ".mp3", ".m4a")
  FindVoiceFile = ""
  For j = 0 To UBound(exts)
    candidate = baseNoExt & exts(j)
    If fso.FileExists(candidate) Then
      FindVoiceFile = candidate
      Exit Function
    End If
  Next
End Function

Function FindGuide01Voice(fso, sceneNum, partId)
  Dim roots, names, r, n, basePath, found
  roots = Array( _
    "voice/guide_season01/guide01/", _
    "voice/guide01/" _
  )

  If partId = "title" Then
    names = Array( _
      "guide01_scene_" & sceneNum & "_title", _
      "guide01_scene_" & sceneNum & "_title(1)" _
    )
  Else
    ' part=main 또는 part 생략 → guide01_scene_NN.mp4
    names = Array( _
      "guide01_scene_" & sceneNum, _
      "guide01_scene_" & sceneNum & "(2)", _
      "scene" & sceneNum _
    )
  End If

  FindGuide01Voice = ""
  For r = 0 To UBound(roots)
    For n = 0 To UBound(names)
      basePath = Server.MapPath(roots(r) & names(n))
      found = FindVoiceFile(fso, basePath)
      If found <> "" Then
        FindGuide01Voice = found
        Exit Function
      End If
    Next
  Next
End Function
%>
