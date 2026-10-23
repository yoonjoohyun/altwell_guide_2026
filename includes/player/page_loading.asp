<style>
@keyframes page-loading-spin{to{transform:rotate(360deg)}}
.page-loading{
  position:fixed;inset:0;z-index:9999;
  display:flex;align-items:center;justify-content:center;
  background:#0a0a0a;
}
.page-loading__box{display:flex;flex-direction:column;align-items:center;gap:27px}
.page-loading__spinner{
  width:66px;height:66px;border-radius:50%;box-sizing:border-box;
  border:6.75px solid rgba(255,255,255,.2);
  border-top-color:#fff;border-right-color:#fff;
  animation:page-loading-spin .7s linear infinite;
}
.page-loading__text{font-size:22.5px;font-weight:700;letter-spacing:-.02em;color:#fff;margin:0}
</style>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/page_loading.css?v=20261023load7"/>
<div id="page-loading" class="page-loading" role="status" aria-live="polite" aria-busy="true">
  <div class="page-loading__box">
    <div class="page-loading__spinner" aria-hidden="true"></div>
    <p class="page-loading__text">로딩중입니다...</p>
  </div>
</div>
