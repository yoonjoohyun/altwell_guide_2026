<script>
var Guide03Scene09Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    var w;
    var h;
    if(!canvas || !inner || !stage) return;
    w = stage.offsetWidth || 1;
    h = stage.offsetHeight || 1;
    if(w < 2 || h < 2) return;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.36) fit = 0.36;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
    if(_ctx.redraw) _ctx.redraw();
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

function setupGuide03Scene09(canvas){
  var zone = Guide03Scene09Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var tree = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var arrowHost = document.createElement('div');
  var arrow = document.createElement('div');
  var links = [];

  function grow(child){
    var slot = document.createElement('div');
    var clip = document.createElement('div');
    slot.className = 'g03-grow';
    clip.className = 'g03-grow-clip';
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function person(templateId){
    var icon = Guide03.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    var col = document.createElement('div');
    var kids = document.createElement('div');
    wrap.className = 'g03-member';
    col.className = 'g03-s09-col';
    kids.className = 'g03-s09-kids';
    if(icon){
      icon.innerHTML = '';
      wrap.appendChild(icon);
    }
    var badge = Guide03.cloneTemplate('base_business_icon');
    var badgeHost = document.createElement('div');
    badgeHost.className = 'g03-s09-badge is-hidden';
    if(badge){
      badge.classList.remove('base_business_icon_o');
      badge.classList.add('base_business_icon_c');
      badgeHost.appendChild(badge);
    }
    wrap.appendChild(badgeHost);
    col.appendChild(grow(wrap));
    col.appendChild(kids);
    return { col: col, grow: col.children[0], icon: icon, kids: kids };
  }

  function link(from, to){
    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('fill', 'none');
    lines.appendChild(path);
    links.push({ from: from, to: to, path: path, on: false, drawn: false });
  }

  var self = person('member_icon');
  var row2 = [person('member_base_partner'), person('member_base_partner')];
  var row3 = [
    person('member_base_partner'),
    person('member_base_partner'),
    person('member_base_partner'),
    person('member_base_partner')
  ];
  var row4 = [
    person('member_base_partner'),
    person('member_base_partner'),
    person('member_base_partner'),
    person('member_base_partner')
  ];

  row2[0].kids.appendChild(row3[0].col);
  row2[0].kids.appendChild(row3[1].col);
  row2[1].kids.appendChild(row3[2].col);
  row2[1].kids.appendChild(row3[3].col);
  row3[0].kids.appendChild(row4[0].col);
  row3[0].kids.appendChild(row4[1].col);
  row3[2].kids.appendChild(row4[2].col);
  row3[2].kids.appendChild(row4[3].col);
  self.kids.appendChild(row2[0].col);
  self.kids.appendChild(row2[1].col);

  link(self, row2[0]);
  link(self, row2[1]);
  link(row2[0], row3[0]);
  link(row2[0], row3[1]);
  link(row2[1], row3[2]);
  link(row2[1], row3[3]);
  link(row3[0], row4[0]);
  link(row3[0], row4[1]);
  link(row3[2], row4[2]);
  link(row3[2], row4[3]);

  stack.id = 'g03-s09-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s09';
  tree.className = 'g03-s09-tree';
  lines.setAttribute('class', 'g03-lines');
  lines.setAttribute('aria-hidden', 'true');
  arrowHost.className = 'g03-s09-arrow-host';
  arrow.className = 'g03-s09-arrow';
  arrow.setAttribute('aria-hidden', 'true');
  arrowHost.appendChild(arrow);
  tree.appendChild(lines);
  tree.appendChild(self.col);
  stage.appendChild(tree);
  stage.appendChild(arrowHost);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  var assets = {
    stage: stage,
    tree: tree,
    lines: lines,
    links: links,
    self: self,
    row2: row2,
    row3: row3,
    row4: row4,
    arrow: arrow
  };

  Guide03Scene09Layout.bind({
    canvas: canvas,
    inner: inner,
    stage: stage,
    redraw: function(){ guide03Scene09Draw(assets, false); }
  });
  Guide03Scene09Layout.schedule();
  return assets;
}
</script>
