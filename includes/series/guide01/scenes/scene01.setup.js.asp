<script>
/* guide01 Scene 01 — 멤버 기준 그룹 마운트 · 상대 배치 */
var Scene01Layout = (function(){
  var _resizeBound = false;
  var _pending = false;
  var _ctx = null;

  function createGroup(canvas, zone){
    var group = document.createElement('div');
    group.id = 's01-member-group';
    group.className = 'g01-zone-wrap scene01-member-group is-hidden';
    Guide01.placeAtZone(group, zone);

    var inner = document.createElement('div');
    inner.className = 'scene01-group-inner';
    group.appendChild(inner);
    group._scene01Inner = inner;

    canvas.appendChild(group);
    return group;
  }

  function reparentZonedWrap(wrap, group){
    if(!wrap || !group || !group._scene01Inner) return wrap;
    wrap.classList.remove('lo-zone-place');
    wrap.removeAttribute('data-zone');
    wrap.style.removeProperty('--zone-row');
    wrap.style.removeProperty('--zone-col');
    wrap.style.left = '';
    wrap.style.top = '';
    wrap.style.transform = '';
    wrap.classList.add('scene01-group-child');
    group._scene01Inner.appendChild(wrap);
    return wrap;
  }

  function mountInGroup(canvas, group, templateId, elId, opts, isBadge){
    var wrap = isBadge
      ? Guide01.addZonedBadge(canvas, templateId, elId, Scene01Config.layout.anchorZone, opts || {})
      : Guide01.addZonedAsset(canvas, templateId, elId, Scene01Config.layout.anchorZone, opts || {});
    return reparentZonedWrap(wrap, group);
  }

  function mountCalendarInGroup(canvas, group, elId, label){
    var wrap = Guide01.addZonedCalendar(canvas, elId, Scene01Config.layout.anchorZone, label);
    return reparentZonedWrap(wrap, group);
  }

  function setOffset(wrap, x, y){
    if(!wrap) return;
    wrap.style.setProperty('--offset-x', (Math.round(x * 10) / 10) + 'px');
    wrap.style.setProperty('--offset-y', (Math.round(y * 10) / 10) + 'px');
  }

  function withMeasureVis(wrap, fn){
    if(!wrap) return fn(null);
    var rect = fn(wrap);
    return rect;
  }

  function measureWrapRect(wrap){
    return withMeasureVis(wrap, function(){
      var target = wrap.querySelector('.g01-float-inner') || wrap;
      return target.getBoundingClientRect();
    });
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

  function forceBadgeFullyOpen(badge, textEl){
    if(!badge) return;
    Guide01.badgeToOpen(badge);
    badge.classList.add('g01-badge-is-open', 'g01-badge-text-in');
    badge.classList.remove(
      'g01-badge-is-closed', 'g01-badge-folding', 'g01-badge-unfolding', 'g01-badge-text-out'
    );
    if(textEl){
      textEl.style.setProperty('display', 'inline-block', 'important');
      textEl.style.opacity = '1';
      textEl.style.removeProperty('max-width');
      textEl.style.removeProperty('width');
    }
  }

  function restoreBadgeState(snap, keepOpen){
    if(!snap || !snap.badge) return;
    if(keepOpen){
      forceBadgeFullyOpen(snap.badge, snap.textEl);
      return;
    }
    snap.badge.className = snap.className;
    if(!snap.textEl) return;
    if(snap.textDisplay) snap.textEl.style.display = snap.textDisplay;
    else snap.textEl.style.removeProperty('display');
    if(snap.textOpacity) snap.textEl.style.opacity = snap.textOpacity;
    else snap.textEl.style.removeProperty('opacity');
    snap.textEl.style.removeProperty('max-width');
    snap.textEl.style.removeProperty('width');
  }

  function isWrapVisible(wrap){
    return wrap && !wrap.classList.contains('is-hidden');
  }

  function badgeWasOpen(snap){
    return snap && snap.className && /_o\b/.test(snap.className);
  }

  function measureUnfoldedBadgeWrap(wrap){
    if(!wrap) return { width: 0, height: 0 };
    return withMeasureVis(wrap, function(){
      var snap = snapshotBadgeState(wrap);
      var keepOpen = isWrapVisible(wrap) && badgeWasOpen(snap);
      forceBadgeFullyOpen(snap.badge, snap.textEl);
      var target = wrap.querySelector('.g01-float-inner') || wrap;
      var rect = target.getBoundingClientRect();
      restoreBadgeState(snap, keepOpen);
      return rect;
    });
  }

  function measureRowWrapSize(wrap){
    var inner = wrap && (wrap.querySelector('.g01-float-inner') || wrap);
    if(!inner) return { width: 0, height: 0 };
    var r = inner.getBoundingClientRect();
    return { width: Math.ceil(r.width), height: Math.ceil(r.height) };
  }

  function measurePlusRowSize(wrap){
    var inner = wrap && wrap.querySelector('.g01-float-inner');
    var icon = wrap && wrap.querySelector('.effect_plus_icon');
    if(!inner) return { width: 0, height: 0 };
    var ir = inner.getBoundingClientRect();
    var w = ir.width;
    var h = ir.height;
    if(icon){
      var gr = icon.getBoundingClientRect();
      w = Math.max(w, gr.width);
      h = Math.max(h, gr.height);
    }
    return { width: Math.ceil(w), height: Math.ceil(h) };
  }

  function measureBadgeRowSize(wrap){
    var inner = wrap && (wrap.querySelector('.g01-float-inner') || wrap);
    if(!inner) return { width: 0, height: 0 };
    var ir = inner.getBoundingClientRect();
    var w = ir.width;
    var h = ir.height;
    var badge = Guide01.resolveZonedBadge(wrap);
    if(badge){
      var br = badge.getBoundingClientRect();
      w = Math.max(w, br.width);
      h = Math.max(h, br.height);
    }
    return { width: Math.ceil(w), height: Math.ceil(h) };
  }

  function measureBenefitRowRects(assets){
    var badgeWraps = [assets.discount, assets.cashback, assets.recommend];
    var snaps = [];
    var i;

    for(i = 0; i < badgeWraps.length; i++){
      snaps.push(snapshotBadgeState(badgeWraps[i]));
      forceBadgeFullyOpen(snaps[i].badge, snaps[i].textEl);
    }

    /* offset은 wrap(= float-inner) 중심 — 모든 항목 동일 기준으로 측정 */
    var rects = {
      discount: measureBadgeRowSize(assets.discount),
      plus: measurePlusRowSize(assets.plus),
      cashback: measureBadgeRowSize(assets.cashback),
      plusRecommend: measurePlusRowSize(assets.plusRecommend),
      recommend: measureBadgeRowSize(assets.recommend)
    };

    for(i = 0; i < snaps.length; i++){
      var keepOpen = isWrapVisible(badgeWraps[i]) && badgeWasOpen(snaps[i]);
      restoreBadgeState(snaps[i], keepOpen);
    }

    return rects;
  }

  function layoutBenefitRow(assets, autoshipBottom, gaps){
    var row = measureBenefitRowRects(assets);
    var rowGap = gaps.benefitRowGap != null ? gaps.benefitRowGap : 10;
    var rowH = Math.max(
      row.discount.height, row.plus.height, row.cashback.height,
      row.plusRecommend.height, row.recommend.height
    );
    var rowY = autoshipBottom + gaps.autoshipToBenefit + rowH / 2;
    /* 캐시백 중심 = 그룹 앵커(d4) 중심(x=0), 좌·우는 gap 기준 펼침 */
    var items = [
      { wrap: assets.discount, w: row.discount.width },
      { wrap: assets.plus, w: row.plus.width },
      { wrap: assets.cashback, w: row.cashback.width },
      { wrap: assets.plusRecommend, w: row.plusRecommend.width },
      { wrap: assets.recommend, w: row.recommend.width }
    ];
    var anchorIdx = 2;
    var j;
    var x;

    setOffset(items[anchorIdx].wrap, 0, rowY);

    x = items[anchorIdx].w / 2;
    for(j = anchorIdx + 1; j < items.length; j++){
      x += rowGap + items[j].w / 2;
      setOffset(items[j].wrap, x, rowY);
      x += items[j].w / 2;
    }

    x = -items[anchorIdx].w / 2;
    for(j = anchorIdx - 1; j >= 0; j--){
      x -= rowGap + items[j].w / 2;
      setOffset(items[j].wrap, x, rowY);
      x -= items[j].w / 2;
    }
  }

  function zoneCellSize(canvas){
    var safe = window.matchMedia('(max-width:900px)').matches ? 5 : 10;
    var w = canvas.clientWidth - safe * 2;
    var h = canvas.clientHeight - safe * 2;
    return { safe: safe, cellW: w / 7, cellH: h / 7 };
  }

  function zoneLeftPx(canvas, zone){
    var z = Guide01.parseZone(zone);
    if(!z || !canvas) return 0;
    var grid = zoneCellSize(canvas);
    return grid.safe + (z.col - 1) * grid.cellW;
  }

  function zoneTopPx(canvas, zone){
    var z = Guide01.parseZone(zone);
    if(!z || !canvas) return 0;
    var grid = zoneCellSize(canvas);
    return grid.safe + (z.row - 1) * grid.cellH;
  }

  /* #motion-zone-grid 셀 상단 — 보이는 그리드 라인과 동기 */
  function zoneCellTopFromGrid(canvas, zone){
    var z = Guide01.parseZone(zone);
    if(!z || !canvas) return zoneTopPx(canvas, zone);
    var gridEl = document.getElementById('motion-zone-grid');
    if(!gridEl || !gridEl.children.length) return zoneTopPx(canvas, zone);
    var idx = (z.row - 1) * 7 + (z.col - 1);
    var cell = gridEl.children[idx];
    if(!cell) return zoneTopPx(canvas, zone);
    var canvasRect = canvas.getBoundingClientRect();
    return cell.getBoundingClientRect().top - canvasRect.top;
  }

  function getOffset(wrap){
    var x = wrap.style.getPropertyValue('--offset-x');
    var y = wrap.style.getPropertyValue('--offset-y');
    return { x: x ? parseFloat(x) : 0, y: y ? parseFloat(y) : 0 };
  }

  function shiftAllAssetsY(assets, deltaY){
    var keys = ['member','autoship','calendar','discount','plus','cashback','plusRecommend','recommend','base'];
    var i;
    for(i = 0; i < keys.length; i++){
      var wrap = assets[keys[i]];
      if(!wrap) continue;
      var off = getOffset(wrap);
      setOffset(wrap, off.x, off.y + deltaY);
    }
  }

  /* 멤버 ::before 머리 상단 = memberHeadZone 그리드 상단 라인 (c4 텍스트 아님) */
  function alignMemberHeadToZoneTop(canvas, group, assets){
    var layout = Scene01Config.layout;
    var gaps = layout.gaps;
    var inner = group._scene01Inner;
    if(!inner || !assets.member) return;

    var groupScale = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    var headTopRatio = gaps.memberHeadTopRatio != null ? gaps.memberHeadTopRatio : 0.2;
    var targetTop = zoneCellTopFromGrid(canvas, layout.memberHeadZone || 'c4');

    var memberInner = assets.member.querySelector('.g01-float-inner') || assets.member;
    var memberRect = memberInner.getBoundingClientRect();
    if(memberRect.height < 1) return;

    var canvasRect = canvas.getBoundingClientRect();
    var memberLocalH = memberRect.height / groupScale;
    var memberCenterCanvasY = memberRect.top - canvasRect.top + memberRect.height / 2;
    var headTopFromCenter = (-memberLocalH / 2) + memberLocalH * headTopRatio;
    var currentHeadTop = memberCenterCanvasY + headTopFromCenter * groupScale;
    var deltaLocalY = (targetTop - currentHeadTop) / groupScale;

    if(Math.abs(deltaLocalY) < 0.05) return;
    shiftAllAssetsY(assets, deltaLocalY);
  }

  function offsetXFromAnchor(canvas, anchorZone, canvasX, halfW){
    var anchor = Guide01.zoneCenterPx(canvas, anchorZone);
    return canvasX - anchor.x + halfW;
  }

  /* 멤버 scale 0.5 기준 gap → 멤버 크기 변경 시 비례 보정 */
  function memberGapScale(){
    var s = Scene01Config.layout.scales.member;
    return (s != null ? s : 0.5) / 0.5;
  }

  function beginMeasurePass(group, assets){
    var keys = ['member','autoship','calendar','discount','plus','cashback','plusRecommend','recommend','base'];
    var hidden = {};
    var i;
    var groupWasHidden = group.classList.contains('is-hidden');
    var prevOpacity = group.style.opacity;
    var prevPointer = group.style.pointerEvents;
    group.classList.remove('is-hidden');
    group.style.opacity = '0';
    group.style.pointerEvents = 'none';
    for(i = 0; i < keys.length; i++){
      var wrap = assets[keys[i]];
      if(!wrap) continue;
      hidden[keys[i]] = wrap.classList.contains('is-hidden');
      wrap.classList.remove('is-hidden');
    }
    return function endMeasurePass(){
      if(prevOpacity) group.style.opacity = prevOpacity;
      else group.style.removeProperty('opacity');
      if(prevPointer) group.style.pointerEvents = prevPointer;
      else group.style.removeProperty('pointer-events');
      if(groupWasHidden) group.classList.add('is-hidden');
      for(i = 0; i < keys.length; i++){
        var w = assets[keys[i]];
        if(w && hidden[keys[i]]) w.classList.add('is-hidden');
      }
    };
  }

  function applyLayout(canvas, group, assets){
    if(!canvas || !group || !assets) return;

    var gaps = Scene01Config.layout.gaps;
    var mg = memberGapScale();
    var inner = group._scene01Inner;
    if(!inner) return;

    var endMeasure = beginMeasurePass(group, assets);

    setOffset(assets.member, 0, 0);

    var memberR = measureWrapRect(assets.member);
    var memberHalfW = memberR.width / 2;
    var memberHalfH = memberR.height / 2;
    var memberBottom = memberHalfH;

    var autoshipR = measureUnfoldedBadgeWrap(assets.autoship);
    var autoshipY = memberBottom + (gaps.memberToAutoship - gaps.memberOverlapAutoship) * mg + autoshipR.height / 2;
    setOffset(assets.autoship, 0, autoshipY);

    var autoshipBottom = autoshipY + autoshipR.height / 2;
    var autoshipTop = autoshipY - autoshipR.height / 2;

    layoutBenefitRow(assets, autoshipBottom, gaps);

    var baseR = measureUnfoldedBadgeWrap(assets.base);
    var baseY = autoshipTop - gaps.autoshipToBase - baseR.height / 2;
    setOffset(assets.base, 0, baseY);

    var calR = measureWrapRect(assets.calendar);
    var memberHeadY = -memberHalfH + memberR.height * (gaps.memberHeadRatio || 0.37);
    var calZone = Scene01Config.layout.calendarZone || 'd5';
    var calLeft = zoneLeftPx(canvas, calZone);
    var calX = offsetXFromAnchor(canvas, Scene01Config.layout.anchorZone, calLeft, calR.width / 2);
    setOffset(assets.calendar, calX, memberHeadY);

    fitGroupScale(canvas, group, inner);
    alignMemberHeadToZoneTop(canvas, group, assets);
    endMeasure();
  }

  function fitGroupScale(canvas, group, inner){
    var safe = window.matchMedia('(max-width:900px)').matches ? 5 : 10;
    var canvasW = canvas.clientWidth - safe * 2;
    var canvasH = canvas.clientHeight - safe * 2;
    var scale = 1;
    var pad = 10;
    var children = inner.querySelectorAll('.scene01-group-child');
    var minX = Infinity;
    var minY = Infinity;
    var maxX = -Infinity;
    var maxY = -Infinity;
    var i;

    for(i = 0; i < children.length; i++){
      var r = children[i].getBoundingClientRect();
      if(r.width < 1 && r.height < 1) continue;
      minX = Math.min(minX, r.left);
      minY = Math.min(minY, r.top);
      maxX = Math.max(maxX, r.right);
      maxY = Math.max(maxY, r.bottom);
    }

    if(!isFinite(minX)) return;

    var boundsW = maxX - minX;
    var boundsH = maxY - minY;

    if(boundsW > canvasW - pad * 2){
      scale = Math.min(scale, (canvasW - pad * 2) / boundsW);
    }
    if(boundsH > canvasH - pad * 2){
      scale = Math.min(scale, (canvasH - pad * 2) / boundsH);
    }

    inner.style.setProperty('--group-scale', String(Math.max(0.5, Math.min(1, scale))));
  }

  function bindResize(canvas, group, assets){
    if(_resizeBound) return;
    _resizeBound = true;
    _ctx = { canvas: canvas, group: group, assets: assets };

    window.addEventListener('resize', scheduleLayout);
  }

  function unbindResize(){
    if(!_resizeBound) return;
    window.removeEventListener('resize', scheduleLayout);
    _resizeBound = false;
    _ctx = null;
  }

  function withBenefitRowMeasure(assets, fn){
    var keys = ['discount','plus','cashback','plusRecommend','recommend'];
    var saved = [];
    var i;

    for(i = 0; i < keys.length; i++){
      var wrap = assets[keys[i]];
      if(!wrap) continue;
      var wasHidden = wrap.classList.contains('is-hidden');
      saved.push({
        wrap: wrap,
        wasHidden: wasHidden,
        prevOpacity: wrap.style.opacity
      });
      wrap.classList.remove('is-hidden');
      if(wasHidden) wrap.style.opacity = '0';
    }

    fn();

    for(i = 0; i < saved.length; i++){
      if(saved[i].prevOpacity) saved[i].wrap.style.opacity = saved[i].prevOpacity;
      else saved[i].wrap.style.removeProperty('opacity');
      if(saved[i].wasHidden) saved[i].wrap.classList.add('is-hidden');
    }
  }

  function relayoutBenefitRowOnly(){
    if(!_ctx || !_ctx.assets || !_ctx.group) return;
    var assets = _ctx.assets;
    var autoshipWrap = assets.autoship;
    if(!autoshipWrap) return;

    withBenefitRowMeasure(assets, function(){
      var y = autoshipWrap.style.getPropertyValue('--offset-y');
      var autoshipY = y ? parseFloat(y) : 0;
      var autoshipR = measureUnfoldedBadgeWrap(autoshipWrap);
      var autoshipBottom = autoshipY + autoshipR.height / 2;
      layoutBenefitRow(assets, autoshipBottom, Scene01Config.layout.gaps);
    });
  }

  function scheduleLayout(full){
    if(!_ctx || _pending) return;
    _pending = true;
    requestAnimationFrame(function(){
      _pending = false;
      if(!_ctx) return;
      if(full === false) relayoutBenefitRowOnly();
      else applyLayout(_ctx.canvas, _ctx.group, _ctx.assets);
    });
  }

  return {
    createGroup: createGroup,
    mountInGroup: mountInGroup,
    mountCalendarInGroup: mountCalendarInGroup,
    applyLayout: applyLayout,
    relayoutBenefitRowOnly: relayoutBenefitRowOnly,
    bindResize: bindResize,
    unbindResize: unbindResize,
    scheduleLayout: scheduleLayout
  };
})();

function setupScene01Assets(canvas){
  Scene01Layout.unbindResize();

  var cfg = Scene01Config.layout;
  var S = cfg.scales;
  var group = Scene01Layout.createGroup(canvas, cfg.anchorZone);

  var assets = {
    group: group,
    member: Scene01Layout.mountInGroup(canvas, group, 'member_icon', 's01-member', {
      scale: S.member,
      extraCls: 'g01-layer-front scene01-member-anchor'
    }, false),
    autoship: Scene01Layout.mountInGroup(canvas, group, 'autoship_icon', 's01-autoship', {
      scale: S.autoship
    }, true),
    calendar: Scene01Layout.mountInGroup(canvas, group, 'calendar_month_card', 's01-calendar', {
      scale: S.calendar
    }, false),
    plus: Scene01Layout.mountInGroup(canvas, group, 'effect_plus_icon', 's01-plus-benefit', {
      scale: S.plus
    }, false),
    discount: Scene01Layout.mountInGroup(canvas, group, 'discount_benefit_icon', 's01-discount', {
      scale: S.discount
    }, true),
    cashback: Scene01Layout.mountInGroup(canvas, group, 'cashback_icon', 's01-cashback', {
      scale: S.cashback
    }, true),
    plusRecommend: Scene01Layout.mountInGroup(canvas, group, 'effect_plus_icon', 's01-plus-recommend', {
      scale: S.plus
    }, false),
    recommend: Scene01Layout.mountInGroup(canvas, group, 'recommend_bonus_icon', 's01-recommend', {
      scale: S.recommend
    }, true),
    base: Scene01Layout.mountInGroup(canvas, group, 'base_business_icon', 's01-base', {
      scale: S.base,
      extraCls: 'g01-layer-front'
    }, true)
  };

  Scene01Layout.applyLayout(canvas, group, assets);
  Scene01Layout.bindResize(canvas, group, assets);

  return assets;
}

</script>
