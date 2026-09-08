<script>
/* Badge Objects — 자격·배지 DOM 팩토리
   ※ images.asp는 진입 ASP에서 선행 include (중복 include 금지) */
var BadgeObject = (function(){
  var IMGS = { basebiz: '<%=basebizImg%>' };

  function createBaseBadge(options){
    options = options || {};
    var el = document.createElement('div');
    el.className = 'qualification-badge base-business scene-canvas-badge' +
      (options.hidden !== false ? ' is-hidden' : '');
    el.id = options.id || 'base-badge';
    el.innerHTML = '<img src="' + IMGS.basebiz + '" alt="BASE사업자 자격"/>';
    return el;
  }

  return { createBaseBadge: createBaseBadge, IMGS: IMGS };
})();
</script>
