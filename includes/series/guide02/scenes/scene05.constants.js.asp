<script>
/* guide02 Scene 05 — 추천인에게는 어떤 혜택이 있나요?
   시각은 타이틀 음성을 포함한 재생 시작 기준 */
var Guide02Scene05Config = {
  id: 'guide02-scene-05',
  title: '추천인에게는 어떤 혜택이 있나요?',
  duration: 28000,
  canvasCls: 'g02-scene05-canvas',
  panelCls: 'g02-scene05-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_05_title.mp4' },
      { part: 'main', file: 'guide02_scene_05.mp4' }
    ],
    fallbackMs: [3000, 23000],
    titleMs: 3000
  },

  panel: {
    title: '추천인에게는 어떤 혜택이 있나요?',
    bullets: [
      '스타트팩 구매 시 추천인에게 추천포인트 발생',
      '추천포인트는 신규 회원 당 최초 1회 5포인트 발생'
    ],
    flashes: [
      { at: 2000, index: 0 },
      { at: 12000, index: 1 }
    ]
  },

  T: {
    tree: 0,
    leftPack: 2000,
    rightPack: 10000,
    gainTags: 15000,
    zeroPack: 18000
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene05PanelFlashes(){
  return Guide02Scene05Config.panel.flashes.map(function(f){
    return { at: f.at, index: f.index };
  });
}
</script>
