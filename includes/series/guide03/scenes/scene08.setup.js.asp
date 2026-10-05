<script>
var Guide03Scene08Layout = (function(){
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
    if(fit < 0.4) fit = 0.4;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function schedule(){ requestAnimationFrame(applyFit); }

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

  return { schedule: schedule, bind: bind, unbind: unbind, scale: function(){
    var inner = _ctx && _ctx.inner;
    var value = inner && parseFloat(inner.style.getPropertyValue('--group-scale'));
    return value > 0 ? value : 1;
  }};
})();

function setupGuide03Scene08(canvas){
  function piece(node, extra){
    var wrap = document.createElement('div');
    wrap.className = 'g03-s08-piece g03-slot is-hidden' + (extra ? ' ' + extra : '');
    if(node) wrap.appendChild(node);
    return wrap;
  }

  function bonus(letter, label, extra){
    var icon = Guide03.cloneTemplate('recommend_bonus_icon');
    var mark;
    var text;
    if(icon && letter){
      mark = icon.querySelector('.recommend_bonus_label');
      text = icon.querySelector('.recommend_bonus_text');
      if(mark) mark.textContent = letter;
      if(text) text.textContent = label;
      icon.setAttribute('aria-label', label);
    }
    return piece(icon, extra);
  }

  var zone = Guide03Scene08Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var badgeWrap = document.createElement('div');
  var badge = Guide03.cloneTemplate('base_business_icon');
  var hold = document.createElement('div');
  var list = document.createElement('div');
  var recommend = bonus('', '', '');
  var matching = bonus('M', '매칭 보너스', 'g03-s08-match');
  var support = bonus('B', '후원 보너스', 'g03-s08-support');
  var track = document.createElement('div');
  var trackWrap;
  var orb = document.createElement('div');
  var orbText = document.createElement('div');

  stack.id = 'g03-s08-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s08';
  badgeWrap.className = 'g03-s08-base g03-slot is-hidden';
  if(badge) badgeWrap.appendChild(badge);
  hold.className = 'g03-s08-hold';
  list.className = 'g03-s08-list g03-slot';
  track.className = 'g03-s08-track';
  track.textContent = '2TRACK 승급 조건';
  trackWrap = piece(track, '');
  list.appendChild(recommend);
  list.appendChild(matching);
  list.appendChild(support);
  list.appendChild(trackWrap);
  orb.className = 'g03-s08-orb g03-slot is-hidden';
  orbText.className = 'g03-s08-orb-text';
  orbText.innerHTML = '보상과 승급<br>&<br>비즈니스 핵심';
  orb.appendChild(orbText);
  hold.appendChild(list);
  hold.appendChild(orb);
  stage.appendChild(badgeWrap);
  stage.appendChild(hold);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene08Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene08Layout.schedule();

  return {
    badge: badgeWrap,
    pieces: [recommend, matching, support, trackWrap],
    hold: hold,
    list: list,
    orb: orb,
    orbText: orbText
  };
}
</script>
