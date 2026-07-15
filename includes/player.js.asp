<script>
var TOTAL=180,T=0,playing=false,rafId=null,lastTS=null,fired=new Set(),FF=false;
var E=function(id){return document.getElementById(id)};
var add=function(id,c){var e=E(id);if(e)e.classList.add(c)};
var rem=function(id,c){var e=E(id);if(e)e.classList.remove(c)};
var txt=function(id,v){var e=E(id);if(e)e.textContent=v};

function show(id){
  var e=E(id);if(!e)return;
  e.classList.remove('hidden');
  if(FF){e.classList.add('show');return}
  requestAnimationFrame(function(){requestAnimationFrame(function(){e.classList.add('show')})});
}
function hide(id){var e=E(id);if(!e)return;e.classList.remove('show')}
function drawLine(id){
  if(FF){add(id,'on');return}
  requestAnimationFrame(function(){add(id,'on')});
}
function setInfo(label,lines){
  var ic=E('icard'),bd=E('ic-body');if(!ic)return;
  txt('ic-lbl',label);
  var h='';
  for(var i=0;i<lines.length;i++){
    var l=lines[i],bold=typeof l==='object'&&l.b,t=typeof l==='object'?l.t:l;
    h+='<div class="ic-line'+(bold?' b':'')+'">'+t+'</div>';
  }
  bd.innerHTML=h;ic.style.display='block';
  if(FF){ic.classList.add('show');return}
  ic.classList.remove('show');
  requestAnimationFrame(function(){requestAnimationFrame(function(){ic.classList.add('show')})});
}
function bonusAnim(fromId){
  if(FF)return;
  var si=E('si'),from=E(fromId),to=E('mm');
  if(!si||!from||!to)return;
  var sr=si.getBoundingClientRect(),fr=from.getBoundingClientRect(),tr=to.getBoundingClientRect();
  var coin=document.createElement('div');
  coin.className='bcoin';coin.textContent='&#8361;';
  var x1=fr.left-sr.left+fr.width/2-12,y1=fr.top-sr.top+fr.height*.28-12;
  var x2=tr.left-sr.left+tr.width/2-12,y2=tr.top-sr.top+tr.height*.28-12;
  coin.style.cssText='left:'+x1+'px;top:'+y1+'px;';
  si.appendChild(coin);
  requestAnimationFrame(function(){requestAnimationFrame(function(){
    coin.style.transition='left 1.2s ease-in-out,top 1.2s ease-in-out,opacity .4s .8s';
    coin.style.left=x2+'px';coin.style.top=y2+'px';coin.style.opacity='0';
  })});
  setTimeout(function(){if(coin.parentNode)coin.parentNode.removeChild(coin)},1900);
}
function countUp(id,to,dur){
  var e=E(id);if(!e)return;
  e.style.display='block';
  if(FF){e.textContent='&#8361;'+to.toLocaleString('ko-KR');return}
  var s=performance.now();
  function tick(n){
    var p=Math.min((n-s)/(dur*1000),1);
    e.textContent='&#8361;'+Math.floor(to*p).toLocaleString('ko-KR');
    if(p<1)requestAnimationFrame(tick);else e.textContent='&#8361;'+to.toLocaleString('ko-KR');
  }
  requestAnimationFrame(tick);
}

