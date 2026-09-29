<script>
/* guide02 Scene 01 — 스타트팩이란?
   시각은 타이틀 음성을 포함한 재생 시작 기준 */
var Guide02Scene01Config = {
  id: 'guide02-scene-01',
  title: '스타트팩이란?',
  duration: 24000,
  canvasCls: 'g02-scene01-canvas',
  panelCls: 'g02-scene01-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_01_title.mp4' },
      { part: 'main', file: 'guide02_scene_01.mp4' }
    ],
    fallbackMs: [2000, 20000],
    titleMs: 2000
  },

  panel: {
    title: '스타트팩이란?',
    bullets: [
      '앨트웰 대표 제품으로 구성',
      '신규 회원 전용 패키지',
      '회원가 -50%할인된 가격'
    ],
    flashes: [
      { at: 2000, index: 0 },
      { at: 4000, index: 1 },
      { at: 12000, index: 2 }
    ]
  },

  T: {
    member: 0,
    badge: 0,
    nouvel: 4000,
    signature: 6000,
    exclusive: 10000,
    discount: 13000,
    experience: 17000,
    launch: 19000
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene01PanelFlashes(){
  return Guide02Scene01Config.panel.flashes.map(function(f){
    return { at: f.at, index: f.index };
  });
}
</script>
