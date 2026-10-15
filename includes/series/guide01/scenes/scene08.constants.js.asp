<script>
/* guide01 Scene 08 — 클로징
   음성은 guide01_scene_08_close.mp4 한 파일. 시각은 그 재생 시작 기준. */
var Scene08Config = {
  id: 'guide01-scene-08',
  title: '오토십 알아보기',
  duration: 7000,
  canvasCls: 'scene08-canvas',
  panelCls: 'scene08-panel',

  media: {
    sequence: [
      { part: 'close', file: 'guide01_scene_08_close.mp4' }
    ],
    fallbackMs: [7000],
    titleMs: 0
  },

  panel: {
    title: '［&nbsp;오토십 알아보기&nbsp;］<br>&nbsp;&nbsp;&nbsp;수강 완료.',
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
