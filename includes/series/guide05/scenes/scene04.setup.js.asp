<script>
var Guide05Scene04Layout = G04Kit.makeLayout();

function setupGuide05Scene04(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide05Scene04Config.layout.anchorZone);
  var badge = K.titleBadge('matching_bonus_icon', 'g05-s04-badge', '매칭 포인트 지급');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var topBadge = K.el('div', 'g04-slot g05-topbadge is-hidden');
  var maxSlot = K.grow(K.chip('Base 사업자 1명 당 최대 5포인트', 'g05-key'));
  var body = K.el('div', 'g04-phase g05-s04-body');
  var labelSlot = K.grow(K.chip('지위에 따라 수령분 결정', 'g05-key'));
  var remainSlot = K.grow(K.chip('소멸 없음 · 상위로 이어짐', 'is-red'));
  var tree = K.el('div', 'g05-s04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 6);
  var i;

  /* 피라미드: 1행 GC / 2행 파트너·SP / 3행 일반·파트너·Base 사업자 1명·일반 */
  function mk(id, kind, cap, label){
    var mem = K.member({ id: id, label: label || '', kind: kind, size: 'sm' });
    if(kind === 'plain') mem.icon.classList.add('g04-nobase');
    if(cap) G05.baseCap(mem, true, false);
    return mem;
  }
  var gcM = mk('g05-s04-gc', 'self', true, '본인');
  var spM = mk('g05-s04-sp', 'self', true);
  var bM = mk('g05-s04-b', 'self', true);
  var pM = mk('g05-s04-p', 'partner', false);
  var fM = [mk('g05-s04-f0', 'partner', false), mk('g05-s04-f1', 'partner', false), mk('g05-s04-f2', 'partner', false)];
  var gcMedal = G05.chestMedal(gcM.fig, 'lev_gc', 'GC');
  var spMedal = G05.chestMedal(spM.fig, 'lev_sp', 'SP');
  var tagSp = K.tag(0);
  var tagGc = K.tag(0);
  var tagSpSlot = K.grow(tagSp);
  var tagGcSlot = K.grow(tagGc);
  var gcSide = K.el('div', 'g05-s04-side');
  var spSide = K.el('div', 'g05-s04-side');
  var sum = K.el('div', 'g04-phase g05-s04-sum is-hidden');
  function sumRow(icons, html){
    var row = K.el('div', 'g05-sumrow');
    var ico = K.el('div', 'g05-sumico');
    var txt = K.el('div', 'g05-sumtxt');
    icons.forEach(function(n){ if(n) ico.appendChild(n); });
    txt.innerHTML = html;
    row.appendChild(ico);
    row.appendChild(txt);
    return K.grow(row);
  }
  function coin(n){ var c = K.el('div', 'g05-coin'); c.textContent = n + 'P'; return c; }
  function lvl(id){ var h = K.el('div', 'g05-sumlev'); var n = Guide04.cloneTemplate(id); if(n) h.appendChild(n); return h; }
  function eqRow(nodes, pt){
    var r = K.el('div', 'g05-eqrow');
    var lv = K.el('div', 'g05-eqlev');
    nodes.forEach(function(n){ lv.appendChild(n); });
    r.appendChild(lv);
    var eq = K.el('span', 'g05-eq'); eq.textContent = '=';
    r.appendChild(eq);
    r.appendChild(coin(pt));
    return r;
  }
  function tilde(){ var t = K.el('span', 'g05-eq'); t.textContent = '~'; return t; }
  var sumMem = K.member({ id: 'g05-s04-sumb', label: '', kind: 'self', size: 'sm' });
  G05.baseCap(sumMem, true, false);
  var sumA = sumRow([sumMem.wrap], '본인 제외 <em>Base 사업자 1명 당</em><br><b>최대 5포인트</b>');
  var sumB = sumRow([
    eqRow([lvl('lev_sp')], 3),
    eqRow([lvl('lev_fc')], 4),
    eqRow([lvl('lev_gc'), tilde(), lvl('lev_irf')], 5)
  ], '지위 별 포인트 한도를 제외한<br><b>잔여분은 상위로</b>');
  sumB.classList.add('g05-sumrow-lv');
  board.id = 'g05-s04-board';
  topBadge.appendChild(Guide04.cloneTemplate('matching_bonus_icon'));
  K.tagLabel(tagSp, 'SP');
  K.tagLabel(tagGc, 'GC');
  [tagSp, tagGc].forEach(function(t){
    t.tagNode.querySelector('.referral_point_tag_unit').textContent = '포인트';
  });

  /* 포인트 코인: 5P 는 Base 사업자 멤버에서 생성 -> SP 에서 3P / 2P 로 나뉨 */
  function pcoin(text, cls){
    var c = K.el('div', 'g05-pc g05-pc-lg g05-ph' + (cls ? ' ' + cls : ''));
    c.textContent = text;
    return c;
  }
  var coin5 = pcoin('5P', 'g05-bcoin');
  bM.fig.appendChild(coin5);
  var coin3 = pcoin('3P');
  var coin2 = pcoin('2P');
  var coinRow = K.el('div', 'g05-s04-coins');
  coinRow.appendChild(coin3);
  coinRow.appendChild(coin2);

  gcSide.appendChild(tagGcSlot);
  spSide.appendChild(tagSpSlot);
  spSide.appendChild(coinRow);

  /* 격자(4열): 행1 2~3열, 행2 1~2열/3~4열, 행3 각 1열 */
  function cell(mem, row, c1, span, side, side2){
    var cl = K.el('div', 'g05-s04-cell');
    cl.style.gridRow = String(row);
    cl.style.gridColumn = c1 + ' / span ' + span;
    cl.appendChild(mem.slot);
    if(side) cl.appendChild(side);
    if(side2) cl.appendChild(side2);
    tree.appendChild(cl);
    return cl;
  }
  tree.appendChild(svg);
  cell(gcM, 1, 2, 2, gcSide, null);
  cell(pM, 2, 1, 2, null);
  cell(spM, 2, 3, 2, spSide);
  cell(fM[0], 3, 1, 1, null);
  cell(fM[1], 3, 2, 1, null);
  cell(bM, 3, 3, 1, null);
  cell(fM[2], 3, 4, 1, null);

  body.appendChild(tree);
  sum.appendChild(sumA);
  sum.appendChild(sumB);

  board.appendChild(topBadge);
  board.appendChild(maxSlot);
  board.appendChild(body);
  board.appendChild(labelSlot);
  board.appendChild(remainSlot);
  board.appendChild(sum);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide05Scene04Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide05Scene04Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, topBadge: topBadge, maxSlot: maxSlot,
    body: body, coin5: coin5, coin3: coin3, coin2: coin2, labelSlot: labelSlot, remainSlot: remainSlot, rows: tree, svg: svg, paths: paths,
    gc: gcM, sp: spM, base: bM, partner: pM, fillers: fM, gcMedal: gcMedal, spMedal: spMedal, tagSp: tagSp, tagGc: tagGc,
    tagSpSlot: tagSpSlot, tagGcSlot: tagGcSlot, sum: sum, sumA: sumA, sumB: sumB
  };
}
</script>
