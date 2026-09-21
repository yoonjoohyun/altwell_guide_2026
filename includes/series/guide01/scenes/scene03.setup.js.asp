<script>
/* guide01 Scene 03 — 멤버 + 상품 1열 배치 */
var Scene03Layout = (function(){
  var _resizeBound = false;
  var _pending = false;
  var _ctx = null;
  var _memberBelow = null;

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
    group.id = 's03-stack-group';
    group.className = 'g01-zone-wrap scene03-stack-group is-hidden';
    Guide01.placeAtZone(group, zone);

    var inner = document.createElement('div');
    inner.className = 'scene03-group-inner';
    group.appendChild(inner);
    group._scene03Inner = inner;

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
    wrap.classList.add('scene03-group-child', 's03-layout-instant');
    inner.appendChild(wrap);
    return wrap;
  }

  function mountProductRow(inner, letters, scale){
    var row = document.createElement('div');
    row.id = 's03-product-row';
    row.className = 's03-product-row scene03-group-child s03-layout-instant is-hidden';
    inner.appendChild(row);

    var stampHost = document.createElement('div');
    stampHost.id = 's03-unavailable-host';
    stampHost.className = 's03-unavailable-host is-hidden';
    var stamp = cloneFromTemplate('unavailable_stamp');
    if(stamp){
      stamp.classList.add('guide01-asset');
      stampHost.appendChild(stamp);
    }
    row.appendChild(stampHost);

    var checkHost = document.createElement('div');
    checkHost.id = 's03-check-host';
    checkHost.className = 's03-check-host is-hidden';
    row.appendChild(checkHost);

    var products = {};
    var i;
    for(i = 0; i < letters.length; i++){
      var letter = letters[i];
      var node = cloneFromTemplate('product_swap_box');
      if(!node) continue;

      var wrap = document.createElement('div');
      wrap.id = 's03-product-' + letter.toLowerCase();
      wrap.className = 'g01-zone-wrap s03-product-wrap is-hidden';
      wrap.setAttribute('data-letter', letter);

      var floatInner = document.createElement('div');
      floatInner.className = 'g01-float-inner';
      floatInner.style.setProperty('--g01-base-scale', String(scale));
      floatInner.style.transform = 'scale(' + scale + ')';

      scene03ConfigureProductBox(node, letter);
      floatInner.appendChild(node);
      wrap.appendChild(floatInner);
      row.appendChild(wrap);
      products[letter] = wrap;
    }

    return { row: row, products: products, stampHost: stampHost, checkHost: checkHost };
  }

  function localSizeFromRect(rect, inner){
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    return { width: rect.width / gs, height: rect.height / gs };
  }

  function unionRectSize(nodes, inner){
    if(!nodes || !nodes.length) return { width: 0, height: 0 };
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    var minL = Infinity;
    var minT = Infinity;
    var maxR = -Infinity;
    var maxB = -Infinity;
    var i;
    var r;

    for(i = 0; i < nodes.length; i++){
      if(!nodes[i]) continue;
      r = nodes[i].getBoundingClientRect();
      if(r.width <= 0 && r.height <= 0) continue;
      minL = Math.min(minL, r.left);
      minT = Math.min(minT, r.top);
      maxR = Math.max(maxR, r.right);
      maxB = Math.max(maxB, r.bottom);
    }

    if(minL === Infinity) return { width: 0, height: 0 };
    return {
      width: (maxR - minL) / gs,
      height: (maxB - minT) / gs
    };
  }

  function measureWrap(wrap, inner){
    if(!wrap) return { width: 0, height: 0 };
    var target = wrap.querySelector('.g01-float-inner') || wrap;
    return localSizeFromRect(target.getBoundingClientRect(), inner);
  }

  function collectMemberNodes(wrap){
    var nodes = [];
    var icon;
    var attached;
    var dRank;
    var slots;
    var i;

    if(!wrap) return nodes;

    icon = wrap.querySelector('.member_icon');
    attached = wrap.querySelectorAll('.g01-attached-badge:not(.is-hidden)');
    dRank = wrap.querySelector('.s03-d-rank-badge:not(.is-hidden)');
    slots = wrap.querySelectorAll('.g01-attach-slot');

    if(icon) nodes.push(icon);
    for(i = 0; i < attached.length; i++) nodes.push(attached[i]);
    if(dRank) nodes.push(dRank);
    for(i = 0; i < slots.length; i++){
      var child = slots[i].firstElementChild;
      if(child && !child.classList.contains('is-hidden')) nodes.push(child);
    }

    return nodes;
  }

  function measureMemberWrap(wrap, inner){
    if(!wrap) return { width: 0, height: 0 };

    var union = unionRectSize(collectMemberNodes(wrap), inner);
    if(union.width > 0 && union.height > 0) return union;
    return measureWrap(wrap, inner);
  }

  /* 멤버 wrap 중심(y=0) 기준 — member_icon 박스 안에서만 측정(부착 뱃지는 member 내부) */
  function measureMemberExtents(wrap, inner){
    if(!wrap) return { above: 0, below: 0, width: 0, height: 0 };

    var anchor = wrap.querySelector('.g01-member-stack') || wrap;
    var icon = wrap.querySelector('.member_icon');
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    var anchorRect;
    var iconRect;
    var anchorCenterY;

    if(!icon){
      var fallback = measureWrap(wrap, inner);
      return {
        above: fallback.height / 2,
        below: fallback.height / 2,
        width: fallback.width,
        height: fallback.height
      };
    }

    anchorRect = anchor.getBoundingClientRect();
    iconRect = icon.getBoundingClientRect();
    anchorCenterY = anchorRect.top + anchorRect.height / 2;

    return {
      above: Math.max(0, anchorCenterY - iconRect.top) / gs,
      below: Math.max(0, iconRect.bottom - anchorCenterY) / gs,
      width: iconRect.width / gs,
      height: iconRect.height / gs
    };
  }

  function collectProductRowNodes(row){
    var nodes = [];
    var wraps;
    var i;

    if(!row) return nodes;

    if(row.classList.contains('is-stacked')){
      wraps = row.querySelectorAll('.s03-product-wrap.is-stacked-target:not(.is-hidden)');
    } else {
      wraps = row.querySelectorAll('.s03-product-wrap:not(.is-hidden)');
    }

    for(i = 0; i < wraps.length; i++){
      nodes.push(wraps[i].querySelector('.g01-float-inner') || wraps[i]);
    }

    if(row.querySelector('.s03-unavailable-host.is-visible')){
      nodes.push(row.querySelector('.s03-unavailable-host'));
    }

    var checkHost = row.querySelector('.s03-check-host:not(.is-hidden)');
    if(checkHost && checkHost.firstElementChild){
      nodes.push(checkHost);
    }

    return nodes;
  }

  function measureProductRow(row, inner){
    if(!row) return { width: 0, height: 0 };

    var nodes = collectProductRowNodes(row);
    var union = unionRectSize(nodes, inner);
    if(union.width > 0 && union.height > 0) return union;
    return localSizeFromRect(row.getBoundingClientRect(), inner);
  }

  function memberProductGap(assets, gaps){
    gaps = gaps || {};
    var base = gaps.memberProduct != null ? gaps.memberProduct : 24;
    if(!assets || !assets.member) return base;

    var attached = assets.member.querySelector('.g01-attached-badge:not(.is-hidden)');
    if(!attached) return base;
    return gaps.memberProductAutoship != null ? gaps.memberProductAutoship : Math.max(base, 42);
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

  function pinMember(member){
    if(!member) return;
    setOffset(member, 0, 0);
    member.classList.add('s03-member-fixed');
  }

  function lockMemberAnchor(assets, inner){
    if(!assets || !assets.member || !inner) return;
    pinMember(assets.member);
    _memberBelow = measureMemberExtents(assets.member, inner).below;
  }

  function getMemberBelow(assets, inner){
    if(_memberBelow != null) return _memberBelow;
    if(!assets || !assets.member || !inner) return 0;
    return measureMemberExtents(assets.member, inner).below;
  }

  function applyLayout(canvas, group, assets){
    if(!canvas || !group || !assets) return;

    var inner = group._scene03Inner;
    if(!inner) return;

    var gaps = Scene03Config.layout.gaps;
    var endMeasure = beginMeasurePass(group);
    var memberVisible = isWrapVisible(assets.member);
    var productVisible = assets.productRow && isWrapVisible(assets.productRow);
    var productSize;
    var gap;

    /* 멤버 offset은 pinMember/lockMemberAnchor에서만 설정 — 제품 레이아웃과 분리 */
    if(productVisible){
      productSize = measureProductRow(assets.productRow, inner);
      gap = memberVisible ? memberProductGap(assets, gaps) : 0;
      setOffset(
        assets.productRow,
        0,
        getMemberBelow(assets, inner) + gap + productSize.height / 2
      );
    }

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
    _memberBelow = null;
  }

  return {
    createGroup: createGroup,
    reparentAsChild: reparentAsChild,
    mountProductRow: mountProductRow,
    pinMember: pinMember,
    lockMemberAnchor: lockMemberAnchor,
    applyLayout: applyLayout,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize,
    cloneFromTemplate: cloneFromTemplate
  };
})();

