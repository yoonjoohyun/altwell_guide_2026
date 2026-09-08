<script>
var Guide01Scene07 = defineScene({
  id: 'guide01-scene-07',
  title: "오토십, 이것만 기억하세요!'",
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas, 'guide01-scene07');
      Guide01.addAsset(canvas, 'autoship_icon', 'scene07-autoship');
      var grid = document.createElement('div');
      grid.id = 'scene07-summary';
      grid.className = 'g01-summary-grid is-hidden';
      grid.innerHTML =
        '<div class="g01-summary-card" id="s07-c1"></div>' +
        '<div class="g01-summary-card" id="s07-c2"></div>' +
        '<div class="g01-summary-card" id="s07-c3"></div>' +
        '<div class="g01-summary-card" id="s07-c4"></div>';
      canvas.appendChild(grid);
      Guide01.addAsset(canvas, 'recommend_bonus_icon', 'scene07-recommend');
      Guide01.addAsset(canvas, 'base_business_icon', 'scene07-base');
    },
    reset: function(){ Guide01.resetScene('guide01-scene07'); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene07-autoship');
    autoship.style.left = '50%'; autoship.style.top = '10%'; autoship.style.transform = 'translateX(-50%)';
    var grid = document.getElementById('scene07-summary');

    try {
      await tl.wait(300);
      await Guide01.showAsset(autoship);
      showElement(grid);

      await Guide01.panelTitle("오토십, 이것만 기억하세요!'", 0, tl);
      await Guide01.panelDesc('오토십의 핵심 이용 기준을 정리합니다.', 700, tl);

      await tl.wait(4700);
      if(cancelled()) return;
      document.getElementById('s07-c1').innerHTML = '<strong>3개월 정기 구독</strong><br>1 · 2 · 3개월';
      await enterElement('#s07-c1', { duration: 400 });
      await Guide01.panelBullets(['3개월 단위 정기 구독'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      document.getElementById('s07-c2').innerHTML = '<small>판매가 → 25% → 회원가</small><br><strong>회원가 +20% 할인</strong>';
      await enterElement('#s07-c2', { duration: 400 });
      await Guide01.panelAddBullet('판매가에서 25% 할인된 회원가에 추가 20% 할인', 0, tl, ['3개월 단위 정기 구독']);

      await tl.wait(8000);
      if(cancelled()) return;
      document.getElementById('s07-c3').innerHTML = '<strong>결제·배송: 한 번에</strong><br><strong>EP: 매월 ×3회</strong>';
      await enterElement('#s07-c3', { duration: 400 });
      await Guide01.panelSwapDesc('결제·배송 시점과 EP 발생 시점을 구분하세요.', 0, tl);
      await Guide01.panelBullets(['결제·배송: 3개월분을 한 번에'], 0, tl);

      await tl.wait(4000);
      if(cancelled()) return;
      await Guide01.panelAddBullet('EP: 매월 1개월분씩 총 3회', 0, tl, ['결제·배송: 3개월분을 한 번에']);

      await tl.wait(5000);
      if(cancelled()) return;
      document.getElementById('s07-c4').innerHTML = '<strong>추천회원 1인당 매월 1P</strong>';
      await enterElement('#s07-c4', { duration: 400 });
      var rec = document.getElementById('scene07-recommend');
      rec.style.left = '78%'; rec.style.top = '72%'; rec.style.transform = 'scale(.85)';
      await Guide01.showAsset(rec);
      await Guide01.panelSwapDesc('오토십은 추천 활동과 보상플랜에도 연결됩니다.', 0, tl);
      await Guide01.panelBullets(['추천회원 구독 유지 시 매월 추천포인트'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      var base = document.getElementById('scene07-base');
      base.style.left = '78%'; base.style.top = '82%'; base.style.transform = 'scale(.85)';
      await Guide01.showAsset(base);
      document.getElementById('s07-c4').innerHTML += '<br><small>BASE 조건에 활용</small>';
      await Guide01.panelAddBullet('BASE사업자 조건에 활용', 0, tl, ['추천회원 구독 유지 시 매월 추천포인트']);

      await tl.wait(6000);
      if(cancelled()) return;
      hideElement(grid); hideElement(rec); hideElement(base);
      autoship.style.top = '28%';
      var flow = document.createElement('div');
      flow.className = 'g01-flow';
      flow.innerHTML =
        '<div class="g01-flow-step">제품 경험</div><span class="g01-flow-arrow">→</span>' +
        '<div class="g01-flow-step">추천 활동</div><span class="g01-flow-arrow">→</span>' +
        '<div class="g01-flow-step">비즈니스</div>';
      canvas.appendChild(flow);
      await Guide01.panelSwapDesc('꾸준한 제품 경험을 추천 활동과 비즈니스로 연결합니다.', 0, tl);

      await tl.wait(8000);
      if(cancelled()) return;
      hideElement(flow);
      Guide01.addCard(canvas, 'scene07-sim', '시뮬레이션으로 확인하기<br><small>이용 방법 · 주요 기준</small>', '');
      var sim = document.getElementById('scene07-sim');
      sim.style.left = '50%'; sim.style.top = '52%'; sim.style.transform = 'translateX(-50%)';
      await Guide01.showCard(sim);
      await Guide01.panelSwapDesc('시뮬레이션을 통해 이용 방법과 주요 기준을 다시 확인해 보세요.', 0, tl);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
