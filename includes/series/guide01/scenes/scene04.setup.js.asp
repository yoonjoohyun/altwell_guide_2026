<script>
/* guide01 Scene 04 — 결제·배송 + 캘린더 분할·통합 */
var Scene04Layout = (function(){
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
    wrap.style.setProperty('--s04-slot-scale', String(scale));
  }

  function cloneFromTemplate(templateId){
    var host = document.querySelector('#guide01-templates [data-template="' + templateId + '"]');
    if(!host || !host.firstElementChild) return null;
    return host.firstElementChild.cloneNode(true);
  }

  function createGroup(canvas, zone){
    var group = document.createElement('div');
    group.id = 's04-stack-group';
    group.className = 'g01-zone-wrap scene04-stack-group is-hidden';
    Guide01.placeAtZone(group, zone);

    var inner = document.createElement('div');
    inner.className = 'scene04-group-inner';
    group.appendChild(inner);
    group._scene04Inner = inner;

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
    wrap.classList.add('scene04-group-child', 's04-layout-instant');
    inner.appendChild(wrap);
    return wrap;
  }

  function mountFloatChild(inner, elId, node, scale){
    var wrap = document.createElement('div');
    wrap.id = elId;
    wrap.className = 's04-float-wrap scene04-group-child s04-layout-instant is-hidden';

    var floatInner = document.createElement('div');
    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String(scale || 1));
    floatInner.style.transform = 'scale(' + (scale || 1) + ')';

    if(node){
      node.classList.add('guide01-asset');
      floatInner.appendChild(node);
    }
    wrap.appendChild(floatInner);
    inner.appendChild(wrap);
    return wrap;
  }

  function mountPayDelCluster(inner){
    var cluster = document.createElement('div');
    cluster.id = 's04-pay-del-cluster';
    cluster.className = 's04-pay-del-cluster scene04-group-child g01-float-host s04-layout-instant is-hidden';

    var row = document.createElement('div');
    row.className = 's04-pay-del-row';

    var payment = cloneFromTemplate('payment_batch_box');
    var delivery = cloneFromTemplate('delivery_batch_box');

    var installmentHost = document.createElement('div');
    installmentHost.id = 's04-installment-host';
    installmentHost.className = 's04-installment-host is-hidden';

    if(payment){
      payment.id = 's04-payment-box';
      payment.classList.add('guide01-asset');
      var cardSlot = payment.querySelector('.pbb_card-slot');
      if(cardSlot){
        cardSlot.insertBefore(installmentHost, cardSlot.firstChild);
      }else{
        payment.appendChild(installmentHost);
      }
      row.appendChild(payment);
    }
    if(delivery){
      delivery.id = 's04-delivery-box';
      delivery.classList.add('guide01-asset', 's04-delivery-pending', 'is-hidden');
      row.appendChild(delivery);
      delivery._deliveryProducts = mountDeliveryProducts(delivery, (Scene04Config.layout.scales && Scene04Config.layout.scales.deliveryProduct) || 1);
    }

    var floatInner = document.createElement('div');
    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', '1');
    floatInner.style.transform = 'scale(1)';
    floatInner.appendChild(row);
    cluster.appendChild(floatInner);
    cluster._float = floatInner;

    inner.appendChild(cluster);
    return cluster;
  }

  function mountDeliveryProducts(deliveryBox, scale){
    var stack = deliveryBox && deliveryBox.querySelector('.s04-delivery-products');
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

      wrap = document.createElement('div');
      wrap.className = 'g01-zone-wrap s04-delivery-product-wrap is-hidden';
      wrap.setAttribute('data-index', String(i));

      floatInner = document.createElement('div');
      floatInner.className = 'g01-float-inner';
      floatInner.style.setProperty('--g01-base-scale', String(scale));
      floatInner.style.transform = 'scale(' + scale + ')';

      scene04ConfigureProductBox(node, 'A');
      floatInner.appendChild(node);
      wrap.appendChild(floatInner);
      track.appendChild(wrap);
      products.push(wrap);
    }

    return products;
  }

  function wrapFlowMonthSlots(flow){
    var track = flow && flow.querySelector('.subscription_flow_track');
    var nodes = [];
    var monthIndex = 0;
    var i;
    var node;
    var slot;
    var coin;

    if(!track || track.dataset.s04MonthSlots === '1') return;

    for(i = 0; i < track.childNodes.length; i++){
      if(track.childNodes[i].nodeType === 1) nodes.push(track.childNodes[i]);
    }

    track.textContent = '';

    for(i = 0; i < nodes.length; i++){
      node = nodes[i];
      if(node.classList.contains('subscription_flow_month')){
        slot = document.createElement('div');
        slot.className = 's04-flow-month-slot';
        slot.setAttribute('data-month-index', String(monthIndex));
        node.classList.remove('is_next');
        slot.appendChild(node);

        coin = document.createElement('div');
        coin.className = 's04-flow-payment-coin is-hidden';
        coin.innerHTML = '<span class="s04-flow-payment-coin-inner">결제</span>';
        slot.appendChild(coin);

        track.appendChild(slot);
        monthIndex++;
      }else if(!node.classList.contains('subscription_flow_line')){
        track.appendChild(node);
      }
    }

    track.dataset.s04MonthSlots = '1';
  }

  function mountCalendarWrap(inner){
    var wrap = document.createElement('div');
    wrap.id = 's04-calendar-wrap';
    wrap.className = 's04-calendar-wrap scene04-group-child g01-float-host s04-layout-instant is-hidden';

    var floatInner = document.createElement('div');
    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String((Scene04Config.layout.scales && Scene04Config.layout.scales.calendar) || 1));
    floatInner.style.transform = 'scale(' + ((Scene04Config.layout.scales && Scene04Config.layout.scales.calendar) || 1) + ')';

    var flow = cloneFromTemplate('subscription_flow_card');
    if(flow){
      flow.id = 's04-subscription-flow';
      flow.classList.add('guide01-asset', 's04-subscription-flow');
      wrapFlowMonthSlots(flow);
      floatInner.appendChild(flow);
    }

    wrap.appendChild(floatInner);
    wrap._float = floatInner;
    inner.appendChild(wrap);
    return wrap;
  }

  function localSizeFromRect(rect, inner){
    var gs = parseFloat(inner.style.getPropertyValue('--group-scale')) || 1;
    return { width: rect.width / gs, height: rect.height / gs };
  }

  function measureWrap(wrap, inner){
    var floatInner;
    var asset;
    var target;

    if(!wrap) return { width: 0, height: 0 };

    floatInner = wrap.querySelector('.g01-float-inner');
    target = floatInner || wrap;
    asset = target.querySelector(':scope > .guide01-asset');
    if(asset) target = asset;

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
    return ['autoship', 'payDelCluster', 'calendarWrap'];
  }

  function gapAfterKey(prevKey, gaps){
    if(prevKey === 'autoship') return gaps.autoshipPayment != null ? gaps.autoshipPayment : 18;
    if(prevKey === 'payDelCluster') return gaps.payDelCalendar != null ? gaps.payDelCalendar : 14;
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
    var wrap = assets[key];
    if(!wrap || !isWrapVisible(wrap)) return null;

    if(key === 'autoship' || key === 'calendarWrap'){
      return { key: key, wrap: wrap, size: measureWrap(wrap, inner) };
    }
    return { key: key, wrap: wrap, size: measureBlock(wrap, inner) };
  }

  function fitGroupScale(canvas, inner){
    var scales = Scene04Config.layout.scales || {};
    var minScale = scales.minFit != null ? scales.minFit : 0.42;
    var pad = 12;
    var canvasW = canvas.clientWidth - pad * 2;
    var canvasH = canvas.clientHeight - pad * 2;
    var children = inner.querySelectorAll('.scene04-group-child:not(.is-hidden)');
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

    if(boundsW > 0 && boundsW > canvasW){
      scale = Math.min(scale, canvasW / boundsW);
    }
    if(boundsH > 0 && boundsH > canvasH){
      scale = Math.min(scale, canvasH / boundsH);
    }

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

    var inner = group._scene04Inner;
    if(!inner) return;

    var gaps = Scene04Config.layout.gaps || {};
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
    mountFloatChild: mountFloatChild,
    mountPayDelCluster: mountPayDelCluster,
    mountCalendarWrap: mountCalendarWrap,
    applyLayout: applyLayout,
    scheduleLayout: scheduleLayout,
    bindResize: bindResize,
    unbindResize: unbindResize,
    cloneFromTemplate: cloneFromTemplate,
    ensureFlowMonthSlots: wrapFlowMonthSlots
  };
})();

