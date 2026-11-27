<script>
var Guide05Scene05Layout = G04Kit.makeLayout();

function setupGuide05Scene05(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide05Scene05Config.layout.anchorZone);
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  m.stage._g04MaxScale = 1.6;
  m.stage._g04GroupInset = 0.94;
  var phaseA = K.el('div', 'g04-phase g05-s05-org');
  var tree = K.el('div', 'g05-s05-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 14);
  var i;

  /* 에셋은 자리를 미리 잡고 투명 -> 팝업으로 등장시킨다 (그로우 슬롯 클립 방식 사용 안 함) */
  function mk(id, kind, size, withCap){
    var mem = K.member({ id: id, label: kind === 'self' ? '본인' : '', kind: kind === 'plain' ? 'partner' : kind, size: size });
    var cap = null;
    if(kind === 'plain'){
      mem.icon.classList.remove('member_base_partner');
      mem.icon.classList.add('g04-nobase');
    }
    if(withCap){
      cap = G05.baseCap(mem, true, false);
      if(withCap === 'hidden') cap.classList.add('g05-ph');
    }
    mem.wrap.classList.add('g05-ph');
    return { mem: mem, cap: cap };
  }
  function pov(o, kind, docked){
    var w = K.el('div', 'g05-pov ' + (kind === 'pack' ? 'is-pack' : 'is-auto') + (docked ? ' is-in is-fold is-docked' : ''));
    w.appendChild(K.product(kind, { mini: true, hidden: false }));
    o.mem.wrap.appendChild(w);
    return w;
  }
  function cell(o, row, c1, span, extra){
    var cl = K.el('div', 'g05-s05-cell');
    cl.style.gridRow = String(row);
    cl.style.gridColumn = c1 + ' / span ' + span;
    cl.appendChild(o.mem.wrap);
    if(extra) cl.appendChild(extra);
    tree.appendChild(cl);
    return cl;
  }
  function bonus(tid){
    var w = K.el('div', 'g05-cmp-badge is-small g05-ph');
    var n = Guide04.cloneTemplate(tid);
    if(n) w.appendChild(n);
    return w;
  }

  /* 7명 구조: 본인 1 - 하위 2 - 그 아래 4 */
  var self = mk('g05-s05-self', 'self', 'sm', true);
  var n = [mk('g05-s05-n1', 'plain', 'sm', 'hidden'), mk('g05-s05-n2', 'plain', 'sm', 'hidden')];
  var mm = [];
  for(i = 0; i < 4; i++) mm.push(mk('g05-s05-m' + i, 'plain', 'sm', 'hidden'));
  var pn = n.map(function(o){ return { auto: pov(o, 'auto'), pack: pov(o, 'pack') }; });
  var pm = mm.map(function(o){ return { auto: pov(o, 'auto'), pack: pov(o, 'pack') }; });
  var kk = [];
  for(i = 0; i < 8; i++) kk.push(mk('g05-s05-k' + i, 'partner', 'xs', false));
  kk.forEach(function(o){ pov(o, 'auto', true); pov(o, 'pack', true); });
  var recB = bonus('recommend_bonus_icon');
  var matchB = bonus('matching_bonus_icon');
  var side = K.el('div', 'g05-s05-side');
  side.appendChild(recB);
  side.appendChild(matchB);

  tree.appendChild(svg);
  cell(self, 1, 3, 4, side);
  cell(n[0], 2, 1, 4, null);
  cell(n[1], 2, 5, 4, null);
  for(i = 0; i < 4; i++) cell(mm[i], 3, i * 2 + 1, 2, null);
  for(i = 0; i < 8; i++) cell(kk[i], 4, i + 1, 1, null).classList.add('is-k');
  phaseA.appendChild(tree);

  /* 4단계 플로우 */
  var fl = {};
  var flow = K.threeSlots([
    { no: 1, text: '신규 등록', build: function(body){
        var nm = K.member({ label: '', kind: 'plain' });
        nm.icon.classList.add('g04-nobase');
        nm.wrap.classList.add('is-xl');
        body.appendChild(nm.wrap);
        fl.m1 = nm;
      } },
    { no: 2, text: '제품 이용', build: function(body){
        var col = K.el('div', 'g05-s05-useboard');
        var nm = K.member({ label: '신규', kind: 'new' });
        nm.wrap.classList.add('is-big');
        var auto = K.product('auto', { hidden: false, mini: true });
        var pack = K.product('pack', { hidden: false, mini: true });
        auto.classList.add('g05-ph', 'g05-pull'); pack.classList.add('g05-ph', 'g05-pull');
        col.appendChild(nm.wrap);
        col.appendChild(auto);
        col.appendChild(pack);
        body.appendChild(col);
        fl.auto = auto; fl.pack = pack;
      } },
    { no: 3, text: 'Base 사업자 성장', build: function(body){
        var bm = K.member({ label: '신규', kind: 'new' });
        bm.wrap.classList.add('is-big');
        fl.m3cap = G05.baseCap(bm, true, false);
        fl.m3cap.classList.add('g05-ph', 'g05-pull');
        fl.m3cap.style.setProperty('--pull', '-20px');
        body.appendChild(bm.wrap);
        fl.m3 = bm;
      } },
    { no: 4, text: '유지·파트너 육성', build: function(body){
        var col = K.el('div', 'g05-s05-trio');
        var up = K.member({ label: '', kind: 'self', size: 'xs' });
        var upCap = G05.baseCap(up, true, false);
        upCap.classList.add('is-bfold');
        var row = K.el('div', 'g05-s05-mini g05-pullrow g05-ph');
        fl.row4 = row;
        var a = K.member({ label: '신규', kind: 'new', size: 'xs' });
        var b = K.member({ label: '신규', kind: 'new', size: 'xs' });
        fl.m4 = [a, b];
        fl.m4cap = [G05.baseCap(a, true, false), G05.baseCap(b, true, false)];
        fl.m4cap[0].classList.add('g05-ph', 'is-bfold');
        fl.m4cap[1].classList.add('g05-ph', 'is-bfold');
        row.appendChild(a.wrap);
        row.appendChild(b.wrap);
        col.appendChild(up.wrap);
        col.appendChild(row);
        body.appendChild(col);
      } }
  ], 'g04-sum g04-phase g05-s05-flow is-hidden');
  var keyChip = K.grow(K.chip('추천보너스 · 매칭보너스 확대의 핵심', 'is-red g05-wide'));

  board.id = 'g05-s05-board';
  for(i = 0; i < flow.slots.length; i++) flow.slots[i].classList.add('g04-slot', 'is-hidden');
  flow.host.classList.remove('is-hidden');

  board.appendChild(keyChip);
  board.appendChild(phaseA);
  board.appendChild(flow.host);
  m.stage.appendChild(board);

  Guide05Scene05Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: null });
  Guide05Scene05Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, board: board, phaseA: phaseA, tree: tree, svg: svg, paths: paths,
    self: self, n: n, m: mm, k: kk, pn: pn, pm: pm, recB: recB, matchB: matchB,
    flow: flow, fl: fl, keyChip: keyChip
  };
}
</script>
