<script>
/* 가이드 학습·시뮬레이션 복습 기록. 계정은 로그인 세션으로 구분한다. */
var ReadLog = (function(){
  var ENDPOINT = 'https://m.altwell.co.kr/2025/business/bzguide/read_ins.asp';
  var GUIDE = {
    guide01: { id: 1, title: 'autoship_guide' },
    guide02: { id: 2, title: 'startpack_guide' },
    guide03: { id: 3, title: 'basebusiness_guide' }
  };
  var SIM = {
    guide01: { id: 4, title: 'autoship_quiz' }
  };
  var sent = {};

  function send(div, lessonId, section){
    var item = div === 's' ? SIM[lessonId] : GUIDE[lessonId];
    var key;
    var url;
    var img;
    if(!item || !(section > 0)) return;
    if(div !== 'm' && div !== 's') return;
    key = div + ':' + item.id + ':' + section;
    if(sent[key]) return;
    sent[key] = true;
    url = ENDPOINT
      + '?id_num=' + encodeURIComponent(item.id)
      + '&title=' + encodeURIComponent(item.title)
      + '&section=' + encodeURIComponent(section)
      + '&div=' + encodeURIComponent(div);
    img = new Image();
    img.src = url;
  }

  return {
    guideScene: function(lessonId, section){
      send('m', lessonId, section);
    },
    simulation: function(lessonId, section){
      send('s', lessonId, section);
    }
  };
})();
</script>
