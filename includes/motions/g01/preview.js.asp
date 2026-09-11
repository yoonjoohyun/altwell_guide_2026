<script>
/* G01 Zoned Animation — asset_design.asp 미리보기 */
var G01AnimPreview = (function(){
  var DEMO_ID = 'g01-demo-wrap';
  var busy = false;

  function canvas(){
    return document.getElementById('g01-anim-canvas');
  }

  function cloneTemplate(id){
    var wrap = document.querySelector('#guide01-templates [data-template="' + id + '"]');
    if(!wrap || !wrap.firstElementChild) return null;
    return wrap.firstElementChild.cloneNode(true);
  }

  function mountDemo(zone, templateId, scale){
    var c = canvas();
    if(!c) return null;
    c.innerHTML = '';
    var node = cloneTemplate(templateId || 'autoship_icon');
    if(!node) return null;

    var wrap = document.createElement('div');
    wrap.id = DEMO_ID;
    wrap.className = 'g01-zone-wrap is-hidden';
    G01ZonedAnim.placeAtZone(wrap, zone || 'd4');

    var inner = document.createElement('div');
    inner.className = 'g01-float-inner';
    var baseScale = scale != null ? scale : 1;
    inner.style.setProperty('--g01-base-scale', String(baseScale));
    inner.style.transform = 'scale(' + baseScale + ')';

    node.classList.add('guide01-asset');
    inner.appendChild(node);
    wrap.appendChild(inner);
    c.appendChild(wrap);
    wrap._float = inner;
    return wrap;
  }

  function mountBadgeDemo(templateId, zone, scale){
    var wrap = mountDemo(zone || 'd4', templateId, scale != null ? scale : 1.15);
    if(!wrap) return null;
    showElement(wrap);
    var badge = G01BadgeFold.resolveBadge(wrap);
    return { wrap: wrap, badge: badge };
  }

  function badgeTarget(){
    return '#' + DEMO_ID + ' [class*="_icon"]';
  }

  function setStatus(text){
    var el = document.getElementById('g01-anim-status');
    if(el) el.textContent = text;
  }

  async function run(label, fn){
    if(busy) return;
    busy = true;
    setStatus(label + ' 재생 중…');
    try {
      await fn();
      setStatus(label + ' 완료');
    } catch(e){
      setStatus(label + ' 오류');
    }
    busy = false;
  }

  var demos = {
    enterFade: function(){
      return run('Enter Fade', async function(){
        mountDemo('d4', 'product_silhouette_card', 0.88);
        await MotionG01ZonedEnterFade.run({}, { target: '#' + DEMO_ID, duration: 420 });
      });
    },
    enterPop: function(){
      return run('Enter Pop', async function(){
        mountDemo('d4', 'autoship_icon', 1);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 520 });
      });
    },
    enterDrop: function(){
      return run('Enter Drop', async function(){
        mountDemo('b4', 'cashback_icon', 0.9);
        await MotionG01ZonedEnterDrop.run({}, { target: '#' + DEMO_ID, duration: 520 });
      });
    },
    popScale: function(){
      return run('Pop Scale', async function(){
        mountDemo('c2', 'price_step_card', 0.86);
        showElement(document.getElementById(DEMO_ID));
        await MotionG01ZonedPopScale.run({}, { target: '#' + DEMO_ID, duration: 480 });
      });
    },
    exit: function(){
      return run('Exit', async function(){
        mountDemo('d4', 'autoship_icon', 1);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 400 });
        await wait(400);
        await MotionG01ZonedExit.run({}, { target: '#' + DEMO_ID, duration: 280 });
      });
    },
    idle: function(){
      return run('Idle Float', async function(){
        mountDemo('d4', 'autoship_icon', 1);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 480 });
        MotionG01ZonedIdleStart.run({}, { target: '#' + DEMO_ID });
        setStatus('Idle Float — 3초 후 자동 정지');
        await wait(3000);
        MotionG01ZonedIdleStop.run({}, { target: '#' + DEMO_ID });
      });
    },
    move: function(){
      return run('Move Zone', async function(){
        mountDemo('f4', 'product_silhouette_card', 0.72);
        await MotionG01ZonedEnterFade.run({}, { target: '#' + DEMO_ID, duration: 320 });
        await wait(300);
        await MotionG01ZonedMove.run({}, {
          target: '#' + DEMO_ID,
          zone: 'd4',
          duration: 720,
          toScale: 0.96
        });
      });
    },
    sequence: function(){
      return run('Sequence (씬1 요약)', async function(){
        mountDemo('d4', 'autoship_icon', 1);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 480 });
        MotionG01ZonedIdleStart.run({}, { target: '#' + DEMO_ID });
        await wait(2000);
        MotionG01ZonedIdleStop.run({}, { target: '#' + DEMO_ID });
        await MotionG01ZonedExit.run({}, { target: '#' + DEMO_ID, duration: 280 });
      });
    },
    badgeUnfoldAutoship: function(){
      return run('Badge Unfold — 오토십', async function(){
        mountBadgeDemo('autoship_icon_c', 'd4', 1.2);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 400 });
        await MotionG01BadgeUnfold.run({}, { target: badgeTarget(), duration: 620 });
      });
    },
    badgeFoldAutoship: function(){
      return run('Badge Fold — 오토십', async function(){
        mountBadgeDemo('autoship_icon', 'd4', 1.2);
        showElement(document.getElementById(DEMO_ID));
        await wait(300);
        await MotionG01BadgeFold.run({}, { target: badgeTarget(), duration: 744 });
      });
    },
    badgeUnfoldBase: function(){
      return run('Badge Unfold — 베이스', async function(){
        mountBadgeDemo('base_business_icon_c', 'd4', 1.2);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 400 });
        await MotionG01BadgeUnfold.run({}, { target: badgeTarget(), duration: 620 });
      });
    },
    badgeFoldBase: function(){
      return run('Badge Fold — 베이스', async function(){
        mountBadgeDemo('base_business_icon', 'd4', 1.2);
        await wait(300);
        await MotionG01BadgeFold.run({}, { target: badgeTarget(), duration: 744 });
      });
    },
    badgeUnfoldRecommend: function(){
      return run('Badge Unfold — 추천보너스', async function(){
        mountBadgeDemo('recommend_bonus_icon_c', 'd4', 1.2);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 400 });
        await MotionG01BadgeUnfold.run({}, { target: badgeTarget(), duration: 620 });
      });
    },
    badgeFoldRecommend: function(){
      return run('Badge Fold — 추천보너스', async function(){
        mountBadgeDemo('recommend_bonus_icon', 'd4', 1.2);
        await wait(300);
        await MotionG01BadgeFold.run({}, { target: badgeTarget(), duration: 744 });
      });
    },
    badgeCycle: function(){
      return run('Badge Cycle — 오토십 펼침↔접힘', async function(){
        mountBadgeDemo('autoship_icon_c', 'd4', 1.2);
        await MotionG01ZonedEnterPop.run({}, { target: '#' + DEMO_ID, duration: 400 });
        await MotionG01BadgeUnfold.run({}, { target: badgeTarget(), duration: 620 });
        await wait(800);
        await MotionG01BadgeFold.run({}, { target: badgeTarget(), duration: 744 });
        await wait(600);
        await MotionG01BadgeUnfold.run({}, { target: badgeTarget(), duration: 620 });
      });
    }
  };

  function init(){
    var buttons = document.querySelectorAll('[data-g01-anim]');
    for(var i = 0; i < buttons.length; i++){
      buttons[i].addEventListener('click', function(){
        var key = this.getAttribute('data-g01-anim');
        if(demos[key]) demos[key]();
      });
    }
    mountBadgeDemo('autoship_icon_c', 'd4', 1.15);
    setStatus('버튼을 눌러 Motion Component를 확인하세요.');
  }

  return { init: init, mountDemo: mountDemo };
})();
</script>
