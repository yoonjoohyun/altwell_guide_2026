<script>
var Guide01Scene05 = defineScene({
  id: 'guide01-scene-05',
  title: 'E.P와 추천포인트는 어떻게 발생하나요?',
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas, 'guide01-scene05');
      Guide01.addAsset(canvas, 'autoship_icon', 'scene05-autoship');
      Guide01.addCard(canvas, 'scene05-pay', '3개월분 일괄 결제', '');
      var epRow = document.createElement('div');
      epRow.id = 'scene05-ep-months';
      epRow.className = 'g01-ep-row is-hidden';
      epRow.style.cssText = 'position:absolute;left:50%;top:48%;transform:translateX(-50%);z-index:11';
      ['1개월 차','2개월 차','3개월 차'].forEach(function(lb){
        var c = document.createElement('div');
        c.className = 'g01-ep-card';
        c.innerHTML = lb + '<br>1개월분 EP';
        epRow.appendChild(c);
      });
      canvas.appendChild(epRow);
      Guide01.mountReferral(canvas);
      Guide01.addAsset(canvas, 'recommend_bonus_icon', 'scene05-recommend');
    },
    reset: function(){ Guide01.resetScene('guide01-scene05'); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene05-autoship');
    autoship.style.left = '50%'; autoship.style.top = '10%'; autoship.style.transform = 'translateX(-50%)';

    try {
      await tl.wait(300);
      await Guide01.showAsset(autoship);
      var pay = document.getElementById('scene05-pay');
      pay.style.left = '50%'; pay.style.top = '24%'; pay.style.transform = 'translateX(-50%)';
      await Guide01.showCard(pay);

      await Guide01.panelTitle('E.P와 추천포인트는 어떻게 발생하나요?', 0, tl);
      await Guide01.panelDesc('결제는 한 번에, EP는 매월 나누어 발생합니다.', 700, tl);

      await tl.wait(3700);
      if(cancelled()) return;
      Guide01.addCard(canvas, 'scene05-ep-note', '발생 시점은 매월', 'g01-muted');
      var note = document.getElementById('scene05-ep-note');
      note.style.left = '50%'; note.style.top = '36%'; note.style.transform = 'translateX(-50%)';
      await Guide01.showCard(note);

      await tl.wait(5500);
      if(cancelled()) return;
      hideElement(note);
      var epRow = document.getElementById('scene05-ep-months');
      showElement(epRow);
      var cards = epRow.querySelectorAll('.g01-ep-card');
      for(var i = 0; i < cards.length; i++){
        cards[i].classList.add('is-active');
        await wait(400);
      }
      await Guide01.panelBullets(['EP: 매월 1개월분씩 총 3회'], 0, tl);

      await tl.wait(8000);
      if(cancelled()) return;
      Guide01.addCard(canvas, 'scene05-cb', '캐시백 (매월)', 'g01-muted');
      var cb = document.getElementById('scene05-cb');
      cb.style.left = '50%'; cb.style.top = '62%'; cb.style.transform = 'translateX(-50%)';
      await Guide01.showCard(cb);
      await Guide01.panelAddBullet('발생 EP에 따른 캐시백도 매월 지급', 0, tl, ['EP: 매월 1개월분씩 총 3회']);

      await tl.wait(5000);
      if(cancelled()) return;
      hideElement(epRow); hideElement(cb); hideElement(pay);
      await Guide01.showReferralPair({ me: document.getElementById('member-unit-main'), child: document.getElementById('member-unit-child'),
        lblMe: document.getElementById('g01-label-me'), lblChild: document.getElementById('g01-label-child') });
      var rec = document.getElementById('scene05-recommend');
      rec.style.left = '22%'; rec.style.top = '68%';
      await Guide01.showAsset(rec);
      await Guide01.panelSwapDesc('추천회원 1인당 추천인에게 매월 1포인트가 발생합니다.', 0, tl);
      await Guide01.panelBullets(['추천회원의 오토십 구독기간 동안 발생'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      Guide01.addCard(canvas, 'scene05-products', '구독 상품 ×1 → ×2 → ×3<br><small>매월 1P 유지</small>', '');
      var prods = document.getElementById('scene05-products');
      prods.style.left = '74%'; prods.style.top = '58%';
      await Guide01.showCard(prods);
      await Guide01.panelBullets(['구독 상품 수가 아닌 이용 회원 수 기준'], 0, tl);

      await tl.wait(10000);
      if(cancelled()) return;
      await Guide01.panelAddBullet('한 명이 여러 상품을 구독해도 매월 1포인트', 0, tl, ['구독 상품 수가 아닌 이용 회원 수 기준']);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
