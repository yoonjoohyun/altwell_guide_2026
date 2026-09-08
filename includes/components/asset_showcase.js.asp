<script>
/* Asset Showcase — frame_layout.asp 컴포넌트 소개 데모 */
var AssetShowcase = (function(){
  var SCENE_MS = 4500;
  var SCENES = [
    {
      id: 'lev_d',
      title: 'D 지위',
      desc: 'Disumer'
    },
    {
      id: 'lev_p',
      title: 'P 지위',
      desc: 'Pioneer'
    },
    {
      id: 'lev_jp',
      title: 'JP 지위',
      desc: 'Junior Pioneer'
    },
    {
      id: 'lev_sp',
      title: 'SP 지위',
      desc: 'Senior Pioneer'
    },
    {
      id: 'lev_fc',
      title: 'FC 지위',
      desc: 'First Class'
    },
    {
      id: 'lev_gc',
      title: 'GC 지위',
      desc: 'Gold Class'
    },
    {
      id: 'lev_dc',
      title: 'DC 지위',
      desc: 'Diamond Class'
    },
    {
      id: 'lev_rf',
      title: 'RF 지위',
      desc: 'Royal Family'
    },
    {
      id: 'lev_crf',
      title: 'CRF 지위',
      desc: 'Crown Royal Family'
    },
    {
      id: 'lev_mrf',
      title: 'MRF 지위',
      desc: 'Major Royal Family'
    },
    {
      id: 'lev_srf',
      title: 'SRF 지위',
      desc: 'Special Royal Family'
    },
    {
      id: 'lev_irf',
      title: 'IRF 지위',
      desc: 'Imperial Royal Family'
    },
    {
      id: 'base_business_icon',
      title: '베이스 사업자',
      desc: 'BASE Business'
    },
    {
      id: 'autoship_icon',
      title: '오토십',
      desc: '20% 할인 구독 서비스'
    },
    {
      id: 'recommend_bonus_icon',
      title: '추천 보너스',
      desc: '추천회원 한명당 1point 책정'
    }
  ];

  var playing = false;
  var sceneIndex = 0;
  var elapsedMs = 0;
  var rafId = null;
  var lastTs = null;

  function fmtMs(ms){
    var s = Math.floor(ms / 1000);
    var m = Math.floor(s / 60);
    var sec = s % 60;
    return m + ':' + (sec < 10 ? '0' : '') + sec;
  }

  function totalMs(){
    return SCENES.length * SCENE_MS;
  }

  function sceneAtTime(ms){
    var idx = Math.floor(ms / SCENE_MS);
    return Math.max(0, Math.min(SCENES.length - 1, idx));
  }

  function cloneTemplate(id){
    var wrap = document.querySelector('#asset-templates [data-template="' + id + '"]');
    if(!wrap || !wrap.firstElementChild) return null;
    return wrap.firstElementChild.cloneNode(true);
  }

  function showPanel(scene){
    var title = document.getElementById('scene-title-main');
    var desc = document.getElementById('panel-scene-desc');
    var bullets = document.getElementById('scene-bullets');

    if(title){
      title.textContent = scene.title;
      title.classList.remove('is-hidden');
    }
    if(desc){
      desc.textContent = scene.desc;
      desc.classList.remove('is-hidden');
    }
    if(bullets){
      bullets.innerHTML = '';
      if(scene.bullets && scene.bullets.length){
        for(var i = 0; i < scene.bullets.length; i++){
          var li = document.createElement('li');
          li.className = 'bullet-item';
          li.innerHTML = '<span class="bullet-dot"></span><span class="bullet-text">' + scene.bullets[i] + '</span>';
          bullets.appendChild(li);
        }
        bullets.classList.remove('is-hidden');
      } else {
        bullets.classList.add('is-hidden');
      }
    }
  }

  function showMotion(scene, animate){
    var canvas = document.getElementById('motion-canvas');
    if(!canvas) return;
    var slot = document.getElementById('asset-showcase-slot');
    if(!slot){
      slot = document.createElement('div');
      slot.id = 'asset-showcase-slot';
      slot.className = 'asset-showcase-slot';
      canvas.appendChild(slot);
    }
    slot.innerHTML = '';
    var node = cloneTemplate(scene.id);
    if(node){
      if(animate !== false) node.classList.add('asset-enter');
      slot.appendChild(node);
    }
  }

  function renderTimelineMarkers(){
    var container = document.getElementById('lo-tl-markers');
    if(!container) return;
    container.innerHTML = '';
    var total = totalMs();
    for(var i = 1; i < SCENES.length; i++){
      var pct = (i * SCENE_MS / total) * 100;
      var mark = document.createElement('span');
      mark.className = 'lo-tl-marker';
      mark.style.left = pct + '%';
      container.appendChild(mark);
    }
  }

  function updateUI(){
    var total = totalMs();
    var pct = total > 0 ? Math.min(100, (elapsedMs / total) * 100) : 0;
    var tlf = document.getElementById('lo-tlf');
    var tlt = document.getElementById('lo-tlt');
    var cur = document.getElementById('time-current');
    var tot = document.getElementById('time-total');
    var sn = document.getElementById('scene-number');
    var tl = document.getElementById('lo-tl');

    if(tlf) tlf.style.width = pct + '%';
    if(tlt) tlt.style.left = pct + '%';
    if(cur) cur.textContent = fmtMs(elapsedMs);
    if(tot) tot.textContent = fmtMs(total);
    if(sn && SCENES[sceneIndex]){
      var label = '· ' + (sceneIndex + 1) + ' / ' + SCENES.length + ' · ' + SCENES[sceneIndex].title;
      sn.textContent = label;
      var caption = document.getElementById('scene-caption');
      if(caption) caption.title = label;
    }
    if(tl) tl.setAttribute('aria-valuenow', Math.round(pct));
  }

  function goToScene(index, animate){
    sceneIndex = Math.max(0, Math.min(SCENES.length - 1, index));
    elapsedMs = sceneIndex * SCENE_MS;
    showMotion(SCENES[sceneIndex], animate);
    showPanel(SCENES[sceneIndex]);
    updateUI();
  }

  function tick(ts){
    if(!playing){ lastTs = null; return; }
    if(lastTs) elapsedMs += ts - lastTs;
    lastTs = ts;

    var idx = sceneAtTime(elapsedMs);
    if(idx !== sceneIndex) goToScene(idx, true);

    if(elapsedMs >= totalMs()){
      elapsedMs = totalMs();
      playing = false;
      syncPlayBtn();
      updateUI();
      return;
    }

    updateUI();
    rafId = requestAnimationFrame(tick);
  }

  function syncPlayBtn(){
    var btn = document.getElementById('btn-play');
    if(!btn) return;
    btn.setAttribute('data-state', playing ? 'playing' : 'paused');
    btn.setAttribute('aria-label', playing ? '일시정지' : '재생');
  }

  function play(){
    if(elapsedMs >= totalMs()) elapsedMs = 0;
    playing = true;
    syncPlayBtn();
    lastTs = null;
    cancelAnimationFrame(rafId);
    rafId = requestAnimationFrame(tick);
  }

  function pause(){
    playing = false;
    syncPlayBtn();
    cancelAnimationFrame(rafId);
    lastTs = null;
  }

  function togglePlay(){
    if(playing) pause();
    else play();
  }

  function seek(ev){
    var bar = document.getElementById('lo-tl');
    if(!bar) return;
    var rect = bar.getBoundingClientRect();
    if(!rect.width) return;
    var pct = Math.max(0, Math.min(1, (ev.clientX - rect.left) / rect.width));
    elapsedMs = Math.round(pct * totalMs());
    var wasPlaying = playing;
    pause();
    goToScene(sceneAtTime(elapsedMs), false);
    if(wasPlaying) play();
    else syncPlayBtn();
  }

  function wireControls(){
    var playBtn = document.getElementById('btn-play');
    var tl = document.getElementById('lo-tl');
    if(playBtn) playBtn.onclick = togglePlay;
    if(tl) tl.onclick = seek;
  }

  function init(){
    var label = document.getElementById('lo-scene-label');
    if(label) label.textContent = '에셋 컴포넌트 가이드';

    var pageTitle = document.querySelector('title');
    if(pageTitle) pageTitle.textContent = '에셋 컴포넌트 가이드 - ALTWELL SMART GUIDE';

    renderTimelineMarkers();
    goToScene(0, false);
    wireControls();
    setTimeout(function(){ play(); }, 600);
  }

  return { init: init, SCENES: SCENES };
})();
</script>
