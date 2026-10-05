<script>
var Guide03Scene04Layout = (function(){
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

  return { schedule: schedule, bind: bind, unbind: unbind };
})();

function setupGuide03Scene04(canvas){
  function grow(child){
    var slot = document.createElement('div');
    var clip = document.createElement('div');
    slot.className = 'g03-grow';
    clip.className = 'g03-grow-clip';
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function hidden(el, cls){
    el.className = cls + ' g03-slot is-hidden';
    return el;
  }

  function partner(rankId, withFc){
    var icon = Guide03.cloneTemplate('member_base_partner');
    var wrap = document.createElement('div');
    var slot = document.createElement('div');
    var rank = Guide03.cloneTemplate(rankId);
    var fc = null;
    wrap.className = 'g03-member g03-slot is-hidden';
    slot.className = 'g03-s04-rank';
    if(rank) slot.appendChild(rank);
    if(withFc){
      fc = Guide03.cloneTemplate('lev_fc');
      if(fc){
        fc.classList.add('g03-slot', 'is-hidden');
        slot.appendChild(fc);
      }
    }
    if(icon){
      icon.appendChild(slot);
      wrap.appendChild(icon);
    }
    return { wrap: wrap, icon: icon, rank: rank, fc: fc };
  }

  function column(rankId, withFc, footText, footCls){
    var person = partner(rankId, withFc);
    var col = document.createElement('div');
    var foot = document.createElement('div');
    col.className = 'g03-s04-col';
    foot.className = footCls;
    foot.textContent = footText;
    col.appendChild(person.wrap);
    col.appendChild(hidden(foot, foot.className));
    return {
      col: col,
      wrap: person.wrap,
      icon: person.icon,
      rank: person.rank,
      fc: person.fc,
      foot: foot
    };
  }

  var zone = Guide03Scene04Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var phaseA = document.createElement('div');
  var phaseB = document.createElement('div');
  var heroWrap = document.createElement('div');
  var hero = Guide03.cloneTemplate('member_base_partner');
  var heroNote = document.createElement('div');
  var panelA = document.createElement('div');
  var rankRow = document.createElement('div');
  var gep = document.createElement('div');
  var ranks = [];
  var rankIds = ['lev_d', 'lev_p', 'lev_jp', 'lev_sp'];
  var i;

  stack.id = 'g03-s04-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s04';
  phaseA.className = 'g03-s04-phase g03-slot';
  phaseB.className = 'g03-s04-phase g03-slot is-hidden';
  heroWrap.className = 'g03-member g03-s04-hero g03-slot is-hidden';
  if(hero) heroWrap.appendChild(hero);
  heroNote.className = 'g03-s04-note';
  heroNote.textContent = '파트너 2명의 조건';
  hidden(heroNote, heroNote.className);
  panelA.className = 'g03-board g03-slot is-hidden';
  rankRow.className = 'g03-s04-rankrow';
  for(i = 0; i < rankIds.length; i++){
    var badge = Guide03.cloneTemplate(rankIds[i]);
    var slot = grow(badge || document.createElement('div'));
    rankRow.appendChild(slot);
    ranks.push(slot);
  }
  gep.className = 'g03-s04-line';
  gep.textContent = 'FC 미만 직 1대 디슈머';
  var gepSlot = grow(gep);
  panelA.appendChild(rankRow);
  panelA.appendChild(gepSlot);

  var track1 = document.createElement('div');
  var track2 = document.createElement('div');
  track1.className = 'g03-s04-track';
  track2.className = 'g03-s04-track';
  track1.textContent = '1 TRACK';
  track2.textContent = '2 TRACK';
  hidden(track1, track1.className);
  hidden(track2, track2.className);

  var panel1 = document.createElement('div');
  var panel2 = document.createElement('div');
  var row1 = document.createElement('div');
  var row2 = document.createElement('div');
  panel1.className = 'g03-board g03-s04-panel g03-slot is-hidden';
  panel2.className = 'g03-board g03-s04-panel g03-slot is-hidden';
  row1.className = 'g03-s04-row';
  row2.className = 'g03-s04-row';

  var leftD = column('lev_d', false, '', 'g03-s04-auto');
  var rightP = column('lev_p', false, '', 'g03-s04-auto');
  var autoD = Guide03.cloneTemplate('autoship_icon');
  var autoP = Guide03.cloneTemplate('autoship_icon');
  if(autoD) leftD.foot.appendChild(autoD);
  if(autoP) rightP.foot.appendChild(autoP);
  leftD.foot.classList.add('g03-s04-auto');
  rightP.foot.classList.add('g03-s04-auto');
  row1.appendChild(leftD.col);
  row1.appendChild(rightP.col);
  panel1.appendChild(row1);

  var leftJp = column('lev_jp', false, 'SEP 30만 이상', 'g03-s04-sep');
  var rightSp = column('lev_sp', true, 'SEP 30만 이상', 'g03-s04-sep');
  var loss = document.createElement('div');
  loss.className = 'g03-s04-loss';
  loss.textContent = '파트너 자격 상실';
  hidden(loss, loss.className);
  rightSp.col.appendChild(loss);
  row2.appendChild(leftJp.col);
  row2.appendChild(rightSp.col);
  panel2.appendChild(row2);

  var block1 = document.createElement('div');
  var block2 = document.createElement('div');
  block1.className = 'g03-s04-block';
  block2.className = 'g03-s04-block';
  block1.appendChild(track1);
  block1.appendChild(panel1);
  block2.appendChild(track2);
  block2.appendChild(panel2);

  phaseA.appendChild(heroWrap);
  phaseA.appendChild(heroNote);
  phaseA.appendChild(panelA);
  phaseB.appendChild(block1);
  phaseB.appendChild(block2);
  stage.appendChild(phaseA);
  stage.appendChild(phaseB);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene04Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene04Layout.schedule();

  return {
    phaseA: phaseA,
    phaseB: phaseB,
    hero: heroWrap,
    heroNote: heroNote,
    panelA: panelA,
    ranks: ranks,
    gep: gepSlot,
    track1: track1,
    track2: track2,
    panel1: panel1,
    panel2: panel2,
    pair1: [leftD.wrap, rightP.wrap],
    autos: [leftD.foot, rightP.foot],
    pair2: [leftJp.wrap, rightSp.wrap],
    seps: [leftJp.foot, rightSp.foot],
    spCol: rightSp.col,
    jpCol: leftJp.col,
    spIcon: rightSp.icon,
    spRank: rightSp.rank,
    fcRank: rightSp.fc,
    loss: loss
  };
}
</script>
