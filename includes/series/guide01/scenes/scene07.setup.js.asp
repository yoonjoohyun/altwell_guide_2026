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
    var kept = [];
    var i;
    if(!card) return null;
    card.style.setProperty('--size', '200px');
    card.setAttribute('aria-label', '오토십 할인가');
    rows = card.querySelectorAll('.ads_row');
    for(i = 0; i < rows.length; i++){
      if(i < 3){
        rows[i].textContent = copy[i];
        rows[i].classList.remove('is-visible');
        kept.push(rows[i]);
      }else{
        rows[i].classList.add('s07-ads-skip');
        rows[i].classList.remove('is-visible');
      }
    }
    return { wrap: mountFloat(card, 's07-discount', 1), rows: kept };
  }

  function mountCalendar(){
    var card = cloneFromTemplate('calendar_month_card');
    if(!card) return null;
    card.classList.add('is_active');
    card.style.setProperty('--size', '96px');
    return mountFloat(card, 's07-calendar', 1);
  }

  function mountPayment(){
    var box = cloneFromTemplate('payment_batch_box');
    if(!box) return null;
    box.classList.add('s07-payment');
    return mountFloat(box, 's07-payment', 1);
  }

  function mountDeliveryProducts(box){
    var stack = box && box.querySelector('.s04-delivery-products');
    var track = stack && stack.querySelector('.s04-delivery-track');
    var products = [];
    var i;
    var node;
    var wrap;
    var floatInner;
    if(!stack || !track) return products;
    for(i = 0; i < 3; i++){
      node = cloneFromTemplate('product_swap_box');
      if(!node) continue;
      if(typeof scene04ConfigureProductBox === 'function') scene04ConfigureProductBox(node, 'A');
      wrap = document.createElement('div');
      wrap.className = 'g01-zone-wrap s04-delivery-product-wrap is-hidden';
      wrap.setAttribute('data-index', String(i));
      floatInner = document.createElement('div');
      floatInner.className = 'g01-float-inner';
      floatInner.style.setProperty('--g01-base-scale', '1');
      floatInner.style.transform = 'scale(1)';
      floatInner.appendChild(node);
      wrap.appendChild(floatInner);
      wrap._float = floatInner;
      track.appendChild(wrap);
      products.push(wrap);
    }
    return products;
  }

  function mountDelivery(){
    var box = cloneFromTemplate('delivery_batch_box');
    var wrap;
    if(!box) return null;
    box.classList.add('s07-delivery');
    wrap = mountFloat(box, 's07-delivery', 1);
    wrap._deliveryBox = box;
    wrap._deliveryProducts = mountDeliveryProducts(box);
    return wrap;
  }

  function mountBenefitPanel(){
    var panel = document.createElement('div');
    var cols = document.createElement('div');
    var epRow = document.createElement('div');
    var cbRow = document.createElement('div');
    var caption = document.createElement('div');
    var i;
    var token;
    var tokenInner;
    var cash;
    panel.className = 's07-benefit-panel';
    panel.setAttribute('role', 'group');
    panel.setAttribute('aria-label', 'E.P와 캐시백은 매월 1개월분씩 총 3회 발생');
    cols.className = 's07-coin-cols';
    epRow.className = 's07-ep-row is-hidden';
    cbRow.className = 's07-cb-row is-hidden';
    for(i = 0; i < 3; i++){
      token = cloneFromTemplate('point_token_icon');
      if(token){
        tokenInner = token.querySelector('.point_token_inner');
        if(tokenInner) tokenInner.textContent = 'E.P';
        token.classList.add('s07-ep-coin');
        token.style.setProperty('--size', '42px');
        token.setAttribute('aria-label', 'E.P');
        epRow.appendChild(token);
      }
      cash = cloneFromTemplate('cashback_icon');
      if(cash){
        cash.classList.add('s07-cashback', 'guide01-asset');
        cash.style.setProperty('--size', '32px');
        cbRow.appendChild(cash);
      }
    }
    caption.className = 's07-ep-caption is-hidden';
    caption.textContent = '매월 1개월분씩 총 3회 발생';
    cols.appendChild(epRow);
    cols.appendChild(cbRow);
    panel.appendChild(cols);
    panel.appendChild(caption);
    return {
      wrap: mountFloat(panel, 's07-benefit', 1),
      epRow: epRow,
      cbRow: cbRow,
      caption: caption
    };
  }

  function mountRecommend(){
    var badge = cloneFromTemplate('recommend_bonus_icon_ex');
    var textWrap;
    if(!badge) return null;
    textWrap = badge.querySelector('.recommend_bonus_ex_text');
    if(textWrap){
      textWrap.innerHTML = '<span class="recommend_bonus_text_1">추천포인트</span><br><span class="recommend_bonus_text_2">매월 1Point</span>';
    }
    badge.classList.add('s07-point-badge');
    badge.setAttribute('aria-label', '추천포인트 매월 1Point');
    return mountFloat(badge, 's07-recommend', 0.9);
  }

  function mountBase(){
    var badge = cloneFromTemplate('base_business_icon');
    var textEl;
    if(!badge) return null;
    textEl = badge.querySelector('.base_text');
    if(textEl) textEl.textContent = 'BASE 사업자 달성';
    badge.setAttribute('aria-label', 'BASE 사업자 달성');
    return mountFloat(badge, 's07-base', 1);
  }

  function mountFinale(){
    var panel = document.createElement('div');
    var lines = [
      { text: '- 꾸준한 제품 경험', tone: '' },
      { text: '- 적극적인 추천 활동', tone: '' },
      { text: '- 앨트웰 비즈니스의 기반', tone: '' },
      { text: '정기 구독 시스템', tone: 'is-accent' }
    ];
    var nodes = [];
    var i;
    var line;
    panel.className = 's07-finale';
    panel.setAttribute('role', 'img');
    panel.setAttribute('aria-label', '꾸준한 제품 경험, 적극적인 추천 활동, 앨트웰 비즈니스의 기반, 정기 구독 시스템');
    for(i = 0; i < lines.length; i++){
      line = document.createElement('div');
      line.className = 's07-finale-line is-hidden' + (lines[i].tone ? ' ' + lines[i].tone : '');
      line.textContent = lines[i].text;
      panel.appendChild(line);
      nodes.push(line);
    }
    return { wrap: mountFloat(panel, 's07-finale', 1), lines: nodes };
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
    var group = inner && inner.parentElement;
    var groupHidden = false;
    var prevOpacity = '';
    var children;
    var gap;
    var heights = [];
    var totalH = 0;
    var cursor;
    var i;
    var h;
    var shouldMeasure = !applyLayout._busy && canvas && inner && !inner._fillReady;
    if(!inner) return;
    if(shouldMeasure && group){
      groupHidden = group.classList.contains('is-hidden');
      prevOpacity = group.style.opacity;
      if(groupHidden){
        group.classList.remove('is-hidden');
        group.style.opacity = '0';
      }
    }
    children = visibleChildren(inner);
    gap = (Scene07Config.layout.gaps && Scene07Config.layout.gaps.stackGap) || 14;
    for(i = 0; i < children.length; i++){
      h = children[i].offsetHeight || 0;
      heights.push(h);
      totalH += h;
    }
    if(children.length > 1) totalH += gap * (children.length - 1);
    cursor = -totalH / 2;
    for(i = 0; i < children.length; i++){
      setOffset(children[i], 0, cursor + heights[i] / 2);
      cursor += heights[i] + gap;
    }
    if(shouldMeasure){
      applyLayout._busy = true;
      measureScene07Fill(canvas, inner);
      applyLayout._busy = false;
      inner._fillReady = true;
    }
    if(shouldMeasure && group && group.style.opacity === '0' && !applyLayout._busy){
      if(groupHidden) group.classList.add('is-hidden');
      if(prevOpacity) group.style.opacity = prevOpacity;
      else group.style.removeProperty('opacity');
    }
  }

  function hiddenSnapshot(root){
    var nodes = root.querySelectorAll('*');
    var list = [];
    var i;
    for(i = 0; i < nodes.length; i++){
      if(nodes[i].classList.contains('is-hidden')) list.push(nodes[i]);
    }
    return list;
  }

  function restoreHidden(root, hidden){
    var nodes = root.querySelectorAll('*');
    var i;
    for(i = 0; i < nodes.length; i++){
      if(hidden.indexOf(nodes[i]) !== -1) nodes[i].classList.add('is-hidden');
      else nodes[i].classList.remove('is-hidden');
    }
  }

  function readOffsets(inner){
    var nodes = inner.querySelectorAll('.scene07-group-child');
    var list = [];
    var i;
    for(i = 0; i < nodes.length; i++){
      list.push({
        el: nodes[i],
        x: nodes[i].style.getPropertyValue('--offset-x'),
        y: nodes[i].style.getPropertyValue('--offset-y')
      });
    }
    return list;
  }

  function writeOffsets(list){
    var i;
    for(i = 0; i < list.length; i++){
      if(list[i].x) list[i].el.style.setProperty('--offset-x', list[i].x);
      else list[i].el.style.removeProperty('--offset-x');
      if(list[i].y) list[i].el.style.setProperty('--offset-y', list[i].y);
      else list[i].el.style.removeProperty('--offset-y');
    }
  }

  function lockInstant(inner){
    var nodes = inner.querySelectorAll('.scene07-group-child');
    var added = [];
    var i;
    for(i = 0; i < nodes.length; i++){
      if(nodes[i].classList.contains('s07-layout-instant')) continue;
      nodes[i].classList.add('s07-layout-instant');
      added.push(nodes[i]);
    }
    return added;
  }

  function unlockInstant(added){
    var i;
    for(i = 0; i < added.length; i++) added[i].classList.remove('s07-layout-instant');
  }

  function revealTree(root){
    var nodes;
    var i;
    if(!root) return;
    root.classList.remove('is-hidden');
    nodes = root.querySelectorAll('.is-hidden');
    for(i = 0; i < nodes.length; i++) nodes[i].classList.remove('is-hidden');
  }

  function noteBox(canvas, inner){
    inner.style.setProperty('--group-scale', '1');
    Guide01.noteFillState(inner, Guide01.localEdges(inner, inner.querySelectorAll('*')));
  }

  function captureAnimTimes(root){
    var anims = root.getAnimations ? root.getAnimations({ subtree: true }) : [];
    var list = [];
    var i;
    var effect;
    for(i = 0; i < anims.length; i++){
      effect = anims[i].effect;
      list.push({
        node: effect && effect.target,
        name: anims[i].animationName,
        time: anims[i].currentTime
      });
    }
    return list;
  }

  function restoreAnimTimes(root, saved){
    var anims = root.getAnimations ? root.getAnimations({ subtree: true }) : [];
    var i;
    var j;
    var effect;
    for(i = 0; i < saved.length; i++){
      if(saved[i].time == null) continue;
      for(j = 0; j < anims.length; j++){
        effect = anims[j].effect;
        if(effect && effect.target === saved[i].node && anims[j].animationName === saved[i].name){
          anims[j].currentTime = saved[i].time;
          break;
        }
      }
    }
  }

  function measureScene07Fill(canvas, inner){
    var stage = inner.querySelector('#s07-stage');
    var finale = inner.querySelector('#s07-finale');
    var calendar = inner.querySelector('#s07-calendar');
    var animTimes = captureAnimTimes(inner);
    var saved = hiddenSnapshot(inner);
    var rows = inner.querySelectorAll('.ads_row');
    var shownRows = [];
    var locked = lockInstant(inner);
    var prev = readOffsets(inner);
    var prevScale = inner.style.getPropertyValue('--group-scale');
    var i;
    var autoship = inner.querySelector('#s07-autoship');
    inner._fillStates = [];
    if(autoship) autoship.classList.remove('is-hidden');
    if(stage){
      revealTree(stage);
      if(calendar) calendar.classList.add('is-hidden');
      for(i = 0; i < rows.length; i++){
        if(rows[i].classList.contains('s07-ads-skip')) continue;
        if(!rows[i].classList.contains('is-visible')){
          rows[i].classList.add('is-visible');
          shownRows.push(rows[i]);
        }
      }
    }
    if(finale) finale.classList.add('is-hidden');
    applyLayout();
    noteBox(canvas, inner);
    restoreHidden(inner, saved);
    for(i = 0; i < shownRows.length; i++) shownRows[i].classList.remove('is-visible');
    if(finale){
      revealTree(finale);
      if(autoship) autoship.classList.remove('is-hidden');
      if(stage) stage.classList.add('is-hidden');
      applyLayout();
      noteBox(canvas, inner);
    }
    restoreHidden(inner, saved);
    for(i = 0; i < shownRows.length; i++) shownRows[i].classList.remove('is-visible');
    writeOffsets(prev);
    if(prevScale) inner.style.setProperty('--group-scale', prevScale);
    else inner.style.removeProperty('--group-scale');
    inner.getBoundingClientRect();
    restoreAnimTimes(inner, animTimes);
    unlockInstant(locked);
    Guide01.applyNotedFill(canvas, inner);
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
    window.addEventListener('resize', function(){
      if(_ctx && _ctx.group && _ctx.group._inner) _ctx.group._inner._fillReady = false;
      scheduleLayout(false);
    });
  }

  function unbindResize(){
    _resizeBound = false;
    _ctx = null;
  }

  return {
    cloneFromTemplate: cloneFromTemplate,
    createGroup: createGroup,
    parkSlot: parkSlot,
    mountDiscount: mountDiscount,
    mountCalendar: mountCalendar,
    mountPayment: mountPayment,
    mountDelivery: mountDelivery,
    mountBenefitPanel: mountBenefitPanel,
    mountRecommend: mountRecommend,
    mountBase: mountBase,
    mountFinale: mountFinale,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize
  };
})();

