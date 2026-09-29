<script>
/* guide01 Scene 06 — 씬3 멤버·상품 + 씬4 구독연장 흐름 */
var Scene06Layout = (function(){
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
    group.id = 's06-stack-group';
    group.className = 'g01-zone-wrap scene06-stack-group is-hidden';
    Guide01.placeAtZone(group, zone);

    var inner = document.createElement('div');
    inner.className = 'scene06-group-inner';
    group.appendChild(inner);
    group._scene06Inner = inner;

    canvas.appendChild(group);
    return group;
  }

  function mountProductWrap(id, letter, scale){
    var node = cloneFromTemplate('product_swap_box');
    var wrap = document.createElement('div');
    var floatInner = document.createElement('div');

    if(!node) return null;

    wrap.id = id;
    wrap.className = 'g01-zone-wrap s03-product-wrap is-hidden';
    wrap.setAttribute('data-letter', letter);

    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String(scale));
    floatInner.style.transform = 'scale(' + scale + ')';

    scene06ConfigureProductBox(node, letter);
    floatInner.appendChild(node);
    wrap.appendChild(floatInner);

    return { wrap: wrap, floatInner: floatInner };
  }

  function mountProductRow(parent, letters, rowId, rowCls){
    var row = document.createElement('div');
    var products = {};
    var stampHost = document.createElement('div');
    var stampFloat = document.createElement('div');
    var stamp;
    var scale = (Scene06Config.layout.scales && Scene06Config.layout.scales.product) || 0.88;
    var i;
    var pack;

    row.id = rowId;
    row.className = rowCls;
    row.style.setProperty('--s03-product-gap', ((Scene06Config.layout.gaps && Scene06Config.layout.gaps.productGap) || 10) + 'px');
    row.style.setProperty('--s03-product-scale', String(scale));

    stampHost.className = 's03-unavailable-host is-hidden';
    stampFloat.className = 'g01-float-inner s03-stamp-float-inner';
    stampFloat.style.setProperty('--g01-base-scale', String((Scene06Config.layout.scales && Scene06Config.layout.scales.stamp) || 0.72));
    stamp = cloneFromTemplate('unavailable_stamp');
    if(stamp){
      stamp.classList.add('guide01-asset');
      stampFloat.appendChild(stamp);
    }
    stampHost.appendChild(stampFloat);

    for(i = 0; i < letters.length; i++){
      pack = mountProductWrap(rowId + '-product-' + letters[i].toLowerCase() + '-' + i, letters[i], scale);
      if(!pack) continue;
      products[letters[i] + '_' + i] = pack.wrap;
      row.appendChild(pack.wrap);
    }

    row.appendChild(stampHost);
    parent.appendChild(row);

    return { row: row, products: products, stampHost: stampHost, stampFloat: stampFloat };
  }

  function mountPrimaryBlock(inner){
    var block = document.createElement('div');
    var badgeHost = document.createElement('div');
    var letters = Scene06Config.layout.productLetters || ['A', 'B', 'C', 'D', 'E'];
    var productPack;
    var products = {};
    var i;
    var key;

    block.id = 's06-primary-block';
    block.className = 's06-primary-block scene06-group-child s06-layout-instant is-hidden';

    badgeHost.id = 's06-add-badge-host';
    badgeHost.className = 's03-unavailable-host s06-add-badge-host is-hidden';

    productPack = mountProductRow(block, letters, 's06-product-row', 's03-product-row');
    productPack.row.appendChild(badgeHost);
    inner.appendChild(block);

    for(i = 0; i < letters.length; i++){
      key = letters[i];
      products[key] = productPack.products[key + '_' + i];
    }

    return {
      block: block,
      productRow: productPack.row,
      products: products,
      addBadgeHost: badgeHost,
      addBadgeFloat: null,
      stampHost: productPack.stampHost
    };
  }

  function mountDuplicateBlock(inner){
    var block = document.createElement('div');
    var letters = Scene06Config.layout.duplicateLetters || ['A', 'A', 'A', 'A', 'E'];
    var productPack;
    var products = {};
    var i;

    block.id = 's06-duplicate-block';
    block.className = 's06-duplicate-block scene06-group-child s06-layout-instant is-hidden';

    productPack = mountProductRow(block, letters, 's06-dup-row', 's03-product-row s06-dup-row');
    inner.appendChild(block);

    for(i = 0; i < letters.length; i++){
      products['dup_' + i] = productPack.products[letters[i] + '_' + i];
    }

    return {
      block: block,
      row: productPack.row,
      products: products,
      stampHost: productPack.stampHost,
      stampFloat: productPack.stampFloat
    };
  }

  function mountSwapBlock(inner){
    var block = document.createElement('div');
    var panel = document.createElement('div');
    var title = document.createElement('div');
    var panelBody = document.createElement('div');
    var swapIcon;

    block.id = 's06-swap-block';
    block.className = 's06-swap-block scene06-group-child s06-layout-instant is-hidden';

    panel.className = 's06-swap-panel-card subscription_flow_card guide01-asset';
    panel.setAttribute('role', 'img');
    panel.setAttribute('aria-label', '3개월 내 제품 변경 불가');

    title.className = 's06-swap-title subscription_flow_title';
    title.textContent = '3개월 내 제품 변경 불가';

    panelBody.className = 's06-swap-panel-body';
    swapIcon = cloneFromTemplate('product_swap_icon');
    if(swapIcon){
      swapIcon.classList.add('guide01-asset', 's06-swap-panel');
      panelBody.appendChild(swapIcon);
    }

    panel.appendChild(title);
    panel.appendChild(panelBody);
    block.appendChild(panel);
    inner.appendChild(block);

    return { block: block, panel: panel, title: title, panelBody: panelBody, swapIcon: swapIcon };
  }

  function customizeScene06CancelFlow(flow){
    var title;
    var slots;
    var slot2;
    var slot4;
    var coin;

    if(!flow || flow.dataset.s06CancelFlow === '1') return;

    if(typeof Scene04Layout !== 'undefined' && Scene04Layout.ensureFlowMonthSlots){
      Scene04Layout.ensureFlowMonthSlots(flow);
    }

    flow.classList.add('s06-cancel-flow');
    flow.setAttribute('aria-label', '해지 신청 시 3개월 구독 유지 후 자동 해지');

    title = flow.querySelector('.subscription_flow_title');
    if(title){
      title.innerHTML = '해지 신청 시 <br class="s06-flow-title-br">3개월 구독 유지 후 자동 해지';
    }

    slots = flow.querySelectorAll('.s04-flow-month-slot');
    slot2 = slots[1];
    if(slot2){
      coin = slot2.querySelector('.s04-flow-payment-coin');
      if(coin){
        coin.innerHTML = '<span class="s04-flow-payment-coin-inner s04-flow-payment-coin-auto s06-flow-request-coin">해지 신청</span>';
      }
    }

    slot4 = slots[3];
    if(slot4){
      coin = slot4.querySelector('.s04-flow-payment-coin');
      if(coin){
        coin.innerHTML = '<span class="s04-flow-payment-coin-inner s04-flow-payment-coin-auto s06-flow-done-coin">자동 해지</span>';
      }
    }

    flow.dataset.s06CancelFlow = '1';
  }

  function mountCalendarBlock(inner){
    var block = document.createElement('div');
    var wrap = document.createElement('div');
    var floatInner = document.createElement('div');
    var flow;
    var scale = (Scene06Config.layout.scales && Scene06Config.layout.scales.calendar);
    if(scale == null) scale = 1;

    block.id = 's06-calendar-block';
    block.className = 's06-calendar-block scene06-group-child s06-layout-instant is-hidden';

    wrap.id = 's06-calendar-wrap';
    wrap.className = 's04-calendar-wrap g01-float-host';

    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String(scale));
    floatInner.style.transform = 'scale(' + scale + ')';

    flow = cloneFromTemplate('subscription_flow_card');
    if(flow){
      flow.id = 's06-subscription-flow';
      flow.classList.add('guide01-asset', 's04-subscription-flow');
      customizeScene06CancelFlow(flow);
      floatInner.appendChild(flow);
    }

    wrap.appendChild(floatInner);
    wrap._float = floatInner;
    block.appendChild(wrap);
    inner.appendChild(block);

    return { block: block, wrap: wrap, floatInner: floatInner, flow: flow };
  }

  function localSizeFromRect(rect, inner){
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    return { width: rect.width / gs, height: rect.height / gs };
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

  function memberContentGap(assets, gaps){
    gaps = gaps || {};
    var base = gaps.memberContent != null ? gaps.memberContent : 24;
    if(!assets || !assets.member) return base;
    var attached = assets.member.querySelector('.g01-attached-badge:not(.is-hidden)');
    if(!attached) return base;
    return gaps.memberProductAutoship != null ? gaps.memberProductAutoship : Math.max(base, 42);
  }

  function stackOrder(){
    return ['member', 'primary', 'duplicate', 'swap', 'calendar'];
  }

  function resolveWrap(assets, key){
    if(key === 'member') return assets.member;
    if(key === 'primary') return assets.primary && assets.primary.block;
    if(key === 'duplicate') return assets.duplicate && assets.duplicate.block;
    if(key === 'swap') return assets.swap && assets.swap.block;
    if(key === 'calendar') return assets.calendar && assets.calendar.block;
    return null;
  }

  function gapAfterKey(prevKey, gaps, assets){
    if(prevKey === 'member') return memberContentGap(assets, gaps);
    return gaps.sectionGap != null ? gaps.sectionGap : 14;
  }

  function fitGroupScale(canvas, inner){
    var scales = Scene06Config.layout.scales || {};
    var minScale = scales.minFit != null ? scales.minFit : 0.4;
    var pad = 12;
    var canvasW = canvas.clientWidth - pad * 2;
    var canvasH = canvas.clientHeight - pad * 2;
    var children = inner.querySelectorAll('.scene06-group-child:not(.is-hidden)');
    var minX = Infinity;
    var minY = Infinity;
    var maxX = -Infinity;
    var maxY = -Infinity;
    var scale = 1;
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

    if(maxX - minX > canvasW) scale = Math.min(scale, canvasW / (maxX - minX));
    if(maxY - minY > canvasH) scale = Math.min(scale, canvasH / (maxY - minY));

    inner.style.setProperty('--group-scale', String(Math.max(minScale, Math.min(1, scale))));
  }

  function applyLayout(canvas, group, assets){
    if(!canvas || !group || !assets) return;
    var inner = group._scene06Inner;
    if(!inner) return;
    var gaps = Scene06Config.layout.gaps || {};
    var order = stackOrder();
    var chain = [];
    var totalH = 0;
    var cursor;
    var i;
    var h;
    var wrap;
    var endMeasure = beginMeasurePass(group);

    for(i = 0; i < order.length; i++){
      wrap = resolveWrap(assets, order[i]);
      if(!wrap || !isWrapVisible(wrap)) continue;
      chain.push({ key: order[i], wrap: wrap, size: measureBlock(wrap, inner) });
    }

    if(chain.length){
      for(i = 0; i < chain.length; i++){
        totalH += chain[i].size.height;
        if(i > 0) totalH += gapAfterKey(chain[i - 1].key, gaps, assets);
      }
      cursor = -totalH / 2;
      for(i = 0; i < chain.length; i++){
        h = chain[i].size.height;
        setOffset(chain[i].wrap, 0, cursor + h / 2);
        cursor += h;
        if(i < chain.length - 1) cursor += gapAfterKey(chain[i].key, gaps, assets);
      }
    }

    inner.style.setProperty('--s04-stack-content-width-fallback', 'min(92vw, 460px)');
    fitGroupScale(canvas, inner);
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

  function createAddBadge(){
    var badge = cloneFromTemplate('guide_info_badge');
    var labelEl;
    var textEl;
    if(!badge) return null;
    badge.classList.add('is_green', 'guide01-asset', 's06-add-badge');
    labelEl = badge.querySelector('.guide_info_badge_label');
    textEl = badge.querySelector('.guide_info_badge_text');
    if(labelEl) labelEl.textContent = '+';
    if(textEl) textEl.textContent = '최대 5품목 다른 상품 구독 가능';
    badge.setAttribute('aria-label', '최대 5품목 다른 상품 구독 가능');
    return badge;
  }

  return {
    createGroup: createGroup,
    cloneFromTemplate: cloneFromTemplate,
    mountPrimaryBlock: mountPrimaryBlock,
    mountDuplicateBlock: mountDuplicateBlock,
    mountSwapBlock: mountSwapBlock,
    mountCalendarBlock: mountCalendarBlock,
    createAddBadge: createAddBadge,
    applyLayout: applyLayout,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize
  };
})();

