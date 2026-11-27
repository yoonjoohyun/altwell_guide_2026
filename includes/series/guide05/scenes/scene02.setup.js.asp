<script>
var Guide05Scene02Layout = G04Kit.makeLayout();

function setupGuide05Scene02(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide05Scene02Config.layout.anchorZone);
  var badge = K.titleBadge('matching_bonus_icon', 'g05-s02-badge', '매칭 포인트 기준');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 3);
  var selfRow = K.el('div', 'g04-selfrow g05-s02-selfrow');
  var self = K.member({ id: 'g05-s02-self', label: '본인', cap: 'x', kind: 'self' });
  var selfBase = K.dock(self.fig, null, 'g05_base_icon', true);
  var emptyMedal = K.el('div', 'g04-slot g05-chest g05-empty-medal is-hidden', '?');
  var fcMedal = G05.chestMedal(self.fig, 'lev_fc', 'FC');
  var tag = K.tag(0);
  var tagSlot = K.grow(tag);
  var mid = K.el('div', 'g04-phase g05-mid is-hidden');
  var labelSlot = K.grow(K.chip('하위 Base 사업자 1명당 포인트', 'is-sm'));
  var rates = K.el('div', 'g05-rates');
  var rateSlots = [];
  var kidsWrap = K.el('div', 'g05-kids-wrap g04-phase is-hidden');
  var kidsRow = K.el('div', 'g04-cols g05-kids');
  var kids = [];
  var noteSlot = K.grow(K.el('div', 'g05-subnote', 'FC 바로 아래 Base 사업자'));
  var emphSlot = K.grow(K.chip('같은 Base 사업자 수라도 지위에 따라 포인트 다름', 'is-red'));

  board.id = 'g05-s02-board';
  if(self.cap && self.cap.parentNode){ self.cap.parentNode.removeChild(self.cap); self.cap = null; }
  selfBase.classList.remove('is-hidden');
  self.fig.appendChild(emptyMedal);
  K.tagLabel(tag, '4 × 3 =');
  tag.tagNode.querySelector('.referral_point_tag_unit').textContent = '포인트';
  tag.tagNode.setAttribute('aria-label', '매칭포인트');

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
  mid.appendChild(labelSlot);
  mid.appendChild(rates);

  [0, 1, 2].forEach(function(i){
    var col = K.el('div', 'g04-col');
    var mem = K.member({ id: 'g05-s02-k' + i, label: '하위', kind: 'partner', size: 'sm' });
    var d = K.dock(mem.fig, null, 'g05_base_icon', true);
    d.classList.remove('is-hidden');
    col.appendChild(mem.slot);
    kidsRow.appendChild(col);
    kids.push(mem);
  });
  kidsWrap.appendChild(kidsRow);
  kidsWrap.appendChild(noteSlot);

  selfRow.appendChild(K.el('div'));
  selfRow.appendChild(self.slot);
  selfRow.appendChild(tagSlot);
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(mid);
  tree.appendChild(kidsWrap);
  tree.appendChild(emphSlot);

  board.appendChild(tree);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide05Scene02Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide05Scene02Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree, svg: svg, paths: paths,
    self: self, emptyMedal: emptyMedal, fcMedal: fcMedal, tag: tag, tagSlot: tagSlot,
    mid: mid, kidsWrap: kidsWrap, labelSlot: labelSlot, rateSlots: rateSlots, kids: kids, noteSlot: noteSlot, emphSlot: emphSlot
  };
}
</script>
