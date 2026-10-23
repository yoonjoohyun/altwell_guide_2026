<script>
/* guide.asp · sim.asp — 진입 전 로딩 오버레이 */
var ListEntryNav = (function(){
  var KEY = 'guideEntryLoading';

  function innerHtml(){
    return '<div class="page-loading__box">' +
      '<div class="page-loading__spinner" aria-hidden="true"></div>' +
      '<p class="page-loading__text">로딩중입니다...</p></div>';
  }

  function clearListLoading(){
    var el = document.getElementById('list-entry-loading');
    if(el && el.parentNode) el.parentNode.removeChild(el);
    try{ sessionStorage.removeItem(KEY); }catch(e){}
  }

  function show(){
    try{ sessionStorage.setItem(KEY, '1'); }catch(e){}
    if(document.getElementById('list-entry-loading')) return;
    var el = document.createElement('div');
    el.id = 'list-entry-loading';
    el.className = 'page-loading';
    el.setAttribute('role', 'status');
    el.setAttribute('aria-live', 'polite');
    el.setAttribute('aria-busy', 'true');
    el.innerHTML = innerHtml();
    document.body.appendChild(el);
  }

  function go(href){
    if(!href) return;
    show();
    requestAnimationFrame(function(){
      requestAnimationFrame(function(){ location.href = href; });
    });
  }

  document.addEventListener('click', function(ev){
    var card = ev.target.closest('.entry-nav-card');
    if(!card || card.classList.contains('disabled')) return;
    if(card.style.display === 'none') return;
    var href = card.getAttribute('data-entry-href');
    if(!href) return;
    ev.preventDefault();
    ev.stopPropagation();
    go(href);
  }, true);

  /* 뒤로가기(bfcache) 시 남은 오버레이 제거 */
  window.addEventListener('pagehide', function(ev){
    if(ev.persisted) clearListLoading();
  });
  window.addEventListener('pageshow', function(){
    clearListLoading();
  });

  return { go: go, show: show, clear: clearListLoading };
})();
</script>
