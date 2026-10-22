<%
' include 전 설정: ListSectionActive = "guide" | "sim"
If IsEmpty(ListSectionActive) Then ListSectionActive = ""
ListSectionActive = LCase(Trim(CStr(ListSectionActive)))
%>
<nav class="lp-section-tabs" aria-label="콘텐츠 구분">
  <a class="lp-st<% If ListSectionActive = "guide" Then %> on<% End If %>" href="<%=GuideAppRoot()%>/guide.asp"<% If ListSectionActive = "guide" Then %> aria-current="page"<% End If %>>가이드 영상</a>
  <a class="lp-st<% If ListSectionActive = "sim" Then %> on<% End If %>" href="<%=GuideAppRoot()%>/sim.asp"<% If ListSectionActive = "sim" Then %> aria-current="page"<% End If %>>실습 콘텐츠</a>
</nav>
