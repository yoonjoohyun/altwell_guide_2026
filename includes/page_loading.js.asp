<script>
var PageLoading = (function(){
  var el, done = false, shownAt = 0;
  var MIN_MS = 420;
  var MAX_MS = 14000;

  function init(){
    el = document.getElementById('page-loading');
    shownAt = Date.now();
  }

  function hide(){
    if(done || !el) return;
    done = true;
    try{ sessionStorage.removeItem('guideEntryLoading'); }catch(e){}
    el.setAttribute('aria-busy', 'false');
    var wait = Math.max(0, MIN_MS - (Date.now() - shownAt));
    setTimeout(function(){
      el.classList.add('is-out');
      setTimeout(function(){
        if(el && el.parentNode) el.parentNode.removeChild(el);
      }, 380);
    }, wait);
  }

  function ready(){
    if(!el) init();
    if(!el) return;
    var finished = false;
    function finish(){
      if(finished) return;
      finished = true;
      hide();
    }
    if(document.readyState === 'complete') finish();
    else window.addEventListener('load', finish, {once:true});
    setTimeout(finish, MAX_MS);
  }

  if(document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', init);
  }else{
    init();
  }

  return { hide: hide, ready: ready };
})();
</script>
