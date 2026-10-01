<script>
/* guide01 Scene 07 — 요약 스택. 씬2·4·5 에셋은 복제만 하고 원본은 바꾸지 않는다 */
var Scene07Layout = (function(){
  var _resizeBound = false;
  var _pending = false;
  var _ctx = null;

  function setOffset(wrap, x, y){
    if(!wrap) return;
    wrap.style.setProperty('--offset-x', (Math.round(x * 10) / 10) + 'px');
    wrap.style.setProperty('--offset-y', (Math.round(y * 10) / 10) + 'px');
  }

  function cloneFromTemplate(templateId){
    var host = document.querySelector('#guide01-templates [data-template="' + templateId + '"]');
    if(!host || !host.firstElementChild) return null;
    return host.firstElementChild.cloneNode(true);
  }

  function createGroup(canvas, zone){
    var group = document.createElement('div');
    var inner = document.createElement('div');
    group.id = 's07-stack-group';
    group.className = 'g01-zone-wrap scene07-stack-group is-hidden';
    Guide01.placeAtZone(group, zone);
    inner.className = 'scene07-group-inner';
    group.appendChild(inner);
    group._inner = inner;
    canvas.appendChild(group);
    return group;
  }

  function createRow(id){
    var row = document.createElement('div');
    row.id = id;
    row.className = 'scene07-group-child s07-hrow s07-layout-instant is-hidden';
    return row;
  }

  function parkSlot(wrap){
    if(!wrap) return wrap;
    wrap.classList.remove('lo-zone-place');
    wrap.classList.add('s07-slot');
    wrap.removeAttribute('data-zone');
    wrap.style.removeProperty('--zone-row');
    wrap.style.removeProperty('--zone-col');
    wrap.style.left = 'auto';
    wrap.style.top = 'auto';
    wrap.style.transform = 'none';
    return wrap;
  }

  function mountFloat(node, id, scale){
    var wrap = document.createElement('div');
    var inner = document.createElement('div');
    var s = scale != null ? scale : 1;
    wrap.id = id;
    wrap.className = 's07-slot g01-float-host is-hidden';
    inner.className = 'g01-float-inner';
    inner.style.setProperty('--g01-base-scale', String(s));
    inner.style.transform = 'scale(' + s + ')';
    if(node){
      node.classList.add('guide01-asset');
      inner.appendChild(node);
    }
    wrap.appendChild(inner);
    wrap._float = inner;
    return wrap;
  }

  function mountDiscount(){
    var card = cloneFromTemplate('autoship_discount_summary_card');
    var rows;
    var copy = ['-25% 회원가', '+추가 20% 할인', '=오토십 할인가'];
    var i;
    if(!card) return null;
    card.style.setProperty('--size', '176px');
    card.setAttribute('aria-label', '오토십 할인가');
    rows = card.querySelectorAll('.ads_row');
    for(i = 0; i < rows.length; i++){
      if(i < 3){
        rows[i].textContent = copy[i];
        rows[i].classList.add('is-visible');
      }else{
        rows[i].classList.add('s07-ads-skip');
        rows[i].classList.remove('is-visible');
      }
    }
    return mountFloat(card, 's07-discount', 1);
  }

  function mountCalendar(){
    var card = cloneFromTemplate('calendar_month_card');
    if(!card) return null;
    card.classList.add('is_active');
    return mountFloat(card, 's07-calendar', 1);
  }

  function mountDelivery(){
    var box = cloneFromTemplate('delivery_batch_box');
    if(!box) return null;
    box.style.setProperty('--size', '168px');
    box.classList.add('s07-delivery');
    return mountFloat(box, 's07-delivery', 1);
  }

  function mountEpPanel(){
    var panel = document.createElement('div');
    var coinRow = document.createElement('div');
    var caption = document.createElement('div');
    var i;
    var coin;
    var token;
    var inner;
    panel.className = 's07-ep-panel';
    panel.setAttribute('role', 'img');
    panel.setAttribute('aria-label', 'EP 매월 1개월분씩 총 3회');
    coinRow.className = 's07-ep-coins';
    for(i = 0; i < 3; i++){
      token = cloneFromTemplate('point_token_icon');
      if(!token) continue;
      inner = token.querySelector('.point_token_inner');
      if(inner) inner.textContent = 'EP';
      token.classList.add('s07-ep-coin');
      token.setAttribute('aria-label', 'E.P');
      coin = document.createElement('div');
      coin.className = 's07-ep-coin-wrap';
      coin.appendChild(token);
      coinRow.appendChild(coin);
    }
    caption.className = 's07-ep-caption';
    caption.textContent = '매월 1개월분씩 총 3회';
    panel.appendChild(coinRow);
    panel.appendChild(caption);
    return mountFloat(panel, 's07-ep', 1);
  }

  function mountRecommend(){
    var badge = cloneFromTemplate('recommend_bonus_icon_ex');
    var line1;
    var line2;
    if(!badge) return null;
    line1 = badge.querySelector('.recommend_bonus_text_1');
    line2 = badge.querySelector('.recommend_bonus_text_2');
    if(line1) line1.textContent = '추천 포인트';
    if(line2) line2.textContent = '매월 발생';
    badge.setAttribute('aria-label', '추천 포인트');
    return mountFloat(badge, 's07-recommend', 1);
  }

  function mountCashback(canvas){
    var wrap = Guide01.addZonedBadge(canvas, 'cashback_icon', 's07-cashback', 'd4', { scale: 1 });
    return parkSlot(wrap);
  }

  function mountBase(){
    var badge = cloneFromTemplate('guide_info_badge');
    var labelEl;
    var textEl;
    if(!badge) return null;
    labelEl = badge.querySelector('.guide_info_badge_label');
    textEl = badge.querySelector('.guide_info_badge_text');
    if(labelEl) labelEl.textContent = 'B';
    if(textEl) textEl.textContent = 'BASE사업자 조건 달성';
    badge.classList.add('s07-base-badge');
    badge.setAttribute('aria-label', 'BASE사업자 조건 달성');
    return mountFloat(badge, 's07-base', 1);
  }

  function mountSummary(){
    var panel = document.createElement('div');
    var lines = ['꾸준한 제품 경험', '적극적인 추천 활동', '비즈니스 기반'];
    var nodes = [];
    var i;
    var line;
    panel.className = 's07-summary';
    panel.setAttribute('role', 'img');
    panel.setAttribute('aria-label', '제품 경험, 추천 활동, 비즈니스 기반');
    for(i = 0; i < lines.length; i++){
      line = document.createElement('div');
      line.className = 's07-summary-line is-hidden';
      line.textContent = '· ' + lines[i];
      panel.appendChild(line);
      nodes.push(line);
    }
    return { wrap: mountFloat(panel, 's07-summary', 1), lines: nodes };
  }

  function mountOutro(canvas){
    return GuideClosePanel.mount(canvas, {
      id: 's07-outro',
      className: 's07-outro',
      cardClass: 's07-outro-card',
      titleClass: 's07-outro-title',
      buttonClass: 's07-outro-btn',
      title: '오토십 알아보기',
      zone: (Scene07Config.layout && Scene07Config.layout.anchorZone) || 'd4',
      place: Guide01.placeAtZone,
      hidden: true,
      titleOpen: true,
      simulatorHref: (window.GUIDE_ROOT || '') + (Scene07Config.links.simulator || '/sim.asp')
    });
  }

  function visibleChildren(inner){
    var nodes = inner ? inner.querySelectorAll('.scene07-group-child') : [];
    var list = [];
    var i;
    for(i = 0; i < nodes.length; i++){
      if(!nodes[i].classList.contains('is-hidden')) list.push(nodes[i]);
    }
    return list;
  }

  function applyLayout(){
    var inner = _ctx && _ctx.group && _ctx.group._inner;
    var canvas = _ctx && _ctx.canvas;
    var children;
    var gap;
    var heights = [];
    var widths = [];
    var totalH = 0;
    var maxW = 0;
    var cursor;
    var i;
    var h;
    var fit = 1;
    var minFit = (Scene07Config.layout && Scene07Config.layout.minFit) || 0.42;
    if(!inner) return;
    children = visibleChildren(inner);
    gap = (Scene07Config.layout.gaps && Scene07Config.layout.gaps.stackGap) || 14;
    for(i = 0; i < children.length; i++){
      h = children[i].offsetHeight || 0;
      heights.push(h);
      widths.push(children[i].offsetWidth || 0);
      totalH += h;
      if(widths[i] > maxW) maxW = widths[i];
    }
    if(children.length > 1) totalH += gap * (children.length - 1);
    cursor = -totalH / 2;
    for(i = 0; i < children.length; i++){
      setOffset(children[i], 0, cursor + heights[i] / 2);
      cursor += heights[i] + gap;
    }
    if(canvas && totalH > 0){
      fit = Math.min(
        1,
        (canvas.clientHeight - 16) / totalH,
        (canvas.clientWidth - 16) / Math.max(maxW, 1)
      );
      if(fit < minFit) fit = minFit;
    }
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function scheduleLayout(immediate){
    if(immediate){
      applyLayout();
      return;
    }
    if(_pending) return;
    _pending = true;
    requestAnimationFrame(function(){
      _pending = false;
      applyLayout();
      var inner = _ctx && _ctx.group && _ctx.group._inner;
      if(!inner) return;
      requestAnimationFrame(function(){
        var nodes = inner.querySelectorAll('.s07-layout-instant');
        var i;
        for(i = 0; i < nodes.length; i++) nodes[i].classList.remove('s07-layout-instant');
      });
    });
  }

  function bindResize(ctx){
    _ctx = ctx;
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', function(){ scheduleLayout(false); });
  }

  function unbindResize(){
    _resizeBound = false;
    _ctx = null;
  }

  return {
    cloneFromTemplate: cloneFromTemplate,
    createGroup: createGroup,
    createRow: createRow,
    parkSlot: parkSlot,
    mountDiscount: mountDiscount,
    mountCalendar: mountCalendar,
    mountDelivery: mountDelivery,
    mountEpPanel: mountEpPanel,
    mountRecommend: mountRecommend,
    mountCashback: mountCashback,
    mountBase: mountBase,
    mountSummary: mountSummary,
    mountOutro: mountOutro,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize
  };
})();

function setupScene07Assets(canvas){
  var zone = (Scene07Config.layout && Scene07Config.layout.anchorZone) || 'd4';
  var group = Scene07Layout.createGroup(canvas, zone);
  var inner = group._inner;
  var badgeRow = Scene07Layout.createRow('s07-row-badge');
  var calRow = Scene07Layout.createRow('s07-row-calendar');
  var shipRow = Scene07Layout.createRow('s07-row-ship');
  var benefitRow = Scene07Layout.createRow('s07-row-benefit');
  var baseRow = Scene07Layout.createRow('s07-row-base');
  var summaryRow = Scene07Layout.createRow('s07-row-summary');
  var autoship = Scene07Layout.parkSlot(
    Guide01.addZonedBadge(canvas, 'autoship_icon', 's07-autoship', zone, { scale: 1 })
  );
  var calendar = Scene07Layout.mountCalendar();
  var discount = Scene07Layout.mountDiscount();
  var delivery = Scene07Layout.mountDelivery();
  var ep = Scene07Layout.mountEpPanel();
  var recommend = Scene07Layout.mountRecommend();
  var cashback = Scene07Layout.mountCashback(canvas);
  var base = Scene07Layout.mountBase();
  var summary = Scene07Layout.mountSummary();
  var outro = Scene07Layout.mountOutro(canvas);

  if(autoship) badgeRow.appendChild(autoship);
  if(calendar) calRow.appendChild(calendar);
  if(discount) calRow.appendChild(discount);
  if(delivery) shipRow.appendChild(delivery);
  if(ep) shipRow.appendChild(ep);
  if(recommend) benefitRow.appendChild(recommend);
  if(cashback) benefitRow.appendChild(cashback);
  if(base) baseRow.appendChild(base);
  if(summary.wrap) summaryRow.appendChild(summary.wrap);

  inner.appendChild(badgeRow);
  inner.appendChild(calRow);
  inner.appendChild(shipRow);
  inner.appendChild(benefitRow);
  inner.appendChild(baseRow);
  inner.appendChild(summaryRow);

  Scene07Layout.bindResize({ group: group, canvas: canvas });
  requestAnimationFrame(function(){
    var nodes = inner.querySelectorAll('.s07-layout-instant');
    var i;
    for(i = 0; i < nodes.length; i++) nodes[i].classList.remove('s07-layout-instant');
  });

  return {
    group: group,
    badgeRow: badgeRow,
    calRow: calRow,
    shipRow: shipRow,
    benefitRow: benefitRow,
    baseRow: baseRow,
    summaryRow: summaryRow,
    autoship: autoship,
    calendar: calendar,
    discount: discount,
    delivery: delivery,
    ep: ep,
    recommend: recommend,
    cashback: cashback,
    base: base,
    summary: summary.wrap,
    summaryLines: summary.lines,
    outro: outro.wrap,
    simButton: outro.sim,
    replayButton: outro.replay,
    simSlot: outro.simSlot,
    replaySlot: outro.replaySlot
  };
}
</script>
