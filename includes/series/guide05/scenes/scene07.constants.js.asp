<script>
/* guide05 Scene 07 — 클로징
   음성은 guide05_scene_07_close.mp4 한 파일. 시각은 그 재생 시작 기준. */
var Guide05Scene07Config = {
  id: 'guide05-scene-07',
  title: '매칭보너스 알아보기',
  duration: 6800,
  canvasCls: 'g05-scene07-canvas',
  panelCls: 'g05-scene07-panel',

  media: {
    sequence: [
      { part: 'close', file: 'guide05_scene_07_close.mp4' }
    ],
    fallbackMs: [5600],
    titleMs: 0
  },

  panel: {
    title: '［&nbsp;매칭보너스 알아보기&nbsp;］<br>&nbsp;&nbsp;&nbsp;수강 완료.',
    bullets: ['문제 풀이 또는 다시보기로 복습하실 수 있습니다.'],
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
