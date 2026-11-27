<script>
var Guide05Scene06Layout = G04Kit.makeLayout();

function setupGuide05Scene06(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide05Scene06Config.layout.anchorZone);
  var badge = K.titleBadge('matching_bonus_icon', 'g05-s06-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var i;

  /* 국면 A: 본인 = Base 사업자 + SP 이상 */
  var phaseA = K.el('div', 'g04-phase g05-s06-a');
  var self = K.member({ id: 'g05-s06-self', label: '본인', cap: 'x', kind: 'self' });
  var selfCap = G05.baseCap(self, false, false);
  var selfMedal = G05.chestMedal(self.fig, 'lev_sp', 'SP');
  var keepChip = K.grow(K.chip('Base 사업자 유지 + SP 이상 지위'));
  selfMedal.appendChild(G05.arrowUp());

  /* 국면 B: 지위별 포인트 */
  var phaseB = K.el('div', 'g04-phase g05-s06-b is-hidden');
  var rates = K.el('div', 'g05-rates');
  var rateSlots = [];
  var rateLabel = K.chip('하위 Base 사업자 1명당', 'is-sm');
  [
    { meds: [['lev_sp', 'SP']], pt: 3 },
    { meds: [['lev_fc', 'FC']], pt: 4 },
    { meds: [['lev_gc', 'GC'], ['lev_dc', 'DC'], ['lev_rf', 'RF']], pt: 5 }
  ].forEach(function(r){
    var card = K.el('div', 'g05-rate');
    var meds = K.el('div', 'g05-rate-meds');
    r.meds.forEach(function(p){
      var node = Guide04.cloneTemplate(p[0]);
      if(node) meds.appendChild(node);
    });
    card.appendChild(meds);
    card.appendChild(K.chip(r.pt + ' 포인트', 'is-sm'));
    card.setAttribute('aria-label', r.meds.map(function(p){ return p[1]; }).join('·') + ' ' + r.pt + '포인트');
    rateSlots.push(K.grow(card));
    rates.appendChild(rateSlots[rateSlots.length - 1]);
  });
  phaseB.appendChild(rateLabel);
  phaseB.appendChild(rates);

  /* 공통: 자리를 미리 잡고 투명 -> 팝업으로 등장 (그로우 슬롯 클립 방식 사용 안 함) */
  function mk(id, kind, medalId, medalText){
    var mem = K.member({ id: id, label: kind === 'self' ? '본인' : '', kind: kind, size: 'sm' });
    G05.baseCap(mem, true, false);
    if(medalId) G05.chestMedal(mem.fig, medalId, medalText).classList.remove('is-hidden');
    mem.wrap.classList.add('g05-ph');
    return mem;
  }
  function cellOf(host, mem, row, c1, span, extra){
    var cl = K.el('div', 'g05-s05-cell');
    cl.style.gridRow = String(row);
    cl.style.gridColumn = c1 + ' / span ' + span;
    cl.appendChild(mem.wrap);
    if(extra) cl.appendChild(extra);
    host.appendChild(cl);
    return cl;
  }
  function phWrap(node, cls){
    var w = K.el('div', 'g05-ph' + (cls ? ' ' + cls : ''));
    w.appendChild(node);
    return w;
  }
  function mkTag(label){
    var t = K.tag(0);
    K.tagLabel(t, label);
    t.tagNode.querySelector('.referral_point_tag_unit').textContent = '포인트';
    return t;
  }

  /* 국면 C: 피라미드 (본인 - 2단 - 3단) 에서 제외 대상 표시 */
  var phaseC = K.el('div', 'g04-phase g05-s06-c is-hidden');
  var cTree = K.el('div', 'g05-s06-tree');
  var cSvg = K.svgLayer();
  var cPaths = K.addPaths(cSvg, 6);
  var cSelf = mk('g05-s06-cs', 'self', 'lev_sp', 'SP');
  var cL1 = mk('g05-s06-cl1', 'partner');
  var cR1 = mk('g05-s06-cr1', 'partner', 'lev_sp', 'SP');
  var cK = [];
  for(i = 0; i < 4; i++) cK.push(mk('g05-s06-ck' + i, 'partner'));
  var cTag = mkTag('SP');
  var cTagW = phWrap(cTag.tagNode);
  var cQualChip = phWrap(K.chip('× 본인 실적 제외', 'is-red is-sm'));
  var cSideR = K.el('div', 'g05-s06-side');
  cSideR.appendChild(cQualChip);
  cSideR.appendChild(cTagW);
  var cLblL = phWrap(K.chip('동급 미만', 'is-sm'));
  var cLblR = phWrap(K.chip('본인과 동급·추월', 'is-red is-sm'));
  var cStamp = G05.stamp('산정 제외');
  var cSelfCell;
  cTree.appendChild(cSvg);
  cSelfCell = cellOf(cTree, cSelf, 1, 3, 4, cSideR);
  cellOf(cTree, cL1, 2, 1, 4, null);
  cellOf(cTree, cR1, 2, 5, 4, null);
  for(i = 0; i < 4; i++) cellOf(cTree, cK[i], 3, i * 2 + 1, 2, null);
  (function(){
    var l = K.el('div', 'g05-s05-cell'); l.style.gridRow = '4'; l.style.gridColumn = '1 / span 4'; l.appendChild(cLblL); cTree.appendChild(l);
    var r = K.el('div', 'g05-s05-cell'); r.style.gridRow = '4'; r.style.gridColumn = '5 / span 4'; r.appendChild(cLblR); cTree.appendChild(r);
  })();
  cTree.appendChild(cStamp);
  phaseC.appendChild(cTree);

  /* 국면 D: 세로 구조 — 발생 포인트에서 하위 수령분을 빼고 남은 포인트가 본인에게 */
  var phaseD = K.el('div', 'g04-phase g05-s06-d is-hidden');
  var dTree = K.el('div', 'g05-s06-vtree');
  var dSvg = K.svgLayer();
  var dPaths = K.addPaths(dSvg, 2);
  var dGc = mk('g05-s06-dg', 'self', 'lev_gc', 'GC');
  var dSp = mk('g05-s06-ds', 'partner', 'lev_sp', 'SP');
  var dBase = mk('g05-s06-db', 'partner');
  var tagSp = mkTag('SP');
  var tagGc = mkTag('GC');
  var tagSpW = phWrap(tagSp.tagNode);
  var tagGcW = phWrap(tagGc.tagNode);
  var coinRow = K.el('div', 'g05-pcoins g05-ph');
  var coins = [];
  for(i = 0; i < 5; i++){
    var pc = K.el('div', 'g05-pc', 'P');
    coins.push(pc);
    coinRow.appendChild(pc);
  }
  function sideOf(node){
    var sd = K.el('div', 'g05-s06-side');
    sd.appendChild(node);
    return sd;
  }
  dTree.appendChild(dSvg);
  cellOf(dTree, dGc, 1, 1, 1, sideOf(tagGcW));
  cellOf(dTree, dSp, 2, 1, 1, sideOf(tagSpW));
  cellOf(dTree, dBase, 3, 1, 1, sideOf(coinRow));
  var dChip = K.grow(K.chip('남은 포인트는 본인에게 적용', 'is-red g05-wide'));
  phaseD.appendChild(dTree);
  phaseD.appendChild(dChip);

  /* 국면 E: 핵심 3가지 — 씬5 4단계 카드 형식 */
  var fl = {};
  var core = K.threeSlots([
    { text: 'Base 사업자 자격 유지', build: function(body){
        var col = K.el('div', 'g05-s05-useboard');
        var bm = K.member({ label: '', kind: 'self' });
        bm.wrap.classList.add('is-big');
        fl.m1cap = G05.baseCap(bm, true, false);
        fl.m1cap.classList.add('g05-ph', 'g05-pull');
        fl.m1cap.style.setProperty('--pull', '-20px');
        col.appendChild(bm.wrap);
        body.appendChild(col);
        fl.m1 = bm;
      } },
    { text: '하위에 Base 사업자 만들기', build: function(body){
        var col = K.el('div', 'g05-s05-useboard');
        var nm = K.member({ label: '', kind: 'plain' });
        nm.icon.classList.add('g04-nobase');
        nm.wrap.classList.add('is-big');
        function pov(kind){
          var w = K.el('div', 'g05-pov ' + (kind === 'pack' ? 'is-pack' : 'is-auto'));
          w.appendChild(K.product(kind, { mini: true, hidden: false }));
          nm.wrap.appendChild(w);
          return w;
        }
        fl.auto = pov('auto'); fl.pack = pov('pack');
        fl.m2cap = G05.baseCap(nm, true, false);
        fl.m2cap.classList.add('g05-ph');
        col.appendChild(nm.wrap);
        body.appendChild(col);
        fl.m2 = nm;
      } },
    { text: '그 사업자의 성장·육성', build: function(body){
        var col = K.el('div', 'g05-s05-trio');
        var up = K.member({ label: '', kind: 'partner', size: 'xs' });
        var upCap = G05.baseCap(up, true, false);
        upCap.classList.add('is-bfold');
        var row = K.el('div', 'g05-s05-mini g05-pullrow g05-ph');
        fl.row3 = row;
        var a = K.member({ label: '신규', kind: 'new', size: 'xs' });
        var b = K.member({ label: '신규', kind: 'new', size: 'xs' });
        fl.m3 = [a, b];
        fl.m3cap = [G05.baseCap(a, true, false), G05.baseCap(b, true, false)];
        fl.m3cap[0].classList.add('g05-ph', 'is-bfold');
        fl.m3cap[1].classList.add('g05-ph', 'is-bfold');
        row.appendChild(a.wrap);
        row.appendChild(b.wrap);
        col.appendChild(up.wrap);
        col.appendChild(row);
        body.appendChild(col);
      } }
  ], 'g04-sum g04-phase g05-s05-flow is-hidden');
  core.slots.forEach(function(sl){ sl.classList.add('g04-slot', 'is-hidden'); });
  var coreChip = K.grow(K.chip('이 세 가지가 매칭보너스의 핵심', 'is-red g05-wide'));

  board.id = 'g05-s06-board';

  phaseA.appendChild(self.slot);
  phaseA.appendChild(keepChip);

  board.appendChild(phaseA);
  board.appendChild(phaseB);
  board.appendChild(phaseC);
  board.appendChild(phaseD);
  board.appendChild(core.host);
  board.appendChild(coreChip);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide05Scene06Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide05Scene06Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board,
    phaseA: phaseA, self: self, selfMedal: selfMedal, keepChip: keepChip,
    phaseB: phaseB, rateSlots: rateSlots,
    phaseC: phaseC, cTree: cTree, cSvg: cSvg, cPaths: cPaths, cSelf: cSelf, cL1: cL1, cR1: cR1, cK: cK,
    cTag: cTag, cTagW: cTagW, cQualChip: cQualChip, cLblL: cLblL, cLblR: cLblR, cStamp: cStamp,
    phaseD: phaseD, dTree: dTree, dSvg: dSvg, dPaths: dPaths, dGc: dGc, dSp: dSp, dBase: dBase,
    tagSp: tagSp, tagGc: tagGc, tagSpW: tagSpW, tagGcW: tagGcW, coinRow: coinRow, coins: coins, dChip: dChip, fl: fl,
    core: core, coreChip: coreChip
  };
}
</script>
