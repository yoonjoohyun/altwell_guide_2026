<script>
var Guide01Scene01 = defineScene({
  id: 'guide01-scene-01',
  title: '오토십이란?',
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas);
      Guide01.addAsset(canvas, 'autoship_icon', 'scene01-autoship');
      Guide01.addMonthRow(canvas, 'scene01-months', ['1개월', '2개월', '3개월'], '38%');
      Guide01.addCard(canvas, 'scene01-months-wrap', '<div class="g01-group-label">3개월 정기 구독</div>', '');
      Guide01.addCard(canvas, 'scene01-product', '<div class="g01-silhouette"></div>할인 혜택', '');
      Guide01.addCard(canvas, 'scene01-cashback', '캐시백', '');
      Guide01.addAsset(canvas, 'recommend_bonus_icon', 'scene01-recommend');
      Guide01.addAsset(canvas, 'base_business_icon', 'scene01-base');
      Guide01.mountReferral(canvas);
    },
    reset: function(){ Guide01.resetScene(); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene01-autoship');
    var months = document.getElementById('scene01-months');
    var product = document.getElementById('scene01-product');
    var cashback = document.getElementById('scene01-cashback');
    var recommend = document.getElementById('scene01-recommend');
    var base = document.getElementById('scene01-base');
    var pair = { me: document.getElementById('member-unit-main'), child: document.getElementById('member-unit-child'),
      lblMe: document.getElementById('g01-label-me'), lblChild: document.getElementById('g01-label-child') };

    try {
      await tl.wait(300);
      if(cancelled()) return;
      await Guide01.showAsset(autoship);

      await Guide01.panelTitle('오토십이란?', 0, tl);
      await Guide01.panelDesc('주요 상품을 3개월 단위로 정기 구독하는 서비스입니다.', 700, tl);

      await tl.wait(1700);
      if(cancelled()) return;
      autoship.classList.add('g01-top');
      showElement(months);
      await Guide01.activateMonths(months, [0, 1, 2]);

      await tl.wait(3700);
      if(cancelled()) return;
      product.style.left = '50%';
      product.style.top = '58%';
      product.style.transform = 'translateX(-50%)';
      await Guide01.showCard(product);

      await tl.wait(2000);
      if(cancelled()) return;
      await Guide01.panelBullets(['할인된 가격으로 꾸준한 제품 경험'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      cashback.style.left = '58%';
      cashback.style.top = '52%';
      await Guide01.showCard(cashback);

      await tl.wait(2000);
      if(cancelled()) return;
      await Guide01.panelAddBullet('캐시백 혜택', 0, tl, ['할인된 가격으로 꾸준한 제품 경험']);

      await tl.wait(2000);
      if(cancelled()) return;
      hideElement(months);
      hideElement(cashback);
      hideElement(product);
      await Guide01.showReferralPair(pair);
      autoship.style.left = '74%';
      autoship.style.top = '62%';

      await tl.wait(5000);
      if(cancelled()) return;
      recommend.style.left = '22%';
      recommend.style.top = '68%';
      await Guide01.showAsset(recommend);
      var token = document.createElement('div');
      token.className = 'g01-token';
      token.textContent = '1P';
      token.style.left = '74%';
      token.style.top = '48%';
      canvas.appendChild(token);
      showElement(token);
      await wait(600);
      token.style.transition = 'left .6s ease, top .6s ease';
      token.style.left = '26%';
      token.style.top = '48%';

      await Guide01.panelSwapDesc('내가 추천한 회원이 구독을 유지하면 추천인에게 포인트가 발생합니다.', 0, tl);
      await Guide01.panelBullets(['추천회원 1인당 매월 1포인트', '추천포인트는 추천보너스로 연결'], 0, tl);

      await tl.wait(8000);
      if(cancelled()) return;
      hideElement(pair.me);
      hideElement(pair.child);
      hideElement(pair.lblMe);
      hideElement(pair.lblChild);
      hideElement(recommend);
      if(token.parentNode) token.parentNode.removeChild(token);
      autoship.style.left = '30%';
      autoship.style.top = '40%';
      base.style.left = '68%';
      base.style.top = '48%';
      await Guide01.showAsset(base);
      Guide01.addCard(canvas, 'scene01-base-note', '매칭보너스·승급의 기반<br><small>각 조건 충족 시</small>', 'g01-muted');
      var note = document.getElementById('scene01-base-note');
      note.style.left = '62%';
      note.style.top = '62%';
      await Guide01.showCard(note);

      await Guide01.panelSwapDesc('오토십은 BASE사업자 조건에도 활용됩니다.', 0, tl);
      await Guide01.panelBullets(['매칭보너스와 승급으로 이어지는 비즈니스 기반', '각 보상·승급 조건 충족 필요'], 0, tl);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
