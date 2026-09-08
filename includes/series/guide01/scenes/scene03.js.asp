<script>
var Guide01Scene03 = defineScene({
  id: 'guide01-scene-03',
  title: '어떻게 구독하나요?',
  duration: 0,

  motion: {
    mountCanvas: function(canvas){
      Guide01.mountStage(canvas, 'guide01-scene03');
      MemberUnit.mountMain(canvas, { id: 'scene03-member', includeBaseBadge: false, imageSrc: MemberUnit.IMGS.people, imageAlt: '앨트웰 회원' });
      var mem = document.getElementById('scene03-member');
      if(mem){ mem.style.left = '18%'; mem.style.top = '18%'; mem.classList.add('is-hidden'); }
      Guide01.addAsset(canvas, 'autoship_icon', 'scene03-autoship');
      var grid = document.createElement('div');
      grid.id = 'scene03-products';
      grid.className = 'g01-product-grid g01-grid-5 is-hidden';
      ['A','B','C','D','E'].forEach(function(l){
        var p = document.createElement('div');
        p.className = 'g01-product';
        p.setAttribute('data-item', l);
        p.textContent = l;
        grid.appendChild(p);
      });
      canvas.appendChild(grid);
      var counter = document.createElement('div');
      counter.id = 'scene03-counter';
      counter.className = 'g01-counter is-hidden';
      counter.style.top = '72%';
      counter.textContent = '선택 0 / 최대 5';
      canvas.appendChild(counter);
      Guide01.disclaimer(canvas);
    },
    reset: function(){ Guide01.resetScene('guide01-scene03'); }
  },

  panel: { reset: function(){ ScenePanel.reset(); } },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;
    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var tl = Guide01.timeline(ctx);

    var autoship = document.getElementById('scene03-autoship');
    autoship.style.left = '72%'; autoship.style.top = '14%';
    var member = document.getElementById('scene03-member');
    var grid = document.getElementById('scene03-products');
    grid.style.top = '38%';
    var counter = document.getElementById('scene03-counter');

    try {
      await tl.wait(300);
      await MotionMemberEnter.run({}, { target: 'scene03-member', duration: 700 });
      Guide01.addCard(canvas, 'scene03-member-lbl', '앨트웰 회원', 'g01-muted');
      var lbl = document.getElementById('scene03-member-lbl');
      lbl.style.left = '18%'; lbl.style.top = '32%';
      await Guide01.showCard(lbl);

      await Guide01.panelTitle('어떻게 구독하나요?', 0, tl);
      await Guide01.panelDesc('앨트웰 회원이라면 누구나 신청할 수 있습니다.', 700, tl);

      await tl.wait(3700);
      if(cancelled()) return;
      await Guide01.showAsset(autoship);
      showElement(grid);
      await Guide01.panelBullets(['지정된 대상 상품 중 필요한 상품 선택'], 0, tl);

      await tl.wait(5000);
      if(cancelled()) return;
      showElement(counter);
      var items = grid.querySelectorAll('.g01-product');
      for(var i = 0; i < 5; i++){
        items[i].classList.add('is-selected');
        counter.textContent = '선택 ' + (i + 1) + ' / 최대 5';
        await wait(400);
      }
      await Guide01.panelAddBullet('최대 5개 품목까지 신청', 0, tl, ['지정된 대상 상품 중 필요한 상품 선택']);

      await tl.wait(5000);
      if(cancelled()) return;
      items.forEach(function(el){ el.classList.remove('is-selected'); });
      items[0].classList.add('is-selected');
      counter.textContent = '중복 신청 예시';
      var dup = document.createElement('div');
      dup.className = 'g01-product is-deny';
      dup.textContent = 'A';
      dup.style.position = 'absolute';
      dup.style.left = '60%';
      dup.style.top = '50%';
      dup.id = 'scene03-dup';
      canvas.appendChild(dup);
      showElement(dup);
      Guide01.addCard(canvas, 'scene03-dup-lbl', '동일한 3개월 구독기간 · 중복 불가', 'g01-deny');
      var dupLbl = document.getElementById('scene03-dup-lbl');
      dupLbl.style.left = '50%'; dupLbl.style.top = '62%'; dupLbl.style.transform = 'translateX(-50%)';
      await Guide01.showCard(dupLbl);
      await Guide01.panelSwapDesc('동일한 3개월 구독기간에는 같은 상품을 중복 신청할 수 없습니다.', 0, tl);
      await Guide01.panelBullets(['같은 상품 중복 신청 불가'], 0, tl);

      await tl.wait(13000);
      if(cancelled()) return;
      hideElement(dup); hideElement(dupLbl);
      items[0].classList.add('is-selected');
      items[1].classList.add('is-selected');
      counter.textContent = '선택 예시: A + B ✓';
      await Guide01.panelSwapDesc('필요한 서로 다른 상품을 선택해 경험하는 제도입니다.', 0, tl);
      await Guide01.panelBullets(['서로 다른 상품 선택', '최대 5개 품목까지 신청'], 0, tl);

      await Guide01.endScene(ctx, canvas, tl);
    } catch(e){ if(!cancelled()) throw e; }
  }
});
</script>
