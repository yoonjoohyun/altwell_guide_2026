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

  function mountPaymentBatchBox(elId, scale){
    var wrap = document.createElement('div');
    var floatInner = document.createElement('div');
    var payment = cloneFromTemplate('payment_batch_box');
    var tapHost;
    var s = scale != null ? scale : 1;

    wrap.id = elId + '-host';
    wrap.className = 's05-payment-host g01-float-host';

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

  function createPointBadge(){
    var badge = cloneFromTemplate('recommend_bonus_icon_ex');
    var text1;
    var text2;

    if(!badge) return null;
    text1 = badge.querySelector('.recommend_bonus_text_1');
    text2 = badge.querySelector('.recommend_bonus_text_2');
    if(text1) text1.textContent = '추천포인트';
    if(text2) text2.textContent = '매월 1Point';
    badge.classList.add('guide01-asset', 's05-point-badge');
    badge.setAttribute('aria-label', '매월 1Point 추천포인트');
    return badge;
  }

  function mountIntroPhase(inner){
    var phase = document.createElement('div');
    phase.id = 's05-intro-phase';
    phase.className = 's05-intro-phase scene05-group-child s05-layout-instant is-hidden';

    var paymentPack = mountPaymentBatchBox('s05-payment-box', (Scene05Config.layout.scales && Scene05Config.layout.scales.payment) || 1);
    var epStack = document.createElement('div');
    var epCoins = [];
    var denyHost = document.createElement('div');
    var i;
    var coin;

    epStack.className = 's05-ep-stack';
    epStack.id = 's05-ep-stack';

    denyHost.id = 's05-deny-host';
    denyHost.className = 's05-deny-host is-hidden';

    if(paymentPack.wrap) phase.appendChild(paymentPack.wrap);

    for(i = 0; i < 3; i++){
      coin = createEpCoin((Scene05Config.layout.scales && Scene05Config.layout.scales.epCoin) || 0.88);
      if(!coin) continue;
      coin.setAttribute('data-ep-index', String(i));
      epStack.appendChild(coin);
      epCoins.push(coin);
    }

    phase.appendChild(epStack);
    phase.appendChild(denyHost);

    inner.appendChild(phase);
    return {
      phase: phase,
      paymentHost: paymentPack.wrap,
      payment: paymentPack.payment,
      paymentFloat: paymentPack.floatInner,
      tapHost: paymentPack.tapHost,
      epStack: epStack,
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
    slot.appendChild(connector);
    slot.appendChild(cashbackHost);

    return {
      slot: slot,
      epHost: epHost,
      calendar: cal,
      foot: foot,
      connector: connector,
      cashbackHost: cashbackHost
    };
  }

  function mountCalendarPhase(canvas, inner){
    var phase = document.createElement('div');
    var paymentPack = mountPaymentBatchBox('s05-payment-mini', (Scene05Config.layout.scales && Scene05Config.layout.scales.paymentMini) || 0.72);
    var row = document.createElement('div');
    var monthBadgeHost = document.createElement('div');
    var memberSide = document.createElement('div');
    var member = Guide01.mountMemberAtZone(canvas, 's05-cal-member', Scene05Config.layout.anchorZone);
    var pointBadgeHost = document.createElement('div');
    var months = Scene05Config.layout.calendarMonths || ['1개월 차', '2개월 차', '3개월 차'];
    var slots = [];
    var i;
    var slotPack;

    phase.id = 's05-calendar-phase';
    phase.className = 's05-calendar-phase scene05-group-child s05-layout-instant is-hidden';

    if(paymentPack.wrap) phase.appendChild(paymentPack.wrap);

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

    memberSide.id = 's05-member-side';
    memberSide.className = 's05-member-side is-hidden';
    if(member){
      member.classList.remove('lo-zone-place', 'is-hidden');
      member.removeAttribute('data-zone');
      member.style.removeProperty('--zone-row');
      member.style.removeProperty('--zone-col');
      member.style.left = '';
      member.style.top = '';
      member.style.transform = '';
      member.classList.add('s05-side-member');
      memberSide.appendChild(member);
    }
    pointBadgeHost.id = 's05-side-point-host';
    pointBadgeHost.className = 's05-side-point-host is-hidden';
    memberSide.appendChild(pointBadgeHost);
    calendarBody.appendChild(memberSide);
    phase.appendChild(calendarBody);

    inner.appendChild(phase);
    return {
      phase: phase,
      paymentHost: paymentPack.wrap,
      paymentMini: paymentPack.payment,
      paymentMiniFloat: paymentPack.floatInner,
      calendarBody: calendarBody,
      calendarRow: row,
      slots: slots,
      monthBadgeHost: monthBadgeHost,
      memberSide: memberSide,
      member: member,
      pointBadgeHost: pointBadgeHost
    };
  }

  function mountMemberProductPhase(canvas, inner){
    var phase = document.createElement('div');
    var memberHost = document.createElement('div');
    var member = Guide01.mountMemberAtZone(canvas, 's05-main-member', Scene05Config.layout.anchorZone);
    var personBadgeHost = document.createElement('div');
    var productRow = document.createElement('div');
    var products = {};
    var letters = ['A', 'B', 'C'];
    var i;
    var node;
    var wrap;
    var floatInner;
    var pointHost;

    phase.id = 's05-member-product-phase';
    phase.className = 's05-member-product-phase scene05-group-child s05-layout-instant is-hidden';

    memberHost.className = 's05-main-member-host';
    if(member){
      member.classList.remove('lo-zone-place', 'is-hidden');
      member.removeAttribute('data-zone');
      member.style.removeProperty('--zone-row');
      member.style.removeProperty('--zone-col');
      member.style.left = '';
      member.style.top = '';
      member.style.transform = '';
      member.classList.add('s05-main-member');
      memberHost.appendChild(member);
    }

    personBadgeHost.id = 's05-person-badge-host';
    personBadgeHost.className = 's05-person-badge-host is-hidden';
    memberHost.appendChild(personBadgeHost);

    productRow.id = 's05-product-row';
    productRow.className = 's05-product-row';
    for(i = 0; i < letters.length; i++){
      node = cloneFromTemplate('product_swap_box');
      if(!node) continue;
      wrap = document.createElement('div');
      wrap.id = 's05-product-' + letters[i].toLowerCase();
      wrap.className = 's05-product-wrap is-hidden';
      wrap.setAttribute('data-letter', letters[i]);

      floatInner = document.createElement('div');
      floatInner.className = 'g01-float-inner';
      floatInner.style.setProperty('--g01-base-scale', String((Scene05Config.layout.scales && Scene05Config.layout.scales.product) || 0.82));
      floatInner.style.transform = 'scale(' + ((Scene05Config.layout.scales && Scene05Config.layout.scales.product) || 0.82) + ')';

      scene05ConfigureProductBox(node, letters[i]);
      floatInner.appendChild(node);
      wrap.appendChild(floatInner);

      pointHost = document.createElement('div');
      pointHost.className = 's05-product-point-host is-hidden';
      wrap.appendChild(pointHost);

      productRow.appendChild(wrap);
      products[letters[i]] = wrap;
    }

    phase.appendChild(memberHost);
    phase.appendChild(productRow);
    inner.appendChild(phase);

    return {
      phase: phase,
      member: member,
      personBadgeHost: personBadgeHost,
      productRow: productRow,
      products: products
    };
  }

  function mountDualGroup(canvas, side){
    var group = document.createElement('div');
    var member = Guide01.mountMemberAtZone(canvas, 's05-dual-member-' + side, Scene05Config.layout.anchorZone);
    var productRow = document.createElement('div');
    var pointHost = document.createElement('div');
    var bracketHost = document.createElement('div');
    var count = side === 'left' ? 1 : 3;
    var letters = side === 'left' ? ['A'] : ['A', 'B', 'C'];
    var products = {};
    var i;
    var node;
    var wrap;
    var floatInner;

    group.className = 's05-dual-group s05-dual-group-' + side;
    group.id = 's05-dual-group-' + side;

    if(member){
      member.classList.remove('lo-zone-place', 'is-hidden');
      member.removeAttribute('data-zone');
      member.style.removeProperty('--zone-row');
      member.style.removeProperty('--zone-col');
      member.style.left = '';
      member.style.top = '';
      member.style.transform = '';
      member.classList.add('s05-dual-member');
      group.appendChild(member);
    }

    productRow.className = 's05-dual-product-row';
    productRow.style.setProperty('--s05-dual-product-count', String(count));
    for(i = 0; i < letters.length; i++){
      node = cloneFromTemplate('product_swap_box');
      if(!node) continue;
      wrap = document.createElement('div');
      wrap.className = 's05-dual-product-wrap';
      wrap.setAttribute('data-letter', letters[i]);

      floatInner = document.createElement('div');
      floatInner.className = 'g01-float-inner';
      floatInner.style.setProperty('--g01-base-scale', String((Scene05Config.layout.scales && Scene05Config.layout.scales.product) || 0.82));
      floatInner.style.transform = 'scale(' + ((Scene05Config.layout.scales && Scene05Config.layout.scales.product) || 0.82) + ')';

      scene05ConfigureProductBox(node, letters[i]);
      floatInner.appendChild(node);
      wrap.appendChild(floatInner);
      productRow.appendChild(wrap);
      products[letters[i]] = wrap;
    }
    if(side === 'right'){
      bracketHost.id = 's05-bracket-host';
      bracketHost.className = 's05-bracket-host is-hidden';
      productRow.appendChild(bracketHost);
    }

    group.appendChild(productRow);

    pointHost.id = 's05-dual-point-' + side;
    pointHost.className = 's05-dual-point-host is-hidden';
    group.appendChild(pointHost);

    return {
      group: group,
      member: member,
      productRow: productRow,
      products: products,
      bracketHost: bracketHost,
      pointHost: pointHost
    };
  }

  function mountDualPhase(canvas, inner){
    var phase = document.createElement('div');
    var row = document.createElement('div');
    var left = mountDualGroup(canvas, 'left');
    var right = mountDualGroup(canvas, 'right');

    phase.id = 's05-dual-phase';
    phase.className = 's05-dual-phase scene05-group-child s05-layout-instant is-hidden';

    row.className = 's05-dual-row';
    row.appendChild(left.group);
    row.appendChild(right.group);
    phase.appendChild(row);
    inner.appendChild(phase);

    return {
      phase: phase,
      row: row,
      left: left,
      right: right
    };
  }

  function mountSummaryPhase(inner){
    var phase = document.createElement('div');
    var card = cloneFromTemplate('member_basis_card');

    phase.id = 's05-summary-phase';
    phase.className = 's05-summary-phase scene05-group-child s05-layout-instant is-hidden';

    if(card){
      card.id = 's05-summary-card';
      card.classList.add('guide01-asset', 's05-summary-card');
      phase.appendChild(card);
    }

    inner.appendChild(phase);
    return { phase: phase, card: card };
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
    return ['intro', 'calendar', 'memberProduct', 'dual', 'summary'];
  }

  function resolvePhaseWrap(assets, key){
    if(key === 'intro') return assets.intro && assets.intro.phase;
    if(key === 'calendar') return assets.calendar && assets.calendar.phase;
    if(key === 'memberProduct') return assets.memberProduct && assets.memberProduct.phase;
    if(key === 'dual') return assets.dual && assets.dual.phase;
    if(key === 'summary') return assets.summary && assets.summary.phase;
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
    createPointBadge: createPointBadge,
    mountIntroPhase: mountIntroPhase,
    mountCalendarPhase: mountCalendarPhase,
    mountMemberProductPhase: mountMemberProductPhase,
    mountDualPhase: mountDualPhase,
    mountSummaryPhase: mountSummaryPhase,
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

  var intro = Scene05Layout.mountIntroPhase(inner);
  var calendar = Scene05Layout.mountCalendarPhase(canvas, inner);
  var memberProduct = Scene05Layout.mountMemberProductPhase(canvas, inner);
  var dual = Scene05Layout.mountDualPhase(canvas, inner);
  var summary = Scene05Layout.mountSummaryPhase(inner);

  var assets = {
    group: group,
    intro: intro,
    calendar: calendar,
    memberProduct: memberProduct,
    dual: dual,
    summary: summary
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
