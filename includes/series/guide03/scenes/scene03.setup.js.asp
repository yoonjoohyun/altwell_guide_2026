<script>
var Guide03Scene03Layout = (function(){
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

function setupGuide03Scene03(canvas){
  var zone = Guide03Scene03Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var memberWrap = document.createElement('div');
  var iconWrap = document.createElement('div');
  var dock = document.createElement('div');
  var side = document.createElement('div');
  var sep = document.createElement('div');
  var pie = document.createElement('div');
  var core = document.createElement('div');
  var sliceLabel = document.createElement('div');

  stack.id = 'g03-s03-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s03';
  memberWrap.className = 'g03-s03-member';
  iconWrap.className = 'g03-member g03-slot is-hidden';
  dock.className = 'g03-s03-dock';
  side.className = 'g03-s03-side';

  var icon = Guide03.cloneTemplate('member_base_self');
  if(icon) iconWrap.appendChild(icon);

  var badge = Guide03.cloneTemplate('base_business_icon');
  var badgeWrap = document.createElement('div');
  badgeWrap.id = 'g03-s03-badge';
  badgeWrap.className = 'g03-slot g03-s03-badge is-hidden';
  if(badge){
    badge.classList.remove('base_business_icon_o');
    badge.classList.add('base_business_icon_c');
    badgeWrap.appendChild(badge);
  }

  sep.id = 'g03-s03-sep';
  sep.className = 'g03-slot g03-s03-sep is-hidden';
  pie.className = 'g03-s03-pie';
  core.className = 'g03-s03-sep-core';
  core.innerHTML = '매월 SEP<br>30만 이상';
  sliceLabel.id = 'g03-s03-slice-label';
  sliceLabel.className = 'g03-s03-slice-label g03-slot is-hidden';
  sliceLabel.innerHTML = '오토십<br>1개 이상';
  sep.appendChild(pie);
  sep.appendChild(core);
  sep.appendChild(sliceLabel);

  var auto = Guide03.cloneTemplate('autoship_icon');
  var autoWrap = document.createElement('div');
  autoWrap.id = 'g03-s03-auto';
  autoWrap.className = 'g03-slot g03-s03-auto is-hidden';
  if(auto){
    var autoText = auto.querySelector('.autoship_text');
    if(autoText) autoText.textContent = '오토십 구독 1개 이상';
    auto.setAttribute('aria-label', '오토십 구독 1개 이상');
    autoWrap.appendChild(auto);
  }

  memberWrap.appendChild(iconWrap);
  dock.appendChild(badgeWrap);
  memberWrap.appendChild(dock);
  side.appendChild(sep);
  side.appendChild(autoWrap);
  stage.appendChild(memberWrap);
  stage.appendChild(side);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene03Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene03Layout.schedule();

  return {
    inner: inner,
    member: iconWrap,
    badge: badgeWrap,
    sep: sep,
    sliceLabel: sliceLabel,
    autoship: autoWrap
  };
}
</script>
