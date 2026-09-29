<script>
/* guide02 Scene 06 — 스타트팩과 초기 승급
   시각은 타이틀 음성을 포함한 재생 시작 기준 */
var Guide02Scene06Config = {
  id: 'guide02-scene-06',
  title: '스타트팩과 초기 승급',
  duration: 42000,
  canvasCls: 'g02-scene06-canvas',
  panelCls: 'g02-scene06-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_06_title.mp4' },
      { part: 'main', file: 'guide02_scene_06.mp4' }
    ],
    fallbackMs: [3000, 39000],
    titleMs: 3000
  },

  panel: {
    title: '스타트팩과 초기 승급',
    bullets: [
      '스타트팩 구매 시 각각 50만 승급 EP제공',
      '승급만을 위한 추가 승급EP로 수당EP에 적용되지 않음'
    ],
    flashes: [
      { at: 2000, index: 0 },
      { at: 24000, index: 1 }
    ]
  },

  T: {
    member: 0,
    left: 2000,
    right: 13000,
    panel: 25000,
    lines: [26200, 27600, 29200]
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene06PanelFlashes(){
  return Guide02Scene06Config.panel.flashes.map(function(f){
    return { at: f.at, index: f.index };
  });
}
</script>