var EVS=[
  {t:.2,  f:function(){show('hero-s')}},
  {t:8.5, f:function(){hide('hero-s');show('mm')}},
  {t:10.5,f:function(){add('mm-imgs','blue')}},
  {t:12.5,f:function(){add('mm-med','show')}},
  {t:14.5,f:function(){txt('mm-pl','디슈머');add('mm-pl','show')}},
  {t:16,  f:function(){setInfo('디슈머란?',['앨트웰을 처음 시작하면 누구나 디슈머가 됩니다.','좋은 제품을 할인받아 이용하는 똑똑한 소비자입니다.'])}},
  {t:22.5,f:function(){add('mm-as','show');add('mm-as','glow')}},
  {t:25.5,f:function(){add('mm-sep','show')}},
  {t:28,  f:function(){setInfo('BASE사업자 조건',[{t:'오토십 이용',b:true},{t:'SEP 30만 이상 유지',b:true}])}},
  {t:36.5,f:function(){show('dl-l')}},
  {t:38.5,f:function(){drawLine('gl-l')}},
  {t:41,  f:function(){add('dl-l-as','show')}},
  {t:44,  f:function(){add('dl-l-sep','show')}},
  {t:47,  f:function(){setInfo('첫 번째 추천',['내가 누리는 혜택을 소개하고','그 사람도 오토십을 이용합니다.'])}},
  {t:53.5,f:function(){show('dl-r')}},
  {t:55.5,f:function(){drawLine('gl-r')}},
  {t:57.5,f:function(){add('dl-r-as','show')}},
  {t:60.5,f:function(){add('dl-r-sep','show')}},
  {t:63,  f:function(){add('mm-chk','show');add('dl-l-chk','show');add('dl-r-chk','show')}},
  {t:65.5,f:function(){add('gl-l','glow');add('gl-r','glow');setInfo('조건 충족!',['세 사람 모두 조건을 충족하면','BASE사업자 조건이 완성됩니다.'])}},
  {t:70.5,f:function(){add('mm-biz','show')}},
  {t:72.5,f:function(){rem('mm-med','show')}},
  {t:74,  f:function(){add('mm-ring','show')}},
  {t:76,  f:function(){add('bpw','show');txt('bp-t1','권리 소득 시작')}},
  {t:79,  f:function(){setInfo('BASE사업자 달성!',['BASE사업자는 권리 소득을','받을 수 있는 자격입니다.'])}},
  {t:84.5,f:function(){setInfo('추천 보너스',['추천 보너스는 직접 추천한','사업자 1명당 발생합니다.'])}},
  {t:86,  f:function(){bonusAnim('dl-l')}},
  {t:89,  f:function(){bonusAnim('dl-r')}},
  {t:91.5,f:function(){txt('bp-t1','추천 보너스')}},
  {t:93,  f:function(){countUp('bp-t2',10000,3)}},
  {t:99,  f:function(){bonusAnim('dl-l');bonusAnim('dl-r')}},
  {t:105.5,f:function(){show('ex-m');setInfo('직접 추천 보너스',['추천 보너스는 내 하위 그룹이 아니어도','직접 추천한 사업자라면 계속 발생합니다.'])}},
  {t:109,f:function(){bonusAnim('ex-m')}},
  {t:115,f:function(){bonusAnim('ex-m')}},
  {t:125.5,f:function(){
    add('mm-as','glow');add('mm-sep','glow');
    add('dl-l-as','glow');add('dl-l-sep','glow');
    add('dl-r-as','glow');add('dl-r-sep','glow');
  }},
  {t:129,f:function(){add('warn','show')}},
  {t:141.5,f:function(){rem('warn','show');show('dl-lc');show('dl-rc');drawLine('gl-lc');drawLine('gl-rc')}},
  {t:147,f:function(){txt('bp-t1','권리 소득 시스템 구축')}},
  {t:154,f:function(){txt('bp-t1','조직이 성장할수록 더 큰 권리')}},
  {t:160.5,f:function(){add('sc1','show')}},
  {t:163,  f:function(){add('sc2','show')}},
  {t:166,  f:function(){add('sc3','show')}},
  {t:170.5,f:function(){rem('sc1','show');rem('sc2','show');rem('sc3','show');add('ending','show')}},
  {t:176,  f:function(){add('cta-row','show')}},
];

var SCENES=[
  [0,'장면 1 · 시작'],[8,'장면 2 · 디슈머'],[22,'장면 3 · 조건'],
  [36,'장면 4 · 첫 번째 추천'],[53,'장면 5 · 두 번째 추천'],[70,'장면 6 · BASE 달성'],
  [84,'장면 7 · 추천 보너스'],[105,'장면 8 · 직접 추천'],[125,'장면 9 · 조건 유지'],
  [141,'장면 10 · 조직 성장'],[160,'장면 11 · 정리'],[170,'장면 12 · 마무리'],
];
function sceneLabel(t){var l=SCENES[0][1];for(var i=0;i<SCENES.length;i++){if(t>=SCENES[i][0])l=SCENES[i][1]}return l}
function fmt(s){var m=Math.floor(s/60),sec=Math.floor(s%60);return m+':'+(sec<10?'0':'')+sec}

