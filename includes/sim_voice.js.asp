<script>
/* 시뮬레이션 단계 음성. 새 재생은 이전 음성을 즉시 멈춘다. */
var SimVoice = (function(){
  var audio = null;

  function ensure(){
    if(audio) return audio;
    audio = document.createElement('audio');
    audio.id = 'sim-voice';
    audio.preload = 'auto';
    audio.setAttribute('playsinline', '');
    document.body.appendChild(audio);
    return audio;
  }

  function pad(n){
    return n < 10 ? '0' + n : String(n);
  }

  function srcFor(series, part){
    return (window.GUIDE_ROOT || '') + '/voice_stream.asp?series=' + encodeURIComponent(series) + '&scene=01&part=' + encodeURIComponent(part);
  }

  function play(series, part){
    var el = ensure();
    el.pause();
    el.src = srcFor(series, part);
    var pending = el.play();
    if(pending && pending.catch) pending.catch(function(){});
  }

  function playStep(series, stepIndex, part){
    play(series, part || ('sim' + pad(stepIndex + 1)));
  }

  function playClose(series){
    play(series, 'simclose');
  }

  return { playStep: playStep, playClose: playClose };
})();
</script>
