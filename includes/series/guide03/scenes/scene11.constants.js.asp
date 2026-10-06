<script>
/* guide03 Scene 11 — 클로징
   음성은 guide03_scene_11_close.mp4 한 파일. 시각은 그 재생 시작 기준. */
var Guide03Scene11Config = {
  id: 'guide03-scene-11',
  title: 'BASE사업자 이해하기',
  duration: 7000,
  canvasCls: 'g03-scene11-canvas',
  panelCls: 'g03-scene11-panel',

  media: {
    sequence: [
      { part: 'close', file: 'guide03_scene_11_close.mp4' }
    ],
    fallbackMs: [7000],
    titleMs: 0
  },

  panel: {
    title: '［&nbsp;BASE사업자 이해하기&nbsp;］<br>&nbsp;&nbsp;&nbsp;수강 완료.',
    bullets: ['시뮬레이션 또는 다시보기로 복습하실 수 있습니다.'],
    flashes: []
  },

  T: {
    panel: 0,
    title: 1100,
    sim: 2500,
    replay: 3900
  },

  layout: { anchorZone: 'd4' },

  motionMs: 680
};
</script>
