<script>
var Guide01Scene02 = defineScene({
  id: 'guide01-scene-02',
  title: '오토십을 이용하면 무엇이 좋은가요?',
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas, 'guide01-scene02');
      Guide01.addAsset(canvas, 'autoship_icon', 'scene02-autoship');
      Guide01.addCard(canvas, 'scene02-benefit-a', '할인 혜택', '');
      Guide01.addCard(canvas, 'scene02-benefit-b', '제품 경험', '');
      var ladder = document.createElement('div');
      ladder.id = 'scene02-price';
      ladder.className = 'g01-price-ladder is-hidden';
      ladder.innerHTML =
        '<div class="g01-price-step" id="step-retail">판매가</div>' +
        '<span class="g01-arrow">→</span>' +
        '<div class="g01-price-step is-active" id="step-member">회원가<br><small>25% 할인</small></div>' +
        '<span class="g01-arrow">→</span>' +
        '<div class="g01-price-step is-dim" id="step-auto">오토십<br><small>+20%</small></div>';
      canvas.appendChild(ladder);
      Guide01.addMonthRow(canvas, 'scene02-months', ['1개월', '2개월', '3개월'], '55%');
      Guide01.addCard(canvas, 'scene02-product', '<div class="g01-silhouette"></div>꾸준한 사용', '');
      Guide01.addCard(canvas, 'scene02-cashback', '매월 캐시백<br><small>지위에 따라 적용</small>', '');
      Guide01.addAsset(canvas, 'base_business_icon', 'scene02-base');
      Guide01.addAsset(canvas, 'recommend_bonus_icon', 'scene02-recommend');
      Guide01.mountReferral(canvas);
    },
    reset: function(){ Guide01.resetScene('guide01-scene02'); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene02-autoship');
    autoship.style.left = '50%';
    autoship.style.top = '12%';
    autoship.style.transform = 'translateX(-50%) scale(1.1)';

    try {
      await tl.wait(300);
      await Guide01.showAsset(autoship);
      var ba = document.getElementById('scene02-benefit-a');
      var bb = document.getElementById('scene02-benefit-b');
      ba.style.left = '28%'; ba.style.top = '32%';
      bb.style.left = '62%'; bb.style.top = '32%';
      await Guide01.showCard(ba);
      await Guide01.showCard(bb);

      await Guide01.panelTitle('오토십을 이용하면 무엇이 좋은가요?', 0, tl);
      await Guide01.panelDesc('지속적인 할인 혜택과 충분한 제품 경험이 가장 큰 장점입니다.', 700, tl);

      await tl.wait(5700);
      if(cancelled()) return;
      hideElement(ba); hideElement(bb);
      await Guide01.showCard(document.getElementById('scene02-price'));
      await Guide01.panelBullets(['판매가에서 25% 할인된 회원가'], 0, tl);

      await tl.wait(4000);
      if(cancelled()) return;
      document.getElementById('step-auto').classList.remove('is-dim');
      document.getElementById('step-auto').classList.add('is-active');
      await Guide01.panelAddBullet('회원가에서 추가 20% 할인', 0, tl, ['판매가에서 25% 할인된 회원가']);

      await tl.wait(6000);
      if(cancelled()) return;
      hideElement(document.getElementById('scene02-price'));
      var prod = document.getElementById('scene02-product');
      prod.style.left = '50%'; prod.style.top = '38%'; prod.style.transform = 'translateX(-50%)';
      await Guide01.showCard(prod);
      showElement(document.getElementById('scene02-months'));
      await Guide01.activateMonths(document.getElementById('scene02-months'), [0, 1, 2]);
      await Guide01.panelSwapDesc('3개월 동안 꾸준히 사용하며 제품을 충분히 경험합니다.', 0, tl);

      await tl.wait(7000);
      if(cancelled()) return;
      hideElement(document.getElementById('scene02-months'));
      hideElement(prod);
      await Guide01.showReferralPair({ me: document.getElementById('member-unit-main'), child: document.getElementById('member-unit-child'),
        lblMe: document.getElementById('g01-label-me'), lblChild: document.getElementById('g01-label-child') });
      await Guide01.panelBullets(['쌓인 제품 경험을 추천 활동으로 연결'], 0, tl);

      await tl.wait(6000);
      if(cancelled()) return;
      hideElement('#member-unit-main'); hideElement('#member-unit-child');
      hideElement('#g01-label-me'); hideElement('#g01-label-child');
      var cb = document.getElementById('scene02-cashback');
      cb.style.left = '50%'; cb.style.top = '45%'; cb.style.transform = 'translateX(-50%)';
      await Guide01.showCard(cb);
      await Guide01.panelSwapDesc('구독 유지와 추천 활동은 보상플랜과도 연결됩니다.', 0, tl);
      await Guide01.panelBullets(['매월 지위에 따른 캐시백'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      hideElement(cb);
      var base = document.getElementById('scene02-base');
      var rec = document.getElementById('scene02-recommend');
      base.style.left = '28%'; base.style.top = '52%';
      rec.style.left = '68%'; rec.style.top = '52%';
      await Guide01.showAsset(base);
      await Guide01.showAsset(rec);
      await Guide01.panelAddBullet('BASE사업자 조건에 활용', 0, tl, ['매월 지위에 따른 캐시백']);
      await Guide01.panelAddBullet('추천회원 구독에 따른 추천포인트', 0, tl, ['매월 지위에 따른 캐시백', 'BASE사업자 조건에 활용']);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
