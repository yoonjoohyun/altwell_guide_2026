<script>
/* 클로징 패널. 빈 카드가 먼저 뜨고, 타이틀과 버튼이 열릴 때 카드 높이가 같은 시간으로 늘어난다. */
var GuideClosePanel = (function(){
  function simulatorHref(){
    return (window.GUIDE_ROOT || '') + '/sim.asp';
  }

  function makeSlot(part){
    var slot = document.createElement('div');
    slot.className = 'g-close-slot';
    slot.setAttribute('data-part', part);
    return slot;
  }

  function closeTitleText(title){
    var base = String(title || '').trim();
    if(!base) return '완료';
    if(/완료\s*$/.test(base)) return base;
    return base + ' 완료';
  }

  function mount(parent, options){
    var opts = options || {};
    var root = document.createElement('div');
    var card = document.createElement('div');
    var titleSlot = makeSlot('title');
    var title = document.createElement('div');
    var simSlot = makeSlot('sim');
    var sim = document.createElement('button');
    var replaySlot = makeSlot('replay');
    var replay = document.createElement('button');

    root.className = 'g-close' + (opts.className ? ' ' + opts.className : '');
    if(opts.zoneWrap !== false) root.classList.add('g01-zone-wrap');
    if(opts.id) root.id = opts.id;
    if(opts.hidden) root.classList.add('is-hidden');
    if(opts.place) opts.place(root, opts.zone || 'd4');

    card.className = 'g-close-card' + (opts.cardClass ? ' ' + opts.cardClass : '');
    title.className = 'g-close-title' + (opts.titleClass ? ' ' + opts.titleClass : '');
    title.textContent = closeTitleText(opts.title);
    titleSlot.appendChild(title);
    if(opts.titleOpen) titleSlot.classList.add('is-open');

    sim.type = 'button';
    sim.className = 'g-close-btn' + (opts.buttonClass ? ' ' + opts.buttonClass : '');
    sim.textContent = '시뮬레이션으로 복습하기';
    sim.addEventListener('click', function(){
      location.href = opts.simulatorHref || simulatorHref();
    });
    simSlot.appendChild(sim);

    replay.type = 'button';
    replay.className = 'g-close-btn g-close-btn-ghost' + (opts.buttonClass ? ' ' + opts.buttonClass : '');
    replay.textContent = '가이드 영상 다시보기';
    replay.addEventListener('click', function(){
      if(typeof SceneRunner === 'undefined') return;
      if(SceneRunner.pauseLesson) SceneRunner.pauseLesson();
      if(SceneRunner.restartLesson) SceneRunner.restartLesson();
      if(SceneRunner.playLesson) SceneRunner.playLesson();
    });
    replaySlot.appendChild(replay);

    card.appendChild(titleSlot);
    card.appendChild(simSlot);
    card.appendChild(replaySlot);
    root.appendChild(card);
    if(parent) parent.appendChild(root);

    return {
      wrap: root,
      card: card,
      titleSlot: titleSlot,
      title: title,
      simSlot: simSlot,
      sim: sim,
      replaySlot: replaySlot,
      replay: replay
    };
  }

  function curve(t, ease){
    var x1 = ease === 'ease' ? 0.25 : 0.22;
    var y1 = ease === 'ease' ? 0.1 : 1;
    var x2 = ease === 'ease' ? 0.25 : 0.36;
    var y2 = 1;
    var u = t;
    var i;
    function axis(v, a, b){
      return (3 * a * (1 - v) * (1 - v) * v) + (3 * b * (1 - v) * v * v) + (v * v * v);
    }
    function slope(v, a, b){
      return (3 * a * (1 - v) * (1 - (3 * v))) + (3 * b * v * (2 - (3 * v))) + (3 * v * v);
    }
    for(i = 0; i < 5; i++){
      var dx = slope(u, x1, x2);
      if(Math.abs(dx) < 0.0001) break;
      u = u - ((axis(u, x1, x2) - t) / dx);
    }
    if(u < 0) u = 0;
    if(u > 1) u = 1;
    return axis(u, y1, y2);
  }

  function open(slot, options){
    var opts = options || {};
    var card = slot && slot.closest ? slot.closest('.g-close-card') : null;
    var ms = opts.ms || 680;
    var ease = opts.ease || '';
    var float = opts.float !== false;
    var from;
    var to;
    var token;
    var started;
    if(!card || !slot || slot.classList.contains('is-open')) return;

    if(card._gCloseTimer){
      clearInterval(card._gCloseTimer);
      card._gCloseTimer = null;
    }
    from = card.offsetHeight;
    card.style.transition = 'none';
    card.style.overflow = 'hidden';
    card.style.height = from + 'px';
    slot.classList.add('is-open');
    card.style.height = 'auto';
    to = card.offsetHeight;
    card.style.height = from + 'px';
    slot.style.opacity = '0';
    if(float) slot.style.transform = 'translateY(10px)';
    token = (card._gCloseToken || 0) + 1;
    card._gCloseToken = token;
    started = performance.now();
    /* 높이와 투명도·이동을 같은 시계로 올려, 패널이 커지는 동안 내용이 같이 뜬다. */
    card._gCloseTimer = window.setInterval(function(){
      var p;
      var e;
      var y;
      if(card._gCloseToken !== token){
        clearInterval(card._gCloseTimer);
        return;
      }
      p = (performance.now() - started) / ms;
      if(p > 1) p = 1;
      e = curve(p, ease);
      card.style.height = (from + ((to - from) * e)) + 'px';
      slot.style.opacity = String(e);
      if(float){
        y = 10 * (1 - e);
        slot.style.transform = 'translateY(' + y + 'px)';
      }
      if(p < 1) return;
      clearInterval(card._gCloseTimer);
      card._gCloseTimer = null;
      card.style.height = 'auto';
      card.style.overflow = '';
      slot.style.opacity = '';
      slot.style.transform = '';
    }, 32);
  }

  return { mount: mount, open: open, simulatorHref: simulatorHref };
})();
</script>
