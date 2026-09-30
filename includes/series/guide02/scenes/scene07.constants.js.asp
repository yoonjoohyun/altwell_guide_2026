<script>
/* guide02 Scene 07 — 왜 스타트팩을 운영할까요?
   타이틀 음성으로 적힌 시각만 타이틀 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide02Scene07Config = {
  id: 'guide02-scene-07',
  title: '왜 스타트팩을 운영할까요?',
  duration: 27000,
  canvasCls: 'g02-scene07-canvas',
  panelCls: 'g02-scene07-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_07_title.mp4' },
      { part: 'main', file: 'guide02_scene_07.mp4' }
    ],
    fallbackMs: [2000, 25000],
    titleMs: 2000
  },

  panel: {
    title: '왜 스타트팩을 운영할까요?',
    bullets: [
      '큰 할인 혜택을 통한 대표 제품의 경험',
      '경험을 통한 자연스러운 추천 활동',
      '초기 빠른 승급과 사업 활동의 발판'
    ],
    flashes: [
      { at: 6000, index: 0 },
      { at: 14000, index: 1 },
      { at: 20000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    fold: 0,
    benefit: 2000,
    orbs: [6000, 12000, 18000]
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene07TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide02Scene07Config.media;
  return (media && media.titleMs) || 0;
}

function guide02Scene07AtMain(ms, ctx){
  return guide02Scene07TitleMs(ctx) + ms;
}

function guide02Scene07PanelFlashes(ctx){
  return Guide02Scene07Config.panel.flashes.map(function(f){
    return { at: guide02Scene07AtMain(f.at, ctx), index: f.index };
  });
}
</script>
