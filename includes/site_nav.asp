<%
' 공통 헤더 — include 전에 설정:
'   NavSubTitle   (String) 서브 타이틀, 없으면 ""
'   NavShowMypage (Boolean) 마이페이지 버튼, 기본 False
If IsEmpty(NavSubTitle) Then NavSubTitle = ""
If IsEmpty(NavShowMypage) Then NavShowMypage = False
NavSubTitle = Trim(CStr(NavSubTitle))
%>
<nav id="nav">
  <button type="button" class="nav-logo nav-logo--img" onclick="location.href='<%=GuideAppRoot()%>/index.asp'" aria-label="홈으로 ALTWELL SMART GUIDE">
    <img class="nav-logo-mark" src="<%=GuideAppRoot()%>/images/logo_altwell.png" alt="ALTWELL" width="120" height="16"/>
    <span class="nav-logo-divider" aria-hidden="true">｜</span>
    <span class="nav-logo-text">SMART GUIDE</span>
  </button>
  <span id="nav-page-title"<% If Len(NavSubTitle) = 0 Then %> class="is-empty"<% End If %>><%=Server.HTMLEncode(NavSubTitle)%></span>
  <div class="nav-spacer"></div>
  <% If NavShowMypage Then %>
  <button type="button" class="nav-mypage" onclick="location.href='<%=GuideAppRoot()%>/mypage.asp'" style="display:block;">마이페이지</button>
  <% End If %>
</nav>
