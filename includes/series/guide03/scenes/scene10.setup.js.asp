<script>
var Guide03Scene10Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    var w;
    var h;
    if(!canvas || !inner || !stage) return;
    w = stage.offsetWidth || 1;
    h = stage.offsetHeight || 1;
    if(w < 2 || h < 2) return;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.34) fit = 0.34;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function schedule(){ requestAnimationFrame(applyFit); }

  function bind(ctx){
    _ctx = ctx;
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', schedule);
  }

  function unbind(){
    _resizeBound = false;
    _ctx = null;
  }

  return { schedule: schedule, flush: applyFit, bind: bind, unbind: unbind };
})();

function setupGuide03Scene10(canvas){
  var zone = Guide03Scene10Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var card = document.createElement('div');
  var people = document.createElement('div');
  var selfCol = document.createElement('div');
  var partnerCol = document.createElement('div');
  var partnerRow = document.createElement('div');
  var lower = document.createElement('div');
  var orbs = document.createElement('div');

  function hidden(className){
    var el = document.createElement('div');
    el.className = className + ' g03-slot is-hidden';
    return el;
  }

  function member(templateId){
    var icon = Guide03.cloneTemplate(templateId);
    var host = hidden('g03-s10-person g03-s10-shift');
    if(icon) host.appendChild(icon);
    return { host: host, icon: icon };
  }

  function autoIcon(){
    var icon = Guide03.cloneTemplate('autoship_icon');
    var host = hidden('g03-s10-auto g03-s10-shift');
    if(icon) host.appendChild(icon);
    return host;
  }

  function sepLabel(){
    var el = hidden('g03-s10-sep g03-s10-shift');
    el.textContent = 'SEP 30만 이상 달성';
    return el;
  }

  function orb(html){
    var host = hidden('g03-s10-orb g03-s10-shift');
    host.innerHTML = html;
    return host;
  }

  var badge = Guide03.cloneTemplate('base_business_icon');
  var badgeWrap = hidden('g03-s10-badge');
  if(badge) badgeWrap.appendChild(badge);

  var self = member('member_base_self');
  var selfAuto = autoIcon();
  var selfSep = sepLabel();
  var partners = [member('member_base_partner'), member('member_base_partner')];
  var partnerAuto = autoIcon();
  var or = hidden('g03-s10-or g03-s10-shift');
  var partnerSep = sepLabel();
  or.textContent = 'or';

  var caption = hidden('g03-s10-caption');
  caption.innerHTML = '구성원의 총 SEP<br>매월 100만 이상 달성';

  selfCol.className = 'g03-s10-col g03-s10-shift';
  partnerCol.className = 'g03-s10-col g03-s10-shift';
  partnerRow.className = 'g03-s10-partners';
  lower.className = 'g03-s10-lower';
  people.className = 'g03-s10-people';
  card.className = 'g03-s10-card';
  orbs.className = 'g03-s10-orbs';

  selfCol.appendChild(self.host);
  selfCol.appendChild(selfAuto);
  selfCol.appendChild(selfSep);
  partnerRow.appendChild(partners[0].host);
  partnerRow.appendChild(partners[1].host);
  lower.appendChild(partnerAuto);
  lower.appendChild(or);
  lower.appendChild(partnerSep);
  partnerCol.appendChild(partnerRow);
  partnerCol.appendChild(lower);
  people.appendChild(selfCol);
  people.appendChild(partnerCol);

  var orbNodes = [
    orb('본인 + 파트너2명<br>비즈니스 기본 단위'),
    orb('각종 보너스 보상<br>&<br>승급 조건에 활용'),
    orb('안정적인 조직 확장<br>출발점')
  ];
  orbNodes.forEach(function(node){ orbs.appendChild(node); });

  card.appendChild(caption);
  card.appendChild(people);
  stage.className = 'g03-s10';
  stage.appendChild(badgeWrap);
  stage.appendChild(card);
  stage.appendChild(orbs);

  stack.id = 'g03-s10-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene10Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene10Layout.schedule();

  return {
    stage: stage,
    badge: badgeWrap,
    card: card,
    caption: caption,
    self: self,
    selfAuto: selfAuto,
    selfSep: selfSep,
    partners: partners,
    partnerAuto: partnerAuto,
    or: or,
    partnerSep: partnerSep,
    orbs: orbNodes
  };
}
</script>
