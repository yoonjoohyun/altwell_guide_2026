<script>
/* SEP 성장하기 — 테스트 Scene 01 (video_start Object Library, 순차 플로팅) */
var SepScene01 = {
  id: 'sep-scene-01',
  title: 'SEP 성장의 시작',
  duration: 10000,
  _baseAnimMs: 8000,

  _mountCanvas: function(canvas){
    canvas.classList.add('sep-test-canvas');
    MotionCanvasStandardStage.run({ canvas: canvas });
    Connectors.mountPair(canvas);

    var main = MemberUnit.mountMain(canvas, {
      imageSrc: MemberUnit.IMGS.member,
      imageAlt: 'BASE사업자',
      includeBaseBadge: true
    });

    var stack = document.createElement('div');
    stack.className = 'member-income bonus-stack is-hidden';
    stack.id = 'bonus-stack-main';
    stack.innerHTML =
      '<div class="bonus-plate support-bonus is-hidden" id="support-bonus-main">' +
        '<span class="bonus-indicator"></span>' +
        '<span class="bonus-label">후원 보너스</span>' +
        '<strong class="bonus-value">3%</strong>' +
      '</div>' +
      '<div class="bonus-plate recommend-bonus is-hidden" id="recommend-bonus-main">' +
        '<span class="bonus-indicator"></span>' +
        '<span class="bonus-label">추천 보너스</span>' +
        '<strong class="bonus-value">10,000원 × 2</strong>' +
      '</div>';
    main.appendChild(stack);

    MemberUnit.mountChild(canvas, 'left', {
      imageSrc: MemberUnit.IMGS.people,
      imageAlt: 'SEP 회원',
      includeSep: true
    });
    MemberUnit.mountChild(canvas, 'right', {
      imageSrc: MemberUnit.IMGS.people,
      imageAlt: 'SEP 회원',
      includeSep: true
    });
  },

  reset: function(){
    CanvasStage.reset(document.getElementById('motion-canvas'), 'sep-test-canvas');

    ['scene-title-main', 'panel-scene-desc', 'scene-bullets', 'panel-fixed-title'].forEach(function(id){
      var el = document.getElementById(id);
      if(!el) return;
      if(el.tagName === 'UL') el.innerHTML = '';
      else if(el.tagName === 'H2') el.innerHTML = '';
      else el.textContent = '';
      el.classList.add('is-hidden');
      el.style.cssText = '';
    });
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var T = createSceneTiming(ctx, this._baseAnimMs);
    setActiveSceneTiming(T);

    this._mountCanvas(canvas);

    setSceneTitle('SEP 성장의 시작');
    setSceneBullets([
      '실적(SEP)을 쌓아 조직을 키웁니다',
      '오토십 · BASE 자격을 유지합니다',
      '하위 디슈머의 성장을 돕습니다'
    ]);
    hideElement('#scene-title-main');
    hideElement('#scene-bullets');
    MotionPanelHideBullets.run(ctx);

    try {
      await T.padStart();
      if(cancelled()) return;

      await sceneWait(300);
      if(cancelled()) return;

      await MotionMemberEnter.run(ctx, { target: 'member-unit-main', duration: 800 });
      showElement('#scene-title-main');
      await slideUpElement('#scene-title-main', { duration: sceneDur(600) });
      T.after(800);

      await sceneWait(500);
      if(cancelled()) return;

      await MotionObjectFloatEnter.run(ctx, { target: '#rank-medal-main', duration: 700, glow: true });
      T.after(700);

      await sceneWait(450);
      if(cancelled()) return;

      await MotionObjectFloatEnter.run(ctx, { target: '#autoship-emblem-main', duration: 700, glow: true });
      T.after(700);

      await sceneWait(450);
      if(cancelled()) return;

      await MotionObjectFloatEnter.run(ctx, { target: '#base-business-badge-main', duration: 750, glow: true });
      T.after(750);

      await sceneWait(400);
      if(cancelled()) return;

      showElement('#bonus-stack-main');
      await MotionObjectFloatEnter.run(ctx, { target: '#support-bonus-main', duration: 650, glow: false, idleFloat: false });
      T.after(650);

      await sceneWait(350);
      if(cancelled()) return;

      await MotionObjectFloatEnter.run(ctx, { target: '#recommend-bonus-main', duration: 650, glow: false, idleFloat: false });
      T.after(650);

      MotionPanelRevealBullets.run(ctx, { initialDelay: 200, gap: 380 });

      await sceneWait(500);
      if(cancelled()) return;

      await Promise.all([
        MotionMemberEnter.run(ctx, { target: 'member-unit-left', duration: 700 }),
        MotionConnectorDraw.run(ctx, { lineId: 'connector-left' })
      ]);
      T.after(900);

      await sceneWait(400);
      if(cancelled()) return;

      showElement('#member-metrics-left');
      await MotionObjectFloatEnter.run(ctx, { target: '#sep-badge-left', duration: 680, glow: true, idleFloat: false });
      T.after(680);

      await sceneWait(450);
      if(cancelled()) return;

      await Promise.all([
        MotionMemberEnter.run(ctx, { target: 'member-unit-right', duration: 700 }),
        MotionConnectorDraw.run(ctx, { lineId: 'connector-right' })
      ]);
      T.after(900);

      await sceneWait(400);
      if(cancelled()) return;

      showElement('#member-metrics-right');
      await MotionObjectFloatEnter.run(ctx, { target: '#sep-badge-right', duration: 680, glow: true, idleFloat: false });
      T.after(680);

      await sceneWait(600);
      if(cancelled()) return;

      await MotionEffectPulseHighlight.run(ctx, { target: '#bullet-1', duration: 700 });

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  },

  endState: function(){
    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = 'SEP 성장하기';
      showElement(chapter);
    }
  }
};
</script>
