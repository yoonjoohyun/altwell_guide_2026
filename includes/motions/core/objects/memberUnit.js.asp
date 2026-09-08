<script>
/* Member Unit — Object Library DOM 팩토리 (씬별 옵션으로 커스텀)
   ※ images.asp는 진입 ASP에서 선행 include (중복 include 금지) */
var MemberUnit = (function(){
  var IMGS = {
    member: '<%=memberImg%>',
    people: '<%=peopleImg%>',
    basebiz: '<%=basebizImg%>',
    autoship: '<%=autoshipImg%>',
    rankD: '<%=lev01Img%>'
  };

  function buildVisual(suffix, opts){
    opts = opts || {};
    var baseBadgeHtml = opts.includeBaseBadge ? (
      '<div class="qualification-badge base-business is-hidden" id="base-business-badge-' + suffix + '">' +
        '<img src="' + IMGS.basebiz + '" alt="BASE사업자 자격"/>' +
      '</div>'
    ) : '';
    var sepHtml = opts.includeSep ? (
      '<div class="member-metrics is-hidden" id="member-metrics-' + suffix + '">' +
        '<div class="metric-badge sep-badge is-hidden" id="sep-badge-' + suffix + '" data-status="incomplete">' +
          '<span class="sep-badge-text">S.E.P<br>30만↑</span>' +
        '</div>' +
      '</div>'
    ) : '';

    return (
      '<div class="member-visual" id="member-visual-' + suffix + '">' +
        '<img class="member-image" id="member-image-' + suffix + '" src="' + opts.imageSrc + '" alt="' + (opts.imageAlt || '') + '"/>' +
        '<div class="member-emblems" id="member-emblems-' + suffix + '">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem is-hidden" id="autoship-emblem-' + suffix + '">' +
              '<img src="' + IMGS.autoship + '" alt="오토십 이용"/>' +
            '</div>' +
            baseBadgeHtml +
            '<div class="rank-medal is-hidden" id="rank-medal-' + suffix + '">' +
              '<img src="' + IMGS.rankD + '" alt="D 지위"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
        sepHtml +
      '</div>'
    );
  }

  function create(config){
    config = config || {};
    var suffix = config.suffix || 'main';
    var el = document.createElement('div');
    el.className = 'member-unit' +
      (config.isChild ? ' member-child' : '') +
      (config.hidden !== false ? ' is-hidden' : '');
    el.id = config.id || ('member-unit-' + suffix);
    el.innerHTML = buildVisual(suffix, config);
    return el;
  }

  function mountMain(canvas, overrides){
    var opts = MotionComponent.merge({
      suffix: 'main',
      isChild: false,
      includeBaseBadge: true,
      imageSrc: IMGS.people,
      imageAlt: '일반 캐릭터'
    }, overrides || {});
    var unit = create(opts);
    canvas.appendChild(unit);
    return unit;
  }

  function mountChild(canvas, side, overrides){
    var suffix = side === 'left' ? 'left' : 'right';
    var opts = MotionComponent.merge({
      suffix: suffix,
      isChild: true,
      includeBaseBadge: false,
      imageSrc: IMGS.member,
      imageAlt: '멤버'
    }, overrides || {});
    var unit = create(opts);
    canvas.appendChild(unit);
    return unit;
  }

  return {
    IMGS: IMGS,
    create: create,
    mountMain: mountMain,
    mountChild: mountChild
  };
})();
</script>
