<script>
/* guide02 Scene 09 — 클로징
   음성은 guide02_scene_09_close.mp4 한 파일. 시각은 그 재생 시작 기준. */
var Guide02Scene09Config = {
  id: 'guide02-scene-09',
  title: '스타트팩 알아보기',
  duration: 6840,
  canvasCls: 'g02-scene09-canvas',
  panelCls: 'g02-scene09-panel',

  media: {
    sequence: [
      { part: 'close', file: 'guide02_scene_09_close.mp4' }
    ],
    fallbackMs: [6840],
    titleMs: 0
  },

  panel: {
    title: '［&nbsp;스타트팩 알아보기&nbsp;］<br>&nbsp;&nbsp;&nbsp;수강 완료.',
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
