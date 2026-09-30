<script>
var Guide02Scene01Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var cluster = _ctx && _ctx.cluster;
    var fit = 1;
    if(!canvas || !inner || !cluster) return;
    var w = cluster.offsetWidth || 1;
    var h = cluster.offsetHeight || 1;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.45) fit = 0.45;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function schedule(){
    requestAnimationFrame(applyFit);
  }

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

  return { schedule: schedule, bind: bind, unbind: unbind };
})();

function setupGuide02Scene01(canvas){
  var zone = Guide02Scene01Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var cluster = document.createElement('div');
  var colLeft = document.createElement('div');
  var colCenter = document.createElement('div');
  var colRight = document.createElement('div');

  function slot(templateId, id){
    var node = Guide02.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden';
    if(node) wrap.appendChild(node);
    return wrap;
  }

  stack.id = 'g02-s01-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  cluster.className = 'g02-cluster';
  colLeft.className = 'g02-col g02-col-left is-hidden';
  colCenter.className = 'g02-col g02-col-center';
  colRight.className = 'g02-col g02-col-right is-hidden';

  var member = slot('member_icon', 'g02-s01-member');
  var badge = slot('startpack_badge', 'g02-s01-badge');
  var nouvel = slot('startpack_nouvel_card', 'g02-s01-nouvel');
  var signature = slot('startpack_signature_card', 'g02-s01-signature');
  var discount = slot('startpack_discount_badge', 'g02-s01-discount');
  var experience = slot('startpack_experience_chip', 'g02-s01-experience');
  var launch = slot('startpack_launch_chip', 'g02-s01-launch');
  var memberIcon = member.querySelector('.member_icon');
  if(memberIcon) memberIcon.classList.add('g02-member');

  colLeft.appendChild(nouvel);
  colLeft.appendChild(experience);
  colCenter.appendChild(member);
  colCenter.appendChild(badge);
  colCenter.appendChild(discount);
  colRight.appendChild(signature);
  colRight.appendChild(launch);
  cluster.appendChild(colLeft);
  cluster.appendChild(colCenter);
  cluster.appendChild(colRight);
  inner.appendChild(cluster);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene01Layout.bind({ canvas: canvas, inner: inner, cluster: cluster });

  return {
    stack: stack,
    colLeft: colLeft,
    colRight: colRight,
    member: member,
    badge: badge,
    badgeSub: badge.querySelector('.g02_startpack_sub'),
    nouvel: nouvel,
    signature: signature,
    discount: discount,
    experience: experience,
    launch: launch
  };
}
</script>