function setupScene07Assets(canvas){
  var zone = (Scene07Config.layout && Scene07Config.layout.anchorZone) || 'd4';
  var group = Scene07Layout.createGroup(canvas, zone);
  var inner = group._inner;
  var autoship = Scene07Layout.parkSlot(
    Guide01.addZonedBadge(canvas, 'autoship_icon', 's07-autoship', zone, { scale: 1.15 })
  );
  var stage = document.createElement('div');
  var hero = document.createElement('div');
  var side = document.createElement('div');
  var swap = document.createElement('div');
  var ship = document.createElement('div');
  var member = Guide01.mountMemberAtZone(canvas, 's07-member', zone);
  var dRank = Scene07Layout.cloneFromTemplate('lev_d');
  var calendar = Scene07Layout.mountCalendar();
  var payment = Scene07Layout.mountPayment();
  var discount = Scene07Layout.mountDiscount();
  var delivery = Scene07Layout.mountDelivery();
  var benefit = Scene07Layout.mountBenefitPanel();
  var recommend = Scene07Layout.mountRecommend();
  var base = Scene07Layout.mountBase();
  var finale = Scene07Layout.mountFinale();
  var icon;

  stage.id = 's07-stage';
  stage.className = 'scene07-group-child s07-stage s07-layout-instant is-hidden';
  hero.className = 's07-hero';
  side.className = 's07-side';
  swap.className = 's07-swap';
  ship.className = 's07-ship is-hidden';

  if(autoship){
    autoship.classList.add('scene07-group-child', 's07-layout-instant');
    autoship.style.removeProperty('transform');
    inner.appendChild(autoship);
  }

  Scene07Layout.parkSlot(member);
  icon = member && member.querySelector('.member_icon');
  if(icon) icon.classList.add('s03-toned-as-person');
  if(dRank && member){
    dRank.id = 's07-d-rank';
    dRank.classList.add('s03-d-rank-badge', 'is-hidden');
    var rankSlot = member.querySelector('[data-slot="rank"]');
    if(rankSlot) rankSlot.appendChild(dRank);
  }
  if(member) hero.appendChild(member);
  if(calendar) swap.appendChild(calendar);
  if(payment){
    payment.classList.add('is-hidden');
    swap.appendChild(payment);
  }
  side.appendChild(swap);
  if(discount && discount.wrap){
    discount.wrap.classList.add('is-hidden');
    side.appendChild(discount.wrap);
  }
  hero.appendChild(side);

  if(delivery) ship.appendChild(delivery);
  if(benefit && benefit.wrap) ship.appendChild(benefit.wrap);

  var tail = document.createElement('div');
  tail.className = 's07-tail';
  stage.appendChild(hero);
  stage.appendChild(ship);
  if(recommend) tail.appendChild(recommend);
  if(base) tail.appendChild(base);
  stage.appendChild(tail);
  inner.appendChild(stage);

  if(finale && finale.wrap){
    finale.wrap.classList.add('scene07-group-child', 's07-layout-instant');
    inner.appendChild(finale.wrap);
  }

  Scene07Layout.bindResize({ group: group, canvas: canvas });
  Scene07Layout.scheduleLayout(true);
  requestAnimationFrame(function(){
    var nodes = inner.querySelectorAll('.s07-layout-instant');
    var i;
    for(i = 0; i < nodes.length; i++) nodes[i].classList.remove('s07-layout-instant');
  });

  return {
    group: group,
    stage: stage,
    autoship: autoship,
    member: member,
    dRank: dRank,
    calendar: calendar,
    payment: payment,
    discount: discount,
    ship: ship,
    delivery: delivery,
    benefit: benefit,
    recommend: recommend,
    base: base,
    finale: finale
  };
}
</script>