function scene06ConfigureProductBox(box, letter){
  if(!box) return;
  box.textContent = letter;
  box.classList.add('guide01-asset', 's03-product-box');
  box.setAttribute('aria-label', '품목 ' + letter);
}

function setupScene06Assets(canvas){
  Scene06Layout.unbindResize();

  var group = Scene06Layout.createGroup(canvas, Scene06Config.layout.anchorZone);
  var inner = group._scene06Inner;

  var member = Guide01.mountMemberAtZone(canvas, 's06-member', Scene06Config.layout.anchorZone);
  member.classList.add('scene06-group-child', 's06-layout-instant');
  inner.appendChild(member);

  var memberIcon = member.querySelector('.member_icon');
  if(memberIcon) memberIcon.classList.add('s03-toned-as-person');

  var dRank = Scene06Layout.cloneFromTemplate('lev_d');
  if(dRank){
    dRank.id = 's06-d-rank';
    dRank.classList.add('s03-d-rank-badge', 'is-hidden');
    var rankSlot = member.querySelector('[data-slot="rank"]');
    if(rankSlot) rankSlot.appendChild(dRank);
  }

  var autoshipAttach = Guide01.prepareMemberAttach(member, {
    slot: 'autoship',
    openTemplate: 'autoship_icon',
    closedTemplate: 'autoship_icon_c'
  });

  if(autoshipAttach && autoshipAttach.slot && autoshipAttach.attached){
    var openAttached = Scene06Layout.cloneFromTemplate('autoship_icon');
    if(openAttached){
      openAttached.id = autoshipAttach.attached.id;
      openAttached.classList.add('g01-attached-badge', 'is-hidden');
      autoshipAttach.slot.replaceChild(openAttached, autoshipAttach.attached);
      autoshipAttach.attached = openAttached;
    }
  }

  var primary = Scene06Layout.mountPrimaryBlock(inner);
  var duplicate = Scene06Layout.mountDuplicateBlock(inner);
  var swap = Scene06Layout.mountSwapBlock(inner);
  var calendar = Scene06Layout.mountCalendarBlock(inner);

  var assets = {
    group: group,
    member: member,
    dRank: dRank,
    autoshipAttach: autoshipAttach,
    primary: primary,
    duplicate: duplicate,
    swap: swap,
    calendar: calendar
  };

  Scene06Layout.applyLayout(canvas, group, assets);
  Scene06Layout.bindResize(canvas, group, assets);

  requestAnimationFrame(function(){
    var children = group.querySelectorAll('.scene06-group-child');
    for(var i = 0; i < children.length; i++){
      children[i].classList.remove('s06-layout-instant');
    }
  });

  return assets;
}

</script>
