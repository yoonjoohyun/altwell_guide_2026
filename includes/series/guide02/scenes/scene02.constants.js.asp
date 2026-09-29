<script>
/* guide02 Scene 02 — 누가, 언제 구매할 수 있나요?
   시각은 타이틀 음성을 포함한 재생 시작 기준 */
var Guide02Scene02Config = {
  id: 'guide02-scene-02',
  title: '누가, 언제 구매할 수 있나요?',
  duration: 36000,
  canvasCls: 'g02-scene02-canvas',
  panelCls: 'g02-scene02-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_02_title.mp4' },
      { part: 'main', file: 'guide02_scene_02.mp4' }
    ],
    fallbackMs: [4000, 30000],
    titleMs: 4000
  },

  panel: {
    title: '누가, 언제 구매할 수 있나요?',
    bullets: [
      '3개월 내 신규 회원 특별 혜택',
      '가입월 포함 3개월간 혜택 적용'
    ],
    flashes: [
      { at: 6000, index: 0 },
      { at: 14000, index: 1 }
    ]
  },

  months: ['5월', '6월', '7월', '8월'],

  T: {
    member: 0,
    exclusive: 2000,
    span: 6000,
    period: 15000,
    months: [20000, 20600, 21200, 21800],
    join: 23000,
    active: [23000, 25000, 27000],
    blocked: 29000
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene02PanelFlashes(){
  return Guide02Scene02Config.panel.flashes.map(function(f){
    return { at: f.at, index: f.index };
  });
}
</script>
