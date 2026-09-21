<script>
/* guide01 Scene 02 — d4 세로 스택 마운트 · 상대 배치 */
var Scene02Layout = (function(){
  var _resizeBound = false;
  var _pending = false;
  var _ctx = null;
  var _benefitsCollapsed = false;
  var _autoshipSummaryTighten = 0;

  function setOffset(wrap, x, y){
    if(!wrap) return;
    wrap.style.setProperty('--offset-x', (Math.round(x * 10) / 10) + 'px');
    wrap.style.setProperty('--offset-y', (Math.round(y * 10) / 10) + 'px');
  }

  function createGroup(canvas, zone){
    var group = document.createElement('div');
    group.id = 's02-stack-group';
    group.className = 'g01-zone-wrap scene02-stack-group is-hidden';
    Guide01.placeAtZone(group, zone);

    var inner = document.createElement('div');
    inner.className = 'scene02-group-inner';
    group.appendChild(inner);
    group._scene02Inner = inner;

    canvas.appendChild(group);
    return group;
  }

  function reparentZonedWrap(wrap, group){
    if(!wrap || !group || !group._scene02Inner) return wrap;
    wrap.classList.remove('lo-zone-place');
    wrap.removeAttribute('data-zone');
    wrap.style.removeProperty('--zone-row');
    wrap.style.removeProperty('--zone-col');
    wrap.style.left = '';
    wrap.style.top = '';
    wrap.style.transform = '';
    wrap.classList.add('scene02-group-child', 's02-layout-instant');
    group._scene02Inner.appendChild(wrap);
    return wrap;
  }

  function mountInGroup(canvas, group, templateId, elId, opts, isBadge){
    var wrap = isBadge
      ? Guide01.addZonedBadge(canvas, templateId, elId, Scene02Config.layout.anchorZone, opts || {})
      : Guide01.addZonedAsset(canvas, templateId, elId, Scene02Config.layout.anchorZone, opts || {});
    return reparentZonedWrap(wrap, group);
  }

  function localSizeFromRect(rect, inner){
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    return { width: rect.width / gs, height: rect.height / gs };
  }

  function measureInnerWrap(wrap, inner){
    if(!wrap) return { width: 0, height: 0 };
    var target = wrap.querySelector('.g01-float-inner') || wrap;
    return localSizeFromRect(target.getBoundingClientRect(), inner);
  }

  function snapshotBadgeState(wrap){
    var badge = Guide01.resolveZonedBadge(wrap);
    if(!badge) return { badge: null, textEl: null, className: '' };
    var textEl = badge.querySelector('[class$="_text"]');
    return {
      badge: badge,
      textEl: textEl,
      className: badge.className,
      textDisplay: textEl ? textEl.style.display : '',
      textOpacity: textEl ? textEl.style.opacity : ''
    };
  }

  function forceBadgeOpen(badge, textEl){
    if(!badge) return;
    Guide01.badgeToOpen(badge);
    badge.classList.add('g01-badge-is-open', 'g01-badge-text-in');
    badge.classList.remove('g01-badge-is-closed', 'g01-badge-folding', 'g01-badge-unfolding', 'g01-badge-text-out');
    if(textEl){
      textEl.style.setProperty('display', 'inline-block', 'important');
      textEl.style.opacity = '1';
    }
  }

  function forceBadgeClosed(badge, textEl){
    if(!badge) return;
    Guide01.badgeToClosed(badge);
    badge.classList.add('g01-badge-is-closed');
    badge.classList.remove('g01-badge-is-open', 'g01-badge-unfolding', 'g01-badge-text-in');
    if(textEl){
      textEl.style.display = 'none';
      textEl.style.opacity = '0';
    }
  }

  function restoreBadgeState(snap){
    if(!snap || !snap.badge) return;
    snap.badge.className = snap.className;
    if(!snap.textEl) return;
    if(snap.textDisplay) snap.textEl.style.display = snap.textDisplay;
    else snap.textEl.style.removeProperty('display');
    if(snap.textOpacity) snap.textEl.style.opacity = snap.textOpacity;
    else snap.textEl.style.removeProperty('opacity');
  }

  function measureBadgeWrap(wrap, inner, mode){
    if(!wrap) return { width: 0, height: 0 };
    var snap = snapshotBadgeState(wrap);
    if(snap.badge){
      if(mode === 'closed') forceBadgeClosed(snap.badge, snap.textEl);
      else forceBadgeOpen(snap.badge, snap.textEl);
    }
    var size = measureInnerWrap(wrap, inner);
    restoreBadgeState(snap);
    return size;
  }

  function measureSummaryWrap(wrap, inner){
    if(!wrap) return { width: 0, height: 0 };
    var card = wrap.querySelector('.autoship_discount_summary_card');
    var rows = card ? card.querySelectorAll('.ads_row') : [];
    var i;
    var prev = [];
    var anyVisible = false;

    for(i = 0; i < rows.length; i++){
      prev.push(rows[i].classList.contains('is-visible'));
      if(prev[i]) anyVisible = true;
    }

    if(anyVisible){
      for(i = 0; i < rows.length; i++) rows[i].classList.add('is-visible');
    }

    var size = measureInnerWrap(wrap, inner);

    for(i = 0; i < rows.length; i++){
      if(prev[i]) rows[i].classList.add('is-visible');
      else rows[i].classList.remove('is-visible');
    }

    return size;
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

  function isAutoshipFolded(assets){
    return assets.autoship && assets.autoship.classList.contains('is-autoship-folded');
  }

  function stackOrder(){
    if(_benefitsCollapsed){
      return ['autoship', 'summary', 'benefitsBox'];
    }
    return ['autoship', 'summary', 'base', 'cashback', 'recommend'];
  }

  function collapseBenefitsIntoBox(assets){
    if(_benefitsCollapsed || !assets || !assets.benefitsBox) return;

    var row = assets.benefitsBox.querySelector('.rpb_row');
    if(!row) return;

    var keys = ['base', 'cashback', 'recommend'];
    var i;

    for(i = 0; i < keys.length; i++){
      var wrap = assets[keys[i]];
      if(!wrap) continue;

      if(typeof Guide01 !== 'undefined' && Guide01.stopIdleFloat){
        Guide01.stopIdleFloat(wrap);
      }

      wrap.classList.remove('scene02-group-child', 's02-layout-instant');
      wrap.style.removeProperty('--offset-x');
      wrap.style.removeProperty('--offset-y');
      wrap.classList.add('scene02-in-box-badge');
      row.appendChild(wrap);
    }

    var boxEl = assets.benefitsBox.querySelector('.reward_plan_basis_box');
    if(boxEl) boxEl.classList.add('is-filled');

    _benefitsCollapsed = true;
  }

  function resetBenefitsCollapse(){
    _benefitsCollapsed = false;
  }

  function gapAfterKey(key, gaps){
    if(key === 'autoship'){
      var gap = gaps.autoshipSummaryGap != null ? gaps.autoshipSummaryGap : 5;
      var overlap = (gaps.autoshipSummaryOverlap != null ? gaps.autoshipSummaryOverlap : 0) + _autoshipSummaryTighten;
      return gap - overlap;
    }
    return gaps.stackGap != null ? gaps.stackGap : 10;
  }

  function tightenAutoshipSummaryGap(px){
    _autoshipSummaryTighten = px != null ? px : 0;
  }

  function resetAutoshipSummaryGap(){
    _autoshipSummaryTighten = 0;
  }

  function measureStackItem(assets, key, inner){
    var wrap = assets[key];
    if(!wrap || !isWrapVisible(wrap)) return null;

    if(key === 'autoship'){
      var mode = isAutoshipFolded(assets) ? 'closed' : 'open';
      return { key: key, wrap: wrap, size: measureBadgeWrap(wrap, inner, mode) };
    }
    if(key === 'summary'){
      return { key: key, wrap: wrap, size: measureSummaryWrap(wrap, inner) };
    }
    if(key === 'benefitsBox'){
      return { key: key, wrap: wrap, size: measureInnerWrap(wrap, inner) };
    }
    return { key: key, wrap: wrap, size: measureBadgeWrap(wrap, inner, 'open') };
  }

  function applyLayout(canvas, group, assets){
    if(!canvas || !group || !assets) return;

    var inner = group._scene02Inner;
    if(!inner) return;

    var gaps = Scene02Config.layout.gaps;
    var endMeasure = beginMeasurePass(group);
    var order = stackOrder();
    var chain = [];
    var i;

    for(i = 0; i < order.length; i++){
      var item = measureStackItem(assets, order[i], inner);
      if(item) chain.push(item);
    }

    if(!chain.length){
      endMeasure();
      return;
    }

    var totalH = 0;
    for(i = 0; i < chain.length; i++){
      totalH += chain[i].size.height;
      if(i > 0) totalH += gapAfterKey(chain[i - 1].key, gaps);
    }

    var cursor = -totalH / 2;
    for(i = 0; i < chain.length; i++){
      var h = chain[i].size.height;
      setOffset(chain[i].wrap, 0, cursor + h / 2);
      cursor += h;
      if(i < chain.length - 1) cursor += gapAfterKey(chain[i].key, gaps);
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
    resetBenefitsCollapse();
    resetAutoshipSummaryGap();
  }

  return {
    createGroup: createGroup,
    mountInGroup: mountInGroup,
    applyLayout: applyLayout,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize,
    collapseBenefitsIntoBox: collapseBenefitsIntoBox,
    resetBenefitsCollapse: resetBenefitsCollapse,
    tightenAutoshipSummaryGap: tightenAutoshipSummaryGap,
    resetAutoshipSummaryGap: resetAutoshipSummaryGap
  };
})();

function scene02SetBaseBadgeLabel(wrap, label){
  if(!wrap) return;
  var badge = Guide01.resolveZonedBadge(wrap);
  if(!badge) return;
  var textEl = badge.querySelector('.base_text');
  if(textEl) textEl.textContent = label;
  badge.setAttribute('aria-label', label);
}

function setupScene02Assets(canvas){
  Scene02Layout.unbindResize();

  var S = Scene02Config.layout.scales;
  var group = Scene02Layout.createGroup(canvas, Scene02Config.layout.anchorZone);

  var assets = {
    group: group,
    autoship: Scene02Layout.mountInGroup(canvas, group, 'autoship_icon', 's02-autoship', {
      scale: S.autoship
    }, true),
    summary: Scene02Layout.mountInGroup(canvas, group, 'autoship_discount_summary_card', 's02-discount-summary', {
      scale: S.summary
    }, false),
    base: Scene02Layout.mountInGroup(canvas, group, 'base_business_icon', 's02-base', {
      scale: S.base
    }, true),
    cashback: Scene02Layout.mountInGroup(canvas, group, 'cashback_icon', 's02-cashback', {
      scale: S.cashback
    }, true),
    recommend: Scene02Layout.mountInGroup(canvas, group, 'recommend_bonus_icon', 's02-recommend', {
      scale: S.recommend
    }, true),
    benefitsBox: Scene02Layout.mountInGroup(canvas, group, 'reward_plan_basis_box', 's02-benefits-box', {
      scale: S.benefitsBox || 0.88
    }, false)
  };

  scene02SetBaseBadgeLabel(assets.base, 'BASE 사업자');

  Scene02Layout.applyLayout(canvas, group, assets);
  Scene02Layout.bindResize(canvas, group, assets);

  requestAnimationFrame(function(){
    var children = group.querySelectorAll('.scene02-group-child');
    for(var i = 0; i < children.length; i++){
      children[i].classList.remove('s02-layout-instant');
    }
  });

  return assets;
}

</script>
