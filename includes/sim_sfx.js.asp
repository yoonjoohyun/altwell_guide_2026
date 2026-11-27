<script>
/* 시뮬레이션 효과음 — 정답/오답·불가/다음 단계/결과 보기. 파일은 sfx/ 폴더. */
var SimSfx = (function(){
  var FILES = { correct: 'sfx/correct.mp3', wrong: 'sfx/wrong.mp3', next: 'sfx/next.mp3', result: 'sfx/result.mp3' };
  var cache = {};
  var unlocked = false;

  function get(name){
    var a;
    if(!FILES[name]) return null;
    if(!cache[name]){
      try{
        a = new Audio(FILES[name]);
        a.preload = 'auto';
        cache[name] = a;
      }catch(e){ return null; }
    }
    return cache[name];
  }

  function preload(){
    var k;
    for(k in FILES) if(FILES.hasOwnProperty(k)) get(k);
  }

  function play(name){
    var a = get(name);
    var p;
    if(!a) return;
    try{
      a.currentTime = 0;
      p = a.play();
      if(p && p.catch) p.catch(function(){});
    }catch(e){}
  }

  /* 첫 사용자 입력에서 미리 로드(모바일 자동재생 제한 대비) */
  function arm(){
    if(unlocked) return;
    unlocked = true;
    preload();
  }
  document.addEventListener('pointerdown', arm, { once: true });

  return { play: play, preload: preload };
})();
</script>
