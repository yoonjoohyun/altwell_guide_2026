<script>
var Guide02Scene02Layout = (function(){
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

function setupGuide02Scene02(canvas){
  var zone = Guide02Scene02Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var top = document.createElement('div');
  var balance = document.createElement('div');
  var aside = document.createElement('div');
  var box = document.createElement('div');
  var title = document.createElement('div');
  var row = document.createElement('div');
  var months = [];

  function slot(templateId, id){
    var node = Guide02.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden';
    if(node) wrap.appendChild(node);
    return wrap;
  }

  stack.id = 'g02-s02-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s02';
  top.className = 'g02-s02-top';
  balance.className = 'g02-s02-balance';
  aside.className = 'g02-s02-aside';

  var member = slot('member_icon', 'g02-s02-member');
  var exclusive = slot('startpack_exclusive_badge', 'g02-s02-exclusive');
  var span = slot('startpack_span_calendar', 'g02-s02-span');
  var memberIcon = member.querySelector('.member_icon');
  if(memberIcon) memberIcon.classList.add('g02-member');

  box.id = 'g02-s02-period';
  box.className = 'g02_period_box g02-slot is-hidden';
  title.className = 'g02_period_title';
  title.textContent = '스타트팩 구매기간 예시';
  row.className = 'g02_month_row';

  Guide02Scene02Config.months.forEach(function(label, index){
    var col = document.createElement('div');
    var card = Guide02.cloneTemplate('startpack_month_card');
    var head = card && card.querySelector('.g02_month_head');
    var extra = slot(index === 0 ? 'startpack_join_chip' : 'startpack_blocked_chip', 'g02-s02-note-' + index);
    col.className = 'g02_month_col g02-slot is-hidden';
    col.id = 'g02-s02-month-' + index;
    if(head) head.textContent = label;
    if(card){
      card.setAttribute('aria-label', label);
      col.appendChild(card);
    }
    if(index !== 0 && index !== 3) extra = null;
    if(extra) col.appendChild(extra);
    row.appendChild(col);
    months.push({ col: col, card: card, note: extra });
  });

  box.appendChild(title);
  box.appendChild(row);
  aside.appendChild(exclusive);
  aside.appendChild(span);
  top.appendChild(balance);
  top.appendChild(member);
  top.appendChild(aside);
  stage.appendChild(top);
  stage.appendChild(box);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene02Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide02Scene02Layout.schedule();

  return {
    member: member,
    exclusive: exclusive,
    span: span,
    box: box,
    months: months,
    join: months[0].note,
    blocked: months[3].note
  };
}
</script>
