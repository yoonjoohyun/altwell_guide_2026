<script>
/* guide05 공통. guide04 공통(Guide04·G04Kit)을 그대로 쓰고, 매칭보너스용 보조만 둔다.
   guide01~04 런타임 파일은 수정하지 않는다. */
(function(){
  var src = document.getElementById('guide05-templates');
  var dst = document.getElementById('guide04-templates');
  if(!src || !dst) return;
  while(src.firstChild) dst.appendChild(src.firstChild);
})();

var G05 = (function(){
  var K = G04Kit;
  var BADGE_SEL = '.recommend_bonus_icon_o, .base_business_icon_o, .autoship_icon_o';
  var TEXT_SEL = '.recommend_bonus_text, .base_text, .autoship_text';

  /* 뱃지 팝업: 펼침 연출 없이 제자리에서 튀어 오르듯 등장.
     이후 K.foldAway 로 접을 수 있도록 펼침 상태의 구조(fold-track)를 미리 만든다. */
  async function popBadge(wrap, schedule){
    var badge;
    var text;
    var track;
    var gap;
    var textW;
    if(!wrap) return;
    badge = wrap.querySelector(BADGE_SEL);
    text = badge && badge.querySelector(TEXT_SEL);
    if(!badge || !text){
      await K.reveal(wrap, schedule);
      return;
    }
    showElement(wrap);
    badge.classList.add('g04-fold');
    gap = parseFloat(getComputedStyle(badge).getPropertyValue('--size')) * 5 / 36;
    if(!gap || gap < 1) gap = 6;
    badge.style.setProperty('--g04-gap', gap + 'px');
    textW = Math.ceil(text.scrollWidth || text.getBoundingClientRect().width);
    track = K.el('span', 'g04-fold-track');
    text.parentNode.insertBefore(track, text);
    track.appendChild(text);
    badge.style.gap = '0px';
    track.style.maxWidth = (textW + 2) + 'px';
    track.style.marginLeft = gap + 'px';
    wrap.classList.add('g05-pop');
    if(schedule) schedule();
    await wait(460);
    wrap.classList.remove('g05-pop');
  }

  /* 템플릿 + 라벨 문구를 바꾼 지위 메달 슬롯 (가슴 위치) */
  function chestMedal(fig, templateId, text){
    var host = K.medal(fig, templateId);
    var node = host.firstElementChild;
    host.classList.add('g05-chest');
    if(node && text) node.textContent = text;
    return host;
  }

  /* 작은 뱃지(비교 화면용). templateId 의 뱃지를 grow 슬롯에 넣어 돌려준다 */
  function badgeSlot(templateId, cls){
    var wrap = K.el('div', 'g05-cmp-badge' + (cls ? ' ' + cls : ''));
    var node = Guide04.cloneTemplate(templateId);
    if(node) wrap.appendChild(node);
    return K.grow(wrap);
  }

  /* 멤버 하단 캡션 텍스트 대신 Base 사업자 뱃지(펼침) 를 쓴다.
     hidden=true 면 grow 슬롯(닫힘)으로 붙여 슬롯을 돌려주고, 아니면 바로 보이는 뱃지를 붙인다. */
  function baseCap(mem, small, hidden){
    var host = K.el('div', 'g05-basecap' + (small ? ' is-sm' : ''));
    var node = Guide04.cloneTemplate('g05_base_icon');
    var slot = null;
    if(mem.cap && mem.cap.parentNode){
      mem.cap.parentNode.removeChild(mem.cap);
      mem.cap = null;
    }
    if(node) host.appendChild(node);
    if(hidden){
      slot = K.grow(host);
      mem.wrap.appendChild(slot);
      return slot;
    }
    mem.wrap.appendChild(host);
    return host;
  }

  /* 위로 움직이는 화살표 (루프 애니메이션은 CSS) */
  function arrowUp(){
    var wrap = K.el('div', 'g05-arrow');
    var node = Guide04.cloneTemplate('g05_arrow_up');
    if(node) wrap.appendChild(node);
    return wrap;
  }

  /* 지위 메달 교체 (templateId 의 lev_* 로 바꾸고 라벨 문구 지정) */
  function setLevel(host, templateId, text){
    var node = Guide04.cloneTemplate(templateId);
    if(!host || !node) return;
    while(host.firstChild) host.removeChild(host.firstChild);
    if(text) node.textContent = text;
    host.appendChild(node);
  }

  /* 라인 단위 제외 스탬프: 컬럼 위에 겹쳐 놓는 작은 스탬프 */
  function stamp(text){
    var layer = K.overlay('unavailable_stamp', text);
    layer.classList.add('g05-stamp');
    return layer;
  }

  return { setLevel: setLevel, stamp: stamp, popBadge: popBadge, chestMedal: chestMedal, badgeSlot: badgeSlot, baseCap: baseCap, arrowUp: arrowUp };
})();
</script>