function updateUI(t){
  var p=t/TOTAL*100;
  E('tlf').style.width=p+'%';
  E('tlt').style.left=p+'%';
  E('tdsp').textContent=fmt(t)+' / 3:00';
  E('slbl').textContent=sceneLabel(t);
}
function process(t){
  for(var i=0;i<EVS.length;i++){if(t>=EVS[i].t&&!fired.has(i)){fired.add(i);EVS[i].f()}}
}
function rafTick(ts){
  if(!playing){lastTS=null;return}
  if(lastTS)T+=(ts-lastTS)/1000;
  lastTS=ts;
  if(T>=TOTAL){T=TOTAL;playing=false;E('btn-p').innerHTML='&#9654;'}
  process(T);updateUI(T);
  if(playing)rafId=requestAnimationFrame(rafTick);
}
function togglePlay(){
  playing=!playing;
  E('btn-p').innerHTML=playing?'&#9646;&#9646;':'&#9654;';
  if(playing){lastTS=null;rafId=requestAnimationFrame(rafTick)}
  else cancelAnimationFrame(rafId);
}

var TRANS_SEL='.mn,.gl,.m-medal,.m-biz,.m-as,.m-sep,.m-chk,.m-ring,.m-plate,#bpw,#warn,#ending,#icard';

function resetDOM(){
  var ids=['mm','dl-l','dl-r','ex-m','dl-lc','dl-rc','hero-s','bpw','warn','ending'];
  for(var i=0;i<ids.length;i++){var e=E(ids[i]);if(e)e.classList.remove('show','hidden')}
  var pairs=[
    ['mm-imgs','blue'],['mm-med','show'],['mm-biz','show'],['mm-ring','show'],
    ['mm-as','show'],['mm-as','glow'],['mm-sep','show'],['mm-sep','glow'],['mm-chk','show'],
    ['dl-l-as','show'],['dl-l-sep','show'],['dl-l-as','glow'],['dl-l-sep','glow'],['dl-l-chk','show'],
    ['dl-r-as','show'],['dl-r-sep','show'],['dl-r-as','glow'],['dl-r-sep','glow'],['dl-r-chk','show'],
    ['gl-l','on'],['gl-l','glow'],['gl-r','on'],['gl-r','glow'],
    ['gl-lc','on'],['gl-rc','on'],
    ['sc1','show'],['sc2','show'],['sc3','show'],
    ['cta-row','show'],['mm-pl','show'],
  ];
  for(var i=0;i<pairs.length;i++){rem(pairs[i][0],pairs[i][1])}
  txt('mm-pl','');txt('bp-t1','권리 소득 시작');
  var t2=E('bp-t2');if(t2){t2.style.display='none';t2.textContent='&#8361;'}
  var ic=E('icard');if(ic){ic.style.display='none';ic.classList.remove('show')}
  var coins=document.querySelectorAll('.bcoin');
  for(var i=0;i<coins.length;i++){if(coins[i].parentNode)coins[i].parentNode.removeChild(coins[i])}
}

function doRestart(){
  cancelAnimationFrame(rafId);
  playing=false;T=0;lastTS=null;fired.clear();
  E('btn-p').innerHTML='&#9654;';
  var tels=document.querySelectorAll(TRANS_SEL);
  for(var i=0;i<tels.length;i++)tels[i].style.transition='none';
  resetDOM();
  requestAnimationFrame(function(){requestAnimationFrame(function(){
    for(var i=0;i<tels.length;i++)tels[i].style.transition='';
    updateUI(0);
  })});
}

function onSeek(ev){
  var r=E('tl').getBoundingClientRect();
  var pct=Math.max(0,Math.min(1,(ev.clientX-r.left)/r.width));
  var target=pct*TOTAL,was=playing;
  cancelAnimationFrame(rafId);playing=false;T=0;lastTS=null;fired.clear();
  var tels=document.querySelectorAll(TRANS_SEL);
  for(var i=0;i<tels.length;i++)tels[i].style.transition='none';
  resetDOM();FF=true;T=target;
  for(var i=0;i<EVS.length;i++){if(target>=EVS[i].t){fired.add(i);try{EVS[i].f()}catch(e){}}}
  FF=false;updateUI(target);
  requestAnimationFrame(function(){requestAnimationFrame(function(){
    for(var i=0;i<tels.length;i++)tels[i].style.transition='';
    if(was){playing=true;E('btn-p').innerHTML='&#9646;&#9646;';lastTS=null;rafId=requestAnimationFrame(rafTick)}
  })});
}
</script>