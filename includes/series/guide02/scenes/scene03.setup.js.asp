<script>
var Guide02Scene03Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    if(!canvas || !inner || !stage) return;
    var w = stage.offsetWidth || 1;
    var h = stage.offsetHeight || 1;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.42) fit = 0.42;
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

function setupGuide02Scene03(canvas){
  var zone = Guide02Scene03Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var row = document.createElement('div');
  var colLeft = document.createElement('div');
  var colRight = document.createElement('div');

  function slot(templateId, id){
    var node = Guide02.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden';
    if(node) wrap.appendChild(node);
    return wrap;
  }

  stack.id = 'g02-s03-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s03';
  row.className = 'g02-s03-row';
  colLeft.className = 'g02-s03-col';
  colRight.className = 'g02-s03-col';

  var badge = slot('startpack_badge', 'g02-s03-badge');
  var nouvel = slot('startpack_nouvel_kind', 'g02-s03-nouvel');
  var signature = slot('startpack_signature_kind', 'g02-s03-signature');
  var onceNouvel = slot('startpack_once_badge', 'g02-s03-once-nouvel');
  var onceSignature = slot('startpack_once_badge', 'g02-s03-once-signature');
  var onceNouvelRoot = onceNouvel.querySelector('.g02_once');
  var onceSignatureRoot = onceSignature.querySelector('.g02_once');
  if(onceSignatureRoot) onceSignatureRoot.classList.add('g02_once_signature');

  colLeft.appendChild(nouvel);
  colLeft.appendChild(onceNouvel);
  colRight.appendChild(signature);
  colRight.appendChild(onceSignature);
  row.appendChild(colLeft);
  row.appendChild(colRight);
  stage.appendChild(badge);
  stage.appendChild(row);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene03Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide02Scene03Layout.schedule();

  return {
    badge: badge,
    nouvel: nouvel,
    nouvelIcon: nouvel.querySelector('.g02_kind_icon img'),
    signature: signature,
    signatureIcon: signature.querySelector('.g02_kind_icon img'),
    onceNouvel: onceNouvel,
    onceSignature: onceSignature,
    onceNouvelRoot: onceNouvelRoot
  };
}
</script>
