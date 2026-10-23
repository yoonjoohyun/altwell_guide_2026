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
    var simSlot = null;
    var sim = null;
    var replaySlot = null;
    var replay = null;

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

    card.appendChild(titleSlot);

    var buttonSpecs = opts.buttons || [
      {
        part: 'sim',
        text: 'Q 퀴즈 가이드로 복습하기',
        onClick: function(){ location.href = opts.simulatorHref || simulatorHref(); }
      },
      {
        part: 'replay',
        text: '가이드 영상 다시보기',
        ghost: true,
        onClick: function(){
          if(typeof SceneRunner === 'undefined') return;
          if(SceneRunner.pauseLesson) SceneRunner.pauseLesson();
          if(SceneRunner.restartLesson) SceneRunner.restartLesson();
          if(SceneRunner.playLesson) SceneRunner.playLesson();
        }
      }
    ];
    var buttonSlots = [];
    var buttonEls = [];
    var bi;
    for(bi = 0; bi < buttonSpecs.length; bi++){
      (function(spec){
        var slot = makeSlot(spec.part || ('btn' + bi));
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'g-close-btn' + (spec.ghost ? ' g-close-btn-ghost' : '') + (opts.buttonClass ? ' ' + opts.buttonClass : '');
        btn.textContent = spec.text;
        if(spec.onClick) btn.addEventListener('click', spec.onClick);
        slot.appendChild(btn);
        card.appendChild(slot);
        buttonSlots.push(slot);
        buttonEls.push(btn);
        if(spec.part === 'sim'){ simSlot = slot; sim = btn; }
        if(spec.part === 'replay'){ replaySlot = slot; replay = btn; }
      })(buttonSpecs[bi]);
    }

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
      replay: replay,
      buttonSlots: buttonSlots,
      buttons: buttonEls
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
      if(card._gCloseToken !== token || !card.isConnected){
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
      if(opts.onDone) opts.onDone();
    }, 32);
  }

  var simEndTimers = [];
  var simEndObserver = null;

  function clearSimEndTimers(){
    while(simEndTimers.length) clearTimeout(simEndTimers.pop());
    if(simEndObserver){
      simEndObserver.disconnect();
      simEndObserver = null;
    }
  }

  function showSimulatorEnd(canvas, options){
    var opts = options || {};
    var stack;
    var panel;
    var steps;
    var fitObserver;
    function alive(){
      return panel && panel.wrap && panel.wrap.isConnected;
    }
    function fit(){
      var canvasRect;
      var rect;
      var scale;
      if(!alive()) return;
      canvasRect = canvas.getBoundingClientRect();
      stack.style.transform = 'translate(-50%, -50%)';
      rect = panel.card.getBoundingClientRect();
      scale = 1;
      if(rect.width > 0 && rect.height > 0){
        scale = Math.min((canvasRect.width * 0.8) / rect.width, (canvasRect.height * 0.8) / rect.height);
      }
      stack.style.transform = 'translate(-50%, -50%) scale(' + scale + ')';
    }
    function later(ms, fn){
      simEndTimers.push(window.setTimeout(function(){
        if(!alive()) return;
        fn();
      }, ms));
    }
    clearSimEndTimers();
    if(!canvas) return null;
    canvas.innerHTML = '';
    stack = document.createElement('div');
    stack.className = 'sim-close-stack';
    panel = mount(stack, {
      className: 'sim-close',
      zoneWrap: false,
      title: opts.title,
      titleOpen: false,
      buttons: [
        { part: 'relearn', text: '퀴즈 다시 풀기', onClick: opts.onRelearn },
        { part: 'watch', text: '교육 영상 다시 보기', ghost: true, onClick: opts.onWatch },
        { part: 'list', text: '리스트로 돌아가기', ghost: true, onClick: opts.onList }
      ]
    });
    canvas.appendChild(stack);
    panel.wrap.classList.add('is-in');
    fit();
    if(window.ResizeObserver){
      fitObserver = new ResizeObserver(fit);
      simEndObserver = fitObserver;
      fitObserver.observe(panel.card);
    }
    later(680, function(){
      panel.wrap.classList.remove('is-in');
      panel.wrap.classList.add('is-idle');
      fit();
    });
    steps = [panel.titleSlot].concat(panel.buttonSlots);
    later(1100, function(){ open(steps[0], { ms: 680, float: true, onDone: fit }); });
    later(2500, function(){ open(steps[1], { ms: 680, float: true, onDone: fit }); });
    later(3900, function(){ open(steps[2], { ms: 680, float: true, onDone: fit }); });
    later(5300, function(){ open(steps[3], { ms: 680, float: true, onDone: fit }); });
    return panel;
  }

  return { mount: mount, open: open, simulatorHref: simulatorHref, showSimulatorEnd: showSimulatorEnd };
})();
</script>
