<%
' 공통 헤더 — include 전에 설정:
'   NavSubTitle   (String) 서브 타이틀, 없으면 ""
'   NavShowMypage (Boolean) 마이페이지 버튼, 기본 False
If IsEmpty(NavSubTitle) Then NavSubTitle = ""
If IsEmpty(NavShowMypage) Then NavShowMypage = False
NavSubTitle = Trim(CStr(NavSubTitle))
%>
<nav id="nav">
  <div class="nav-logo nav-logo--img">
    <a class="nav-logo-mark-link" href="/" aria-label="ALTWELL 홈">
      <img class="nav-logo-mark" src="<%=GuideAppRoot()%>/images/logo_altwell.png" alt="ALTWELL" width="120" height="16"/>
    </a>
    <span class="nav-logo-divider" aria-hidden="true">｜</span>
    <button type="button" class="nav-logo-text" onclick="location.href='<%=GuideAppRoot()%>/index.asp'" aria-label="SMART GUIDE 홈">SMART GUIDE</button>
  </div>
  <span id="nav-page-title"<% If Len(NavSubTitle) = 0 Then %> class="is-empty"<% End If %>><%=Server.HTMLEncode(NavSubTitle)%></span>
  <div class="nav-spacer"></div>
  <% If NavShowMypage Then %>
  <button type="button" class="nav-mypage" onclick="location.href='<%=GuideAppRoot()%>/mypage.asp'" style="display:none;">마이페이지</button>
  <% End If %>
</nav>
