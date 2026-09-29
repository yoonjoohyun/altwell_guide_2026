<script>
/* guide02 Scene 04 — 스타트팩의 가장 큰 혜택
   시각은 타이틀 음성을 포함한 재생 시작 기준 */
var Guide02Scene04Config = {
  id: 'guide02-scene-04',
  title: '스타트팩의 가장 큰 혜택',
  duration: 30000,
  canvasCls: 'g02-scene04-canvas',
  panelCls: 'g02-scene04-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_04_title.mp4' },
      { part: 'main', file: 'guide02_scene_04.mp4' }
    ],
    fallbackMs: [3000, 25000],
    titleMs: 3000
  },

  panel: {
    title: '스타트팩의 가장 큰 혜택',
    bullets: [
      '25% 할인된 회원가에 -50% 추가 할인 패키지',
      '두 종류 모두 구매 시 약 125만원 상당의 할인 혜택',
      '스타트팩 각각 50만 승급EP제공'
    ],
    flashes: [
      { at: 6000, index: 0 },
      { at: 15000, index: 1 },
      { at: 21000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    fold: 5000,
    rows: [7000, 7800, 8600],
    bundle: 15000,
    bundleLines: [15600, 16400],
    coinA: 21000,
    coinB: 22200,
    coinMerge: 23700,
    ep: 21000
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene04PanelFlashes(){
  return Guide02Scene04Config.panel.flashes.map(function(f){
    return { at: f.at, index: f.index };
  });
}
</script>
