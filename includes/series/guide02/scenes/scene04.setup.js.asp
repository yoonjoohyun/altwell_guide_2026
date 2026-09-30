<script>
var Guide02Scene04Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    if(!canvas || !inner || !stage) return;
    var w = stage.offsetWidth || 1;
    var h = stage.offsetHeight || 1;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.42) fit = 0.42;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function schedule(){
    requestAnimationFrame(applyFit);
  }

  function bind(ctx){
    _ctx = ctx;
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', schedule);
  }

  function unbind(){
    _resizeBound = false;
    _ctx = null;
  }

  return { schedule: schedule, bind: bind, unbind: unbind };
})();

function setupGuide02Scene04(canvas){
  var zone = Guide02Scene04Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');

  function slot(templateId, id){
    var node = Guide02.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden';
    if(node) wrap.appendChild(node);
    return wrap;
  }

  stack.id = 'g02-s04-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s04';

  var badge = slot('startpack_badge', 'g02-s04-badge');
  var summary = slot('startpack_price_summary', 'g02-s04-summary');
  var bundle = slot('startpack_bundle_benefit', 'g02-s04-bundle');
  var ep = slot('startpack_ep_emphasis', 'g02-s04-ep');
  var coins = Guide02.cloneTemplate('startpack_ep_coins');
  var epBox = ep.querySelector('.g02_ep_emphasis');
  var epTitle = ep.querySelector('.g02_ep_title');
  if(coins && epBox && epTitle) epBox.insertBefore(coins, epTitle);

  stage.appendChild(badge);
  stage.appendChild(summary);
  stage.appendChild(bundle);
  stage.appendChild(ep);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene04Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide02Scene04Layout.schedule();

  return {
    badge: badge,
    badgeRoot: badge.querySelector('.g02_startpack_badge'),
    summary: summary,
    rows: summary.querySelectorAll('.g02_price_row'),
    bundle: bundle,
    bundleLines: bundle.querySelectorAll('.g02_bundle_kicker, .g02_bundle_value'),
    coins: coins,
    coinA: coins.querySelector('[data-coin="a"]'),
    coinB: coins.querySelector('[data-coin="b"]'),
    coinSum: coins.querySelector('[data-coin="sum"]'),
    ep: ep
  };
}
</script>