function scene03ConfigureProductBox(box, letter){
  if(!box) return;
  box.textContent = letter;
  box.classList.add('guide01-asset', 's03-product-box');
  box.setAttribute('aria-label', '품목 ' + letter);
}

function scene03SetProductLetter(wrap, letter){
  if(!wrap) return;
  wrap.setAttribute('data-letter', letter);
  var box = wrap.querySelector('.product_swap_box');
  if(!box) return;
  box.textContent = letter;
  box.setAttribute('aria-label', '품목 ' + letter);
}

function setupScene03Assets(canvas){
  Scene03Layout.unbindResize();

  var S = Scene03Config.layout.scales;
  var letters = Scene03Config.layout.productLetters;
  var group = Scene03Layout.createGroup(canvas, Scene03Config.layout.anchorZone);

  var member = Guide01.mountMemberAtZone(canvas, 's03-member', Scene03Config.layout.anchorZone);
  member.classList.add('scene03-group-child', 's03-layout-instant');
  Scene03Layout.reparentAsChild(member, group._scene03Inner);
  Scene03Layout.pinMember(member);

  var memberIcon = member.querySelector('.member_icon');
  if(memberIcon) memberIcon.classList.add('s03-toned-as-person');

  var dRank = Scene03Layout.cloneFromTemplate('lev_d');
  if(dRank){
    dRank.id = 's03-d-rank';
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
    var openAttached = Scene03Layout.cloneFromTemplate('autoship_icon');
    if(openAttached){
      openAttached.id = autoshipAttach.attached.id;
      openAttached.classList.add('g01-attached-badge', 'is-hidden');
      autoshipAttach.slot.replaceChild(openAttached, autoshipAttach.attached);
      autoshipAttach.attached = openAttached;
    }
  }

  var productPack = Scene03Layout.mountProductRow(group._scene03Inner, letters, S.product || 0.88);
  var gaps = Scene03Config.layout.gaps || {};
  if(productPack.row){
    productPack.row.style.setProperty('--s03-product-gap', (gaps.productGap != null ? gaps.productGap : 12) + 'px');
    productPack.row.style.setProperty('--s03-product-scale', String(S.product || 0.88));
  }

  var assets = {
    group: group,
    member: member,
    dRank: dRank,
    autoshipAttach: autoshipAttach,
    productRow: productPack.row,
    products: productPack.products,
    stampHost: productPack.stampHost,
    checkHost: productPack.checkHost
  };

  Scene03Layout.applyLayout(canvas, group, assets);
  Scene03Layout.bindResize(canvas, group, assets);

  requestAnimationFrame(function(){
    var children = group.querySelectorAll('.scene03-group-child');
    for(var i = 0; i < children.length; i++){
      children[i].classList.remove('s03-layout-instant');
    }
  });

  return assets;
}

</script>
