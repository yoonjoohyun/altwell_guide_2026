<script>
/* guide01 Scene 05 — E.P·추천포인트 분할 발생 */
var Scene05Layout = (function(){
  var _resizeBound = false;
  var _pending = false;
  var _ctx = null;

  function setOffset(wrap, x, y){
    if(!wrap) return;
    wrap.style.setProperty('--offset-x', (Math.round(x * 10) / 10) + 'px');
    wrap.style.setProperty('--offset-y', (Math.round(y * 10) / 10) + 'px');
  }

  function setScale(wrap, scale){
    if(!wrap) return;
    wrap.style.setProperty('--s05-slot-scale', String(scale));
  }

  function cloneFromTemplate(templateId){
    var host = document.querySelector('#guide01-templates [data-template="' + templateId + '"]');
    if(!host || !host.firstElementChild) return null;
    return host.firstElementChild.cloneNode(true);
  }

  function createGroup(canvas, zone){
    var group = document.createElement('div');
    group.id = 's05-stack-group';
    group.className = 'g01-zone-wrap scene05-stack-group is-hidden';
    Guide01.placeAtZone(group, zone);

    var inner = document.createElement('div');
    inner.className = 'scene05-group-inner';
    group.appendChild(inner);
    group._scene05Inner = inner;

    canvas.appendChild(group);
    return group;
  }

  function reparentAsChild(wrap, inner){
    if(!wrap || !inner) return wrap;
    wrap.classList.remove('lo-zone-place');
    wrap.removeAttribute('data-zone');
    wrap.style.removeProperty('--zone-row');
    wrap.style.removeProperty('--zone-col');
    wrap.style.left = '';
    wrap.style.top = '';
    wrap.style.transform = '';
    wrap.classList.add('scene05-group-child', 's05-layout-instant');
    inner.appendChild(wrap);
    return wrap;
  }

  function createEpCoin(scale){
    var coin = cloneFromTemplate('point_token_icon');
    var inner;
    var wrap;
    var floatInner;

    if(!coin) return null;

    inner = coin.querySelector('.point_token_inner');
    if(inner) inner.textContent = 'EP';
    coin.classList.add('s05-ep-coin', 'guide01-asset');
    coin.setAttribute('aria-label', 'E.P');

    wrap = document.createElement('div');
    wrap.className = 's05-ep-coin-wrap';
    floatInner = document.createElement('div');
    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String(scale || 0.88));
    floatInner.style.transform = 'scale(' + (scale || 0.88) + ')';
    floatInner.appendChild(coin);
    wrap.appendChild(floatInner);
    return wrap;
  }

  function configureCalendar(card, monthIndex, label){
    var header;
    var title;

    if(!card) return;
    header = card.querySelector('.calendar_header');
    title = card.querySelector('.calendar_title');
    if(header) header.textContent = 'M' + (monthIndex + 1);
    if(title) title.textContent = label;
    card.setAttribute('aria-label', label);
  }

  function createInfoBadge(text, modifier){
    var badge = cloneFromTemplate('guide_info_badge');
    var labelEl;
    var textEl;

    if(!badge) return null;
    if(modifier) badge.classList.add(modifier);
    labelEl = badge.querySelector('.guide_info_badge_label');
    textEl = badge.querySelector('.guide_info_badge_text');
    if(labelEl) labelEl.textContent = '!';
    if(textEl) textEl.textContent = text;
    badge.classList.add('guide01-asset', 's05-info-badge');
    return badge;
  }

  function wirePaymentTapHosts(payment){
    var cardSlot = payment && payment.querySelector('.pbb_card-slot');
    var card = cardSlot && cardSlot.querySelector('.pbb_card');
    var cardAnchor;
    var tapPaymentHost = document.createElement('div');

    tapPaymentHost.className = 's04-tap-payment-host is-hidden';
    tapPaymentHost.id = payment.id + '-tap-host';

    if(cardSlot && card){
      cardAnchor = document.createElement('div');
      cardAnchor.className = 's04-card-anchor';
      cardSlot.insertBefore(cardAnchor, card);
      cardAnchor.appendChild(card);
      cardSlot.insertBefore(tapPaymentHost, cardAnchor);
    }else if(cardSlot){
      cardSlot.insertBefore(tapPaymentHost, cardSlot.firstChild);
    }else{
      payment.appendChild(tapPaymentHost);
    }

    return tapPaymentHost;
  }

  function mountAutoshipBadge(canvas, payStack){
    var scale = (Scene05Config.layout.scales && Scene05Config.layout.scales.autoship) || 0.88;
    var wrap = Guide01.addZonedBadge(
      canvas,
      'autoship_icon',
      's05-autoship',
      Scene05Config.layout.anchorZone,
      { scale: scale }
    );
    var floatInner;
    var badge;

    if(!wrap) return { wrap: null, badge: null, floatInner: null };

    if(wrap.parentNode) wrap.parentNode.removeChild(wrap);
    wrap.classList.remove('lo-zone-place');
    wrap.removeAttribute('data-zone');
    wrap.style.removeProperty('--zone-row');
    wrap.style.removeProperty('--zone-col');
    wrap.style.left = '';
    wrap.style.top = '';
    wrap.style.transform = '';
    wrap.classList.add('s05-autoship-wrap');

    floatInner = wrap._float || wrap.querySelector('.g01-float-inner');
    badge = Guide01.resolveZonedBadge(wrap);
    if(payStack) payStack.appendChild(wrap);

    return { wrap: wrap, badge: badge, floatInner: floatInner };
  }

  function mountPaymentBatchBox(elId, scale){
    var wrap = document.createElement('div');
    var floatInner = document.createElement('div');
    var payment = cloneFromTemplate('payment_batch_box');
    var tapHost;
    var s = scale != null ? scale : 1;

    wrap.id = elId + '-host';
    wrap.className = 's05-payment-host g01-float-host is-hidden';

    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String(s));
    floatInner.style.transform = 'scale(' + s + ')';

    if(payment){
      payment.id = elId;
      payment.classList.add('guide01-asset');
      tapHost = wirePaymentTapHosts(payment);
      floatInner.appendChild(payment);
    }

    wrap.appendChild(floatInner);
    return { wrap: wrap, payment: payment, floatInner: floatInner, tapHost: tapHost };
  }

  function createCalendarRecommendBadge(){
    var badge = cloneFromTemplate('recommend_bonus_icon_ex');
    var textWrap;
    var line1;
    var line2;

    if(!badge) return null;

    textWrap = badge.querySelector('.recommend_bonus_ex_text');
    line1 = badge.querySelector('.recommend_bonus_text_1');
    line2 = badge.querySelector('.recommend_bonus_text_2');

    if(line1) line1.textContent = '추천포인트';
    if(line2) line2.textContent = '매월 1Point';
    if(textWrap){
      textWrap.classList.add('s05-cal-recommend-text');
    }

    badge.classList.add('guide01-asset', 's05-cal-recommend-badge');
    badge.style.setProperty('--size', '34px');
    badge.setAttribute('aria-label', '추천포인트 매월 1Point');
    return badge;
  }

  function createPointBadge(){
    var badge = cloneFromTemplate('recommend_bonus_icon_ex');
    var textWrap;

    if(!badge) return null;
    textWrap = badge.querySelector('.recommend_bonus_ex_text');
    if(textWrap){
      textWrap.innerHTML = '<span class="recommend_bonus_text_1">추천포인트</span><br class="s05-rec-point-br"><span class="recommend_bonus_text_2">매월 1Point</span>';
      textWrap.classList.add('s05-rec-point-text');
    }
    badge.classList.add('guide01-asset', 's05-point-badge');
    badge.setAttribute('aria-label', '추천포인트 매월 1Point');
    return badge;
  }

  function createRecommendNoticeBadge(){
    var badge = cloneFromTemplate('guide_info_badge');
    var labelEl;
    var textEl;

    if(!badge) return null;
    labelEl = badge.querySelector('.guide_info_badge_label');
    textEl = badge.querySelector('.guide_info_badge_text');
    if(labelEl) labelEl.textContent = '!';
    if(textEl){
      textEl.innerHTML = '오토십 구독자 1인 당<br class="s05-notice-br">매월 1Point 발생';
    }
    badge.classList.add('guide01-asset', 's05-recommend-notice-badge');
    badge.setAttribute('aria-label', '오토십 구독자 1인 당 매월 1Point 발생');
    return badge;
  }

  function mountRecommendProductWrap(id, letter){
    var node = cloneFromTemplate('product_swap_box');
    var wrap = document.createElement('div');
    var floatInner = document.createElement('div');
    var scale = (Scene05Config.layout.scales && Scene05Config.layout.scales.product) || 0.82;

    if(!node) return null;

    wrap.id = id;
    wrap.className = 's05-recommend-product-wrap is-hidden';
    wrap.setAttribute('data-letter', letter);

    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String(scale));
    floatInner.style.transform = 'scale(' + scale + ')';

    scene05ConfigureProductBox(node, letter);
    floatInner.appendChild(node);
    wrap.appendChild(floatInner);
    return wrap;
  }

  function mountRecommendPointHost(cls){
    var host = document.createElement('div');
    host.className = cls + ' is-hidden';
    return host;
  }

  function mountIntroPhase(canvas, inner){
    var phase = document.createElement('div');
    phase.id = 's05-intro-phase';
    phase.className = 's05-intro-phase scene05-group-child s05-layout-instant is-hidden';

    var payStack = document.createElement('div');
    payStack.className = 's05-intro-pay-stack';

    var autoshipPack = mountAutoshipBadge(canvas, payStack);
    var paymentPack = mountPaymentBatchBox('s05-payment-box', (Scene05Config.layout.scales && Scene05Config.layout.scales.payment) || 1);
    var epStack = document.createElement('div');
    var epCoins = [];
    var denyHost = document.createElement('div');
    var gaps = Scene05Config.layout.gaps || {};
    var i;
    var coin;

    phase.style.setProperty(
      '--s05-intro-autoship-payment-gap',
      (gaps.introAutoshipPayment != null ? gaps.introAutoshipPayment : 12) + 'px'
    );

    var epStackInner = document.createElement('div');

    epStack.className = 's05-ep-stack is-hidden';
    epStack.id = 's05-ep-stack';
    epStackInner.className = 's05-ep-stack-inner';

    denyHost.id = 's05-deny-host';
    denyHost.className = 's05-deny-host is-hidden';

    if(paymentPack.wrap) payStack.appendChild(paymentPack.wrap);
    phase.appendChild(payStack);

    for(i = 0; i < 3; i++){
      coin = createEpCoin((Scene05Config.layout.scales && Scene05Config.layout.scales.epCoin) || 0.88);
      if(!coin) continue;
      coin.setAttribute('data-ep-index', String(i));
      epStackInner.appendChild(coin);
      epCoins.push(coin);
    }

    epStack.appendChild(epStackInner);

    phase.appendChild(epStack);
    phase.appendChild(denyHost);

    inner.appendChild(phase);
    return {
      phase: phase,
      autoshipHost: autoshipPack.wrap,
      autoship: autoshipPack.badge,
      autoshipFloat: autoshipPack.floatInner,
      paymentHost: paymentPack.wrap,
      payment: paymentPack.payment,
      paymentFloat: paymentPack.floatInner,
      tapHost: paymentPack.tapHost,
      epStack: epStack,
      epStackInner: epStackInner,
      epCoins: epCoins,
      denyHost: denyHost
    };
  }

  function mountCalendarSlot(monthIndex, label, scale){
    var slot = document.createElement('div');
    var cal = cloneFromTemplate('calendar_month_card');
    var epHost = document.createElement('div');
    var foot = document.createElement('div');
    var epLabel = document.createElement('span');
    var check = cloneFromTemplate('status_check_icon');
    var cashbackHost = document.createElement('div');
    var recommendHost = document.createElement('div');
    var connector = document.createElement('div');

    slot.className = 's05-cal-slot';
    slot.setAttribute('data-month-index', String(monthIndex));

    epHost.className = 's05-cal-ep-host is-hidden';
    if(cal){
      configureCalendar(cal, monthIndex, label);
      cal.classList.add('guide01-asset', 's05-cal-card');
      slot.appendChild(epHost);
      slot.appendChild(cal);
    }

    foot.className = 's05-cal-foot is-hidden';
    epLabel.className = 's05-cal-ep-label';
    epLabel.textContent = 'E.P 발생';
    if(check){
      check.classList.add('guide01-asset', 's05-cal-check');
      foot.appendChild(epLabel);
      foot.appendChild(check);
    }
    slot.appendChild(foot);

    connector.className = 's05-cal-connector is-hidden';
    cashbackHost.className = 's05-cal-cashback-host is-hidden';
    recommendHost.className = 's05-cal-recommend-host is-hidden';
    slot.appendChild(connector);
    slot.appendChild(cashbackHost);
    slot.appendChild(recommendHost);

    return {
      slot: slot,
      epHost: epHost,
      calendar: cal,
      foot: foot,
      connector: connector,
      cashbackHost: cashbackHost,
      recommendHost: recommendHost
    };
  }

  function mountCalendarPhase(canvas, inner){
    var phase = document.createElement('div');
    var row = document.createElement('div');
    var monthBadgeHost = document.createElement('div');
    var months = Scene05Config.layout.calendarMonths || ['1개월 차', '2개월 차', '3개월 차'];
    var slots = [];
    var i;
    var slotPack;

    phase.id = 's05-calendar-phase';
    phase.className = 's05-calendar-phase scene05-group-child s05-layout-instant is-hidden';

    var calendarBody = document.createElement('div');
    var calendarMain = document.createElement('div');

    calendarBody.id = 's05-calendar-body';
    calendarBody.className = 's05-calendar-body';
    calendarMain.className = 's05-calendar-main';

    row.id = 's05-calendar-row';
    row.className = 's05-calendar-row';
    for(i = 0; i < months.length; i++){
      slotPack = mountCalendarSlot(i, months[i], (Scene05Config.layout.scales && Scene05Config.layout.scales.calendar) || 0.82);
      row.appendChild(slotPack.slot);
      slots.push(slotPack);
    }
    calendarMain.appendChild(row);

    monthBadgeHost.id = 's05-month-badge-host';
    monthBadgeHost.className = 's05-month-badge-host is-hidden';
    calendarMain.appendChild(monthBadgeHost);
    calendarBody.appendChild(calendarMain);
    phase.appendChild(calendarBody);

    inner.appendChild(phase);
    return {
      phase: phase,
      calendarBody: calendarBody,
      calendarRow: row,
      slots: slots,
      monthBadgeHost: monthBadgeHost
    };
  }

  function prepMemberNode(member, extraCls){
    if(!member) return;
    member.classList.remove('lo-zone-place', 'is-hidden');
    member.removeAttribute('data-zone');
    member.style.removeProperty('--zone-row');
    member.style.removeProperty('--zone-col');
    member.style.left = '';
    member.style.top = '';
    member.style.transform = '';
    if(extraCls) member.classList.add(extraCls);
  }

  function mountRecommendStoryPhase(canvas, inner){
    var phase = document.createElement('div');
    var noticeHost = document.createElement('div');
    var body = document.createElement('div');
    var leftCol = document.createElement('div');
    var rightCol = document.createElement('div');
    var member1 = Guide01.mountMemberAtZone(canvas, 's05-rec-member-1', Scene05Config.layout.anchorZone);
    var member2 = Guide01.mountMemberAtZone(canvas, 's05-rec-member-2', Scene05Config.layout.anchorZone);
    var leftStack = document.createElement('div');
    var rightStack = document.createElement('div');
    var leftProductRow = document.createElement('div');
    var leftPointHost = mountRecommendPointHost('s05-recommend-point-host s05-recommend-point-left');
    var rightProductWrap = mountRecommendProductWrap('s05-rec-product-a-right', 'A');
    var rightPointHost = mountRecommendPointHost('s05-recommend-point-host s05-recommend-point-right');
    var products = {};
    var letters = ['A', 'B', 'C'];
    var i;
    var wrap;

    phase.id = 's05-recommend-phase';
    phase.className = 's05-recommend-phase scene05-group-child s05-layout-instant is-hidden';

    noticeHost.id = 's05-recommend-notice-host';
    noticeHost.className = 's05-recommend-notice-host g01-zone-wrap is-hidden';
    Guide01.placeAtZone(noticeHost, 'c4');
    canvas.appendChild(noticeHost);

    body.className = 's05-recommend-body';

    leftCol.className = 's05-recommend-col s05-recommend-col-left';
    rightCol.className = 's05-recommend-col s05-recommend-col-right is-hidden';

    prepMemberNode(member1, 's05-recommend-member');
    prepMemberNode(member2, 's05-recommend-member');

    leftStack.className = 's05-recommend-product-stack';
    leftProductRow.id = 's05-rec-product-row-left';
    leftProductRow.className = 's05-recommend-product-row';
    for(i = 0; i < letters.length; i++){
      wrap = mountRecommendProductWrap('s05-rec-product-' + letters[i].toLowerCase() + '-left', letters[i]);
      if(!wrap) continue;
      leftProductRow.appendChild(wrap);
      products[letters[i]] = wrap;
    }

    leftStack.appendChild(leftProductRow);
    leftStack.appendChild(leftPointHost);
    leftCol.appendChild(member1);
    leftCol.appendChild(leftStack);

    rightStack.className = 's05-recommend-product-stack';
    if(rightProductWrap) rightStack.appendChild(rightProductWrap);
    rightStack.appendChild(rightPointHost);
    rightCol.appendChild(member2);
    rightCol.appendChild(rightStack);

    body.appendChild(leftCol);
    body.appendChild(rightCol);
    phase.appendChild(body);
    inner.appendChild(phase);

    return {
      phase: phase,
      noticeHost: noticeHost,
      body: body,
      leftCol: leftCol,
      rightCol: rightCol,
      member1: member1,
      member2: member2,
      leftProductRow: leftProductRow,
      leftPointHost: leftPointHost,
      rightProductWrap: rightProductWrap,
      rightPointHost: rightPointHost,
      products: products
    };
  }

  function localSizeFromRect(rect, inner){
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    return { width: rect.width / gs, height: rect.height / gs };
  }

  function measureWrap(wrap, inner){
    var target;
    if(!wrap) return { width: 0, height: 0 };
    target = wrap.querySelector('.g01-float-inner') || wrap;
    return localSizeFromRect(target.getBoundingClientRect(), inner);
  }

  function measureBlock(wrap, inner){
    if(!wrap) return { width: 0, height: 0 };
    return localSizeFromRect(wrap.getBoundingClientRect(), inner);
  }

  function isWrapVisible(wrap){
    return wrap && !wrap.classList.contains('is-hidden');
  }

  function beginMeasurePass(group){
    var groupWasHidden = group.classList.contains('is-hidden');
    var prevOpacity = group.style.opacity;
    group.classList.remove('is-hidden');
    group.style.opacity = '0';
    group.style.pointerEvents = 'none';
    return function endMeasurePass(){
      if(prevOpacity) group.style.opacity = prevOpacity;
      else group.style.removeProperty('opacity');
      group.style.removeProperty('pointer-events');
      if(groupWasHidden) group.classList.add('is-hidden');
    };
  }

  function stackOrder(){
    return ['intro', 'calendar', 'recommendStory'];
  }

  function resolvePhaseWrap(assets, key){
    if(key === 'intro') return assets.intro && assets.intro.phase;
    if(key === 'calendar') return assets.calendar && assets.calendar.phase;
    if(key === 'recommendStory') return assets.recommendStory && assets.recommendStory.phase;
    return null;
  }

  function gapAfterKey(prevKey, gaps){
    return gaps.stackGap != null ? gaps.stackGap : 12;
  }

  function layoutVerticalChain(chain, gaps){
    var totalH = 0;
    var cursor;
    var i;
    var h;

    if(!chain.length) return;

    for(i = 0; i < chain.length; i++){
      totalH += chain[i].size.height;
      if(i > 0) totalH += gapAfterKey(chain[i - 1].key, gaps);
    }

    cursor = -totalH / 2;
    for(i = 0; i < chain.length; i++){
      h = chain[i].size.height;
      setOffset(chain[i].wrap, 0, cursor + h / 2);
      setScale(chain[i].wrap, 1);
      cursor += h;
      if(i < chain.length - 1) cursor += gapAfterKey(chain[i].key, gaps);
    }
  }

  function measureStackItem(assets, key, inner){
    var wrap = resolvePhaseWrap(assets, key);
    if(!wrap || !isWrapVisible(wrap)) return null;
    return { key: key, wrap: wrap, size: measureBlock(wrap, inner) };
  }

  function fitGroupScale(canvas, inner){
    var scales = Scene05Config.layout.scales || {};
    var minScale = scales.minFit != null ? scales.minFit : 0.42;
    var pad = 12;
    var canvasW = canvas.clientWidth - pad * 2;
    var canvasH = canvas.clientHeight - pad * 2;
    var children = inner.querySelectorAll('.scene05-group-child:not(.is-hidden)');
    var minX = Infinity;
    var minY = Infinity;
    var maxX = -Infinity;
    var maxY = -Infinity;
    var scale = 1;
    var boundsW;
    var boundsH;
    var i;
    var r;

    for(i = 0; i < children.length; i++){
      r = children[i].getBoundingClientRect();
      if(r.width < 1 && r.height < 1) continue;
      minX = Math.min(minX, r.left);
      minY = Math.min(minY, r.top);
      maxX = Math.max(maxX, r.right);
      maxY = Math.max(maxY, r.bottom);
    }

    if(!isFinite(minX)){
      inner.style.setProperty('--group-scale', '1');
      return;
    }

    boundsW = maxX - minX;
    boundsH = maxY - minY;

    if(boundsW > 0 && boundsW > canvasW) scale = Math.min(scale, canvasW / boundsW);
    if(boundsH > 0 && boundsH > canvasH) scale = Math.min(scale, canvasH / boundsH);

    inner.style.setProperty('--group-scale', String(Math.max(minScale, Math.min(1, scale))));
  }

  function applyD4StackLayout(canvas, assets, inner, gaps){
    var order = stackOrder();
    var chain = [];
    var i;
    var item;

    for(i = 0; i < order.length; i++){
      item = measureStackItem(assets, order[i], inner);
      if(item) chain.push(item);
    }

    if(chain.length) layoutVerticalChain(chain, gaps);
    fitGroupScale(canvas, inner);
  }

  function applyLayout(canvas, group, assets){
    if(!canvas || !group || !assets) return;
    var inner = group._scene05Inner;
    if(!inner) return;
    var gaps = Scene05Config.layout.gaps || {};
    var endMeasure = beginMeasurePass(group);
    applyD4StackLayout(canvas, assets, inner, gaps);
    endMeasure();
  }

  function scheduleLayout(immediate){
    if(!_ctx) return;
    if(immediate){
      _pending = false;
      applyLayout(_ctx.canvas, _ctx.group, _ctx.assets);
      return;
    }
    if(_pending) return;
    _pending = true;
    requestAnimationFrame(function(){
      _pending = false;
      if(_ctx) applyLayout(_ctx.canvas, _ctx.group, _ctx.assets);
    });
  }

  function bindResize(canvas, group, assets){
    _ctx = { canvas: canvas, group: group, assets: assets };
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', function(){
      scheduleLayout(false);
    });
  }

  function unbindResize(){
    _resizeBound = false;
    _ctx = null;
    _pending = false;
  }

  return {
    createGroup: createGroup,
    reparentAsChild: reparentAsChild,
    cloneFromTemplate: cloneFromTemplate,
    createEpCoin: createEpCoin,
    createInfoBadge: createInfoBadge,
    createCalendarRecommendBadge: createCalendarRecommendBadge,
    createPointBadge: createPointBadge,
    createRecommendNoticeBadge: createRecommendNoticeBadge,
    mountIntroPhase: mountIntroPhase,
    mountCalendarPhase: mountCalendarPhase,
    mountRecommendStoryPhase: mountRecommendStoryPhase,
    applyLayout: applyLayout,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize
  };
})();

function scene05ConfigureProductBox(box, letter){
  if(!box) return;
  box.textContent = letter;
  box.classList.add('guide01-asset', 's05-product-box');
  box.setAttribute('aria-label', '품목 ' + letter);
}

function setupScene05Assets(canvas){
  Scene05Layout.unbindResize();

  var group = Scene05Layout.createGroup(canvas, Scene05Config.layout.anchorZone);
  var inner = group._scene05Inner;

  var intro = Scene05Layout.mountIntroPhase(canvas, inner);
  var calendar = Scene05Layout.mountCalendarPhase(canvas, inner);
  var recommendStory = Scene05Layout.mountRecommendStoryPhase(canvas, inner);

  var assets = {
    group: group,
    intro: intro,
    calendar: calendar,
    recommendStory: recommendStory
  };

  Scene05Layout.applyLayout(canvas, group, assets);
  Scene05Layout.bindResize(canvas, group, assets);

  requestAnimationFrame(function(){
    var children = group.querySelectorAll('.scene05-group-child');
    for(var i = 0; i < children.length; i++){
      children[i].classList.remove('s05-layout-instant');
    }
  });

  return assets;
}

</script>