function setupScene04Assets(canvas){
  Scene04Layout.unbindResize();

  var S = Scene04Config.layout.scales || {};
  var group = Scene04Layout.createGroup(canvas, Scene04Config.layout.anchorZone);
  var inner = group._scene04Inner;

  var autoshipWrap = Guide01.addZonedBadge(canvas, 'autoship_icon', 's04-autoship', Scene04Config.layout.anchorZone, {
    scale: S.autoship != null ? S.autoship : 1
  });
  Scene04Layout.reparentAsChild(autoshipWrap, inner);

  var payDelCluster = Scene04Layout.mountPayDelCluster(inner);
  var calendarWrap = Scene04Layout.mountCalendarWrap(inner);

  var paymentBox = payDelCluster.querySelector('#s04-payment-box');
  var deliveryBox = payDelCluster.querySelector('#s04-delivery-box');
  var deliveryProducts = (deliveryBox && deliveryBox._deliveryProducts) || [];
  var subscriptionFlow = calendarWrap.querySelector('#s04-subscription-flow');
  var installmentHost = payDelCluster.querySelector('#s04-installment-host');
  var assets = {
    group: group,
    autoship: autoshipWrap,
    payDelCluster: payDelCluster,
    paymentBox: paymentBox,
    deliveryBox: deliveryBox,
    deliveryProducts: deliveryProducts,
    installmentHost: installmentHost,
    calendarWrap: calendarWrap,
    subscriptionFlow: subscriptionFlow
  };

  Scene04Layout.applyLayout(canvas, group, assets);
  Scene04Layout.bindResize(canvas, group, assets);

  requestAnimationFrame(function(){
    var children = group.querySelectorAll('.scene04-group-child');
    for(var i = 0; i < children.length; i++){
      children[i].classList.remove('s04-layout-instant');
    }
  });

  return assets;
}

function scene04ConfigureProductBox(box, letter){
  if(!box) return;
  box.textContent = letter;
  box.classList.add('guide01-asset', 's04-delivery-product-box');
  box.setAttribute('aria-label', '품목 ' + letter);
}

</script>
