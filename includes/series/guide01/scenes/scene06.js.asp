<script>
var Guide01Scene06 = defineScene({
  id: 'guide01-scene-06',
  title: "구독 중 추가,변(경)'해지는 어떻게 하나요?",
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas, 'guide01-scene06');
      Guide01.addAsset(canvas, 'autoship_icon', 'scene06-autoship');
      var subs = document.createElement('div');
      subs.id = 'scene06-subscriptions';
      subs.className = 'g01-product-grid is-hidden';
      subs.style.cssText = 'top:36%;width:180px';
      ['A','B'].forEach(function(l){
        var p = document.createElement('div');
        p.className = 'g01-product' + (l === 'A' ? ' is-selected' : '');
        p.textContent = '품목 ' + l + (l === 'A' ? '<br><small>구독 중</small>' : '');
        p.innerHTML = '품목 ' + l + (l === 'A' ? '<br><small>구독 중</small>' : '');
        subs.appendChild(p);
      });
      canvas.appendChild(subs);
      Guide01.disclaimer(canvas);
    },
    reset: function(){ Guide01.resetScene('guide01-scene06'); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene06-autoship');
    autoship.style.left = '50%'; autoship.style.top = '10%'; autoship.style.transform = 'translateX(-50%)';

    try {
      await tl.wait(300);
      await Guide01.showAsset(autoship);
      showElement(document.getElementById('scene06-subscriptions'));

      await Guide01.panelTitle("구독 중 추가,변(경)'해지는 어떻게 하나요?", 0, tl);
      await Guide01.panelDesc('아직 구독하지 않은 다른 상품은 추가 신청할 수 있습니다.', 700, tl);

      await tl.wait(3700);
      if(cancelled()) return;
      var subs = document.getElementById('scene06-subscriptions');
      subs.children[1].classList.add('is-selected');
      Guide01.addCard(canvas, 'scene06-add-ok', '추가 가능 ✓', '');
      var ok = document.getElementById('scene06-add-ok');
      ok.style.left = '62%'; ok.style.top = '52%';
      await Guide01.showCard(ok);
      await Guide01.panelBullets(['다른 상품 추가 가능'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      var dup = document.createElement('div');
      dup.className = 'g01-product is-deny';
      dup.textContent = 'A';
      dup.style.cssText = 'position:absolute;left:70%;top:45%;z-index:12';
      canvas.appendChild(dup);
      Guide01.addCard(canvas, 'scene06-dup', '중복 추가 불가', 'g01-deny');
      var dupLbl = document.getElementById('scene06-dup');
      dupLbl.style.left = '70%'; dupLbl.style.top = '58%';
      await Guide01.showCard(dupLbl);
      await Guide01.panelAddBullet('동일 상품 중복 추가 불가', 0, tl, ['다른 상품 추가 가능']);

      await tl.wait(4000);
      if(cancelled()) return;
      hideElement(dup); hideElement(dupLbl);
      Guide01.addCard(canvas, 'scene06-change', 'A → C 변경<br>기존 상품 변경 불가 ✕', 'g01-deny');
      var chg = document.getElementById('scene06-change');
      chg.style.left = '50%'; chg.style.top = '58%'; chg.style.transform = 'translateX(-50%)';
      await Guide01.showCard(chg);
      await Guide01.panelSwapDesc('다른 상품 추가와 기존 구독 상품 변경은 구분됩니다.', 0, tl);
      await Guide01.panelAddBullet('구독 중인 상품 변경 불가', 0, tl, ['동일 상품 중복 추가 불가']);

      await tl.wait(5000);
      if(cancelled()) return;
      hideElement(subs); hideElement(ok); hideElement(chg);
      Guide01.addCard(canvas, 'scene06-cancel', '해지 신청', '');
      var cancel = document.getElementById('scene06-cancel');
      cancel.style.left = '50%'; cancel.style.top = '32%'; cancel.style.transform = 'translateX(-50%)';
      await Guide01.showCard(cancel);
      var timeline = document.createElement('div');
      timeline.className = 'g01-timeline';
      timeline.style.cssText = 'top:48%';
      timeline.innerHTML =
        '<div class="g01-timeline-row"><span class="g01-timeline-month is-active">1</span><span class="g01-timeline-month is-active">2</span><span class="g01-timeline-month is-active">3</span><small>현재 구독 유지</small></div>' +
        '<div class="g01-timeline-row"><span class="g01-timeline-month is-stop">4</span><span class="g01-timeline-month is-stop">5</span><span class="g01-timeline-month is-stop">6</span><small>다음 자동결제 중단</small></div>';
      canvas.appendChild(timeline);
      await Guide01.panelSwapDesc('해지 신청 시 다음 자동결제부터 중단됩니다.', 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      await Guide01.panelBullets(['현재 3개월 구독은 유지'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      await Guide01.panelAddBullet('4개월 차의 다음 자동결제부터 중단', 0, tl, ['현재 3개월 구독은 유지']);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
