<script>
var Guide03Scene10Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    if(!_ctx || typeof Guide03 === 'undefined') return;
    Guide03.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, _ctx.badge);
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

  return { schedule: schedule, flush: applyFit, bind: bind, unbind: unbind };
})();

function setupGuide03Scene10(canvas){
  var zone = Guide03Scene10Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var card;
  var orbs = document.createElement('div');

  function hidden(className){
    var el = document.createElement('div');
    el.className = className + ' g03-slot is-hidden';
    return el;
  }

  function member(templateId){
    var icon = Guide03.cloneTemplate(templateId);
    var host = hidden('g03-s10-person');
    if(icon) host.appendChild(icon);
    return { host: host, icon: icon };
  }

  function attachBadge(selfEntry){
    var host = selfEntry.host;
    var dock;
    var badgeWrap;
    var badge;
    if(!host) return null;
    host.classList.add('g03-s10-self-host');
    dock = document.createElement('div');
    dock.className = 'g03-s10-self-dock';
    badgeWrap = document.createElement('div');
    badgeWrap.className = 'g03-slot g03-s10-self-badge is-hidden';
    badge = Guide03.cloneTemplate('base_business_icon');
    if(badge){
      badge.classList.remove('base_business_icon_o');
      badge.classList.add('base_business_icon_c');
      badgeWrap.appendChild(badge);
    }
    dock.appendChild(badgeWrap);
    host.appendChild(dock);
    return badgeWrap;
  }

  function pane(kind){
    var root = hidden('g03-s10-pane g03-s10-shift');
    var board = document.createElement('div');
    var people = document.createElement('div');
    var selfCol = document.createElement('div');
    var partnerCol = document.createElement('div');
    var self = member('member_base_self');
    var badge = attachBadge(self);
    var back = member('member_base_partner');
    var front = member('member_base_partner');
    var pair = document.createElement('div');
    var chip = document.createElement('div');
    var selfAuto = document.createElement('div');
    var selfSep = document.createElement('div');
    var selfAutoIcon = Guide03.cloneTemplate('autoship_icon');
    var note = document.createElement('div');
    var noteInner = document.createElement('div');
    board.className = 'g03-board g03-s10-board';
    people.className = 'g03-s10-people';
    selfCol.className = 'g03-s10-col';
    partnerCol.className = 'g03-s10-col';
    pair.className = 'g03-s10-pair';
    back.host.classList.add('g03-s10-back');
    pair.appendChild(back.host);
    pair.appendChild(front.host);
    chip.className = 'g03-s10-chip g03-slot is-hidden';
    note.className = 'g03-s10-note g03-slot is-hidden';
    noteInner.className = 'g03-s10-note-inner';
    if(kind === 'auto'){
      var auto = Guide03.cloneTemplate('autoship_icon');
      var autoText = auto && auto.querySelector('.autoship_text');
      chip.classList.add('g03-s10-chip-auto');
      if(autoText) autoText.innerHTML = '2명 모두<br>오토십 구독';
      if(auto){
        auto.setAttribute('aria-label', '2명 모두 오토십 구독');
        chip.appendChild(auto);
      }
      note.classList.add('g03-s10-note-free');
      noteInner.innerHTML = '구성원 합산 조건 등<span class="g03-s10-note-em">추가 조건 없음</span>';
    }else{
      chip.classList.add('g03-s10-chip-sep');
      chip.innerHTML = '2명 모두<br>S.E.P 30만 이상';
      noteInner.innerHTML = '구성원 3명의<span class="g03-s10-note-sep">합산 S.E.P 100만 이상</span>';
    }
    note.appendChild(noteInner);
    selfAuto.className = 'g03-s10-self-auto g03-slot is-hidden';
    if(selfAutoIcon) selfAuto.appendChild(selfAutoIcon);
    selfSep.className = 'g03-s10-self-sep g03-slot is-hidden';
    selfSep.textContent = 'S.E.P 30만 이상';
    selfCol.appendChild(self.host);
    selfCol.appendChild(selfAuto);
    selfCol.appendChild(selfSep);
    partnerCol.appendChild(pair);
    partnerCol.appendChild(chip);
    people.appendChild(selfCol);
    people.appendChild(partnerCol);
    board.appendChild(people);
    root.appendChild(board);
    root.appendChild(note);
    return {
      root: root,
      self: self,
      selfAuto: selfAuto,
      selfSep: selfSep,
      badge: badge,
      partners: [back, front],
      chip: chip,
      note: note
    };
  }

  function orb(html){
    var host = hidden('g03-s10-orb g03-s10-shift');
    host.innerHTML = html;
    return host;
  }

  var badge = Guide03.cloneTemplate('base_business_icon');
  var badgeWrap = hidden('g03-s10-badge');
  if(badge) badgeWrap.appendChild(badge);

  var left = pane('auto');
  var right = pane('sep');
  var boards = hidden('g03-s10-boards');
  boards.appendChild(left.root);
  boards.appendChild(right.root);
  card = boards;
  orbs.className = 'g03-s10-orbs g03-slot is-hidden';

  function orbSep(){
    var el = hidden('g03-s10-orb-sep g03-s10-shift');
    el.setAttribute('aria-hidden', 'true');
    return el;
  }

  var orbNodes = [
    orb('본인 + 파트너2명<br>비즈니스 기본 단위'),
    orb('각종 보너스 보상<br>&<br>승급 조건에 활용'),
    orb('안정적인 조직 확장<br>출발점')
  ];
  var orbSeps = [orbSep(), orbSep()];
  orbs.appendChild(orbNodes[0]);
  orbs.appendChild(orbSeps[0]);
  orbs.appendChild(orbNodes[1]);
  orbs.appendChild(orbSeps[1]);
  orbs.appendChild(orbNodes[2]);

  stage.className = 'g03-s10';
  stage.appendChild(badgeWrap);
  stage.appendChild(card);
  stage.appendChild(orbs);

  stack.id = 'g03-s10-stack';
  stack.className = 'g03-stack g01-zone-wrap lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  if(Guide03Scene10Config.layout && Guide03Scene10Config.layout.badgeAloneScale > 0){
    stage._g03BadgeAloneScale = Guide03Scene10Config.layout.badgeAloneScale;
  }
  Guide03Scene10Layout.bind({ canvas: canvas, inner: inner, stage: stage, badge: badgeWrap });
  Guide03Scene10Layout.schedule();

  return {
    stage: stage,
    badge: badgeWrap,
    card: card,
    left: left,
    right: right,
    orbWrap: orbs,
    orbs: orbNodes,
    orbSeps: orbSeps
  };
}
</script>
