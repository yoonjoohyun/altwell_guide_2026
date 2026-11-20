<script>
/* guide04 Scene 06 — 클로징
   음성은 guide04_scene_06_close.mp4 한 파일. 시각은 그 재생 시작 기준. */
var Guide04Scene06Config = {
  id: 'guide04-scene-06',
  title: '추천보너스 알아보기',
  duration: 7000,
  canvasCls: 'g04-scene06-canvas',
  panelCls: 'g04-scene06-panel',

  media: {
    sequence: [
      { part: 'close', file: 'guide04_scene_06_close.mp4' }
    ],
    fallbackMs: [7000],
    titleMs: 0
  },

  panel: {
    title: '［&nbsp;추천보너스 알아보기&nbsp;］<br>&nbsp;&nbsp;&nbsp;수강 완료.',
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
