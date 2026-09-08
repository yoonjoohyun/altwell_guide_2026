<script>
var Guide01Scene04 = defineScene({
  id: 'guide01-scene-04',
  title: '결제와 배송은 어떻게 되나요?',
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas, 'guide01-scene04');
      Guide01.addAsset(canvas, 'autoship_icon', 'scene04-autoship');
      Guide01.addCard(canvas, 'scene04-agree', '구독 약정', '');
      Guide01.addCard(canvas, 'scene04-payment', '💳<br>3개월분<br>일괄 결제', '');
      Guide01.addCard(canvas, 'scene04-ship', '📦<br>3개월분<br>일괄 배송', '');
      var tl = document.createElement('div');
      tl.id = 'scene04-timeline';
      tl.className = 'g01-timeline is-hidden';
      tl.innerHTML =
        '<div class="g01-timeline-row"><span class="g01-timeline-month is-active">1</span><span class="g01-timeline-month is-active">2</span><span class="g01-timeline-month is-active">3</span><small style="margin-left:6px">첫 구독기간</small></div>' +
        '<div class="g01-timeline-row" id="scene04-row2"><span class="g01-timeline-month">4</span><span class="g01-timeline-month">5</span><span class="g01-timeline-month">6</span><small style="margin-left:6px">다음 구독기간</small></div>';
      canvas.appendChild(tl);
    },
    reset: function(){ Guide01.resetScene('guide01-scene04'); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene04-autoship');
    autoship.style.left = '50%'; autoship.style.top = '10%'; autoship.style.transform = 'translateX(-50%)';

    try {
      await tl.wait(300);
      await Guide01.showAsset(autoship);
      var agree = document.getElementById('scene04-agree');
      agree.style.left = '50%'; agree.style.top = '28%'; agree.style.transform = 'translateX(-50%)';
      await Guide01.showCard(agree);

      await Guide01.panelTitle('결제와 배송은 어떻게 되나요?', 0, tl);
      await Guide01.panelDesc('결제와 배송은 3개월분이 한 번에 이루어집니다.', 700, tl);

      await tl.wait(3700);
      if(cancelled()) return;
      hideElement(agree);
      var pay = document.getElementById('scene04-payment');
      pay.style.left = '32%'; pay.style.top = '40%';
      await Guide01.showCard(pay);
      await Guide01.panelBullets(['결제: 3개월분 일괄 결제'], 0, tl);

      await tl.wait(3000);
      if(cancelled()) return;
      var ship = document.getElementById('scene04-ship');
      ship.style.left = '62%'; ship.style.top = '40%';
      await Guide01.showCard(ship);
      await Guide01.panelAddBullet('배송: 3개월분 일괄 배송', 0, tl, ['결제: 3개월분 일괄 결제']);

      await tl.wait(5000);
      if(cancelled()) return;
      Guide01.addCard(canvas, 'scene04-install', '카드사에 따라 할부 가능', 'g01-muted');
      var inst = document.getElementById('scene04-install');
      inst.style.left = '50%'; inst.style.top = '58%'; inst.style.transform = 'translateX(-50%)';
      await Guide01.showCard(inst);
      await Guide01.panelAddBullet('카드사에 따라 할부 이용 가능', 0, tl, ['결제: 3개월분 일괄 결제', '배송: 3개월분 일괄 배송']);

      await tl.wait(5000);
      if(cancelled()) return;
      hideElement(pay); hideElement(ship); hideElement(inst);
      var timeline = document.getElementById('scene04-timeline');
      timeline.style.top = '38%';
      showElement(timeline);
      await Guide01.panelSwapDesc('해지 신청이 없으면 다음 3개월 구독이 자동으로 이어집니다.', 0, tl);

      await tl.wait(6000);
      if(cancelled()) return;
      var row2 = document.getElementById('scene04-row2');
      row2.querySelectorAll('.g01-timeline-month').forEach(function(m){ m.classList.add('is-active'); });
      Guide01.addCard(canvas, 'scene04-renew', '해지 신청이 없으면 → 4개월 차 자동연장', '');
      var renew = document.getElementById('scene04-renew');
      renew.style.left = '50%'; renew.style.top = '62%'; renew.style.transform = 'translateX(-50%)';
      await Guide01.showCard(renew);
      await Guide01.panelBullets(['4개월 차에 다음 3개월분 자동 결제', '3개월 단위로 구독 갱신'], 0, tl);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
