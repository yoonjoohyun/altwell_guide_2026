<script>
var Guide02Scene07Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function heroVisible(el){
    return !!(el && el.isConnected && !el.classList.contains('is-hidden'));
  }

  function fitHero(canvas, inner, hero){
    var w = hero.offsetWidth || 0;
    var h = hero.offsetHeight || 0;
    var fit;
    if(w < 2 || h < 2 || !canvas.clientWidth || !canvas.clientHeight) return;
    fit = Math.min((canvas.clientWidth * 0.5) / w, (canvas.clientHeight * 0.5) / h);
    if(!(fit > 0)) return;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function applyFit(){
    if(!_ctx) return;
    if(heroVisible(_ctx.badge)){
      fitHero(_ctx.canvas, _ctx.inner, _ctx.badge);
      return;
    }
    if(heroVisible(_ctx.benefit)){
      fitHero(_ctx.canvas, _ctx.inner, _ctx.benefit);
      return;
    }
    Guide02.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, 0.85);
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

  return { schedule: schedule, flush: applyFit, bind: bind, unbind: unbind };
})();

function setupGuide02Scene07(canvas){
  var zone = Guide02Scene07Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');

  function slot(id, cls){
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden' + (cls ? ' ' + cls : '');
    return wrap;
  }

  function orb(id, html){
    var wrap = slot(id, 'g02-s07-orb-host');
    var face = document.createElement('div');
    var text = document.createElement('div');
    face.className = 'g02-s07-orb';
    text.className = 'g02-s07-orb-text is-hidden';
    text.innerHTML = html;
    face.appendChild(text);
    wrap.appendChild(face);
    return { wrap: wrap, face: face, text: text };
  }

  stack.id = 'g02-s07-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s07';

  var badge = slot('g02-s07-badge');
  var badgeNode = Guide02.cloneTemplate('startpack_badge');
  if(badgeNode) badge.appendChild(badgeNode);

  var benefit = slot('g02-s07-benefit', 'g02-s07-benefit');
  benefit.textContent = '높은 할인 혜택';

  var orb1 = orb('g02-s07-orb1', '앨트웰<br>주요 제품 경험');
  var orb2 = orb('g02-s07-orb2', '높은 제품 이해도<br>*추천 활동');
  var orb3 = orb('g02-s07-orb3', '승급↑<br>&amp;<br>앨트웰 비즈니스');
  var line1 = slot('g02-s07-line1', 'g02-s07-link');
  var line2 = slot('g02-s07-line2', 'g02-s07-link');
  var row = document.createElement('div');
  row.className = 'g02-s07-row';

  row.appendChild(orb1.wrap);
  row.appendChild(line1);
  row.appendChild(orb2.wrap);
  row.appendChild(line2);
  row.appendChild(orb3.wrap);
  stage.appendChild(badge);
  stage.appendChild(benefit);
  stage.appendChild(row);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  lockGuide02Scene07RowSize(row);

  Guide02Scene07Layout.bind({ canvas: canvas, inner: inner, stage: stage, badge: badge, benefit: benefit });
  Guide02Scene07Layout.schedule();

  return {
    badge: badge,
    badgeRoot: badge.querySelector('.g02_startpack_badge'),
    benefit: benefit,
    row: row,
    orbs: [orb1, orb2, orb3],
    lines: [line1, line2]
  };
}

function lockGuide02Scene07RowSize(row){
  var nodes = row.children;
  var hidden = [];
  var i;
  var w;
  var h;
  if(!row || !nodes.length) return;
  for(i = 0; i < nodes.length; i++){
    hidden[i] = nodes[i].classList.contains('is-hidden');
    nodes[i].classList.remove('is-hidden');
    nodes[i].style.visibility = 'hidden';
  }
  w = row.scrollWidth;
  h = row.scrollHeight;
  for(i = 0; i < nodes.length; i++){
    nodes[i].style.visibility = '';
    if(hidden[i]) nodes[i].classList.add('is-hidden');
  }
  row.style.setProperty('--g02-s07-row-min-width', w + 'px');
  row.style.setProperty('--g02-s07-row-min-height', h + 'px');
}
</script>
