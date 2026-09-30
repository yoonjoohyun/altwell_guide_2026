<script>
/* guide02 Scene 03 — 스타트팩은 두 종류 입니다
   타이틀 음성으로 적힌 시각만 타이틀 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide02Scene03Config = {
  id: 'guide02-scene-03',
  title: '스타트팩은 두 종류 입니다.',
  duration: 22000,
  canvasCls: 'g02-scene03-canvas',
  panelCls: 'g02-scene03-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_03_title.mp4' },
      { part: 'main', file: 'guide02_scene_03.mp4' }
    ],
    fallbackMs: [2000, 18000],
    titleMs: 2000
  },

  panel: {
    title: '스타트팩은 두 종류 입니다.',
    bullets: [
      '누벨마리 스타트팩',
      '시그니처 스타트팩',
      '각각 한 번씩 이용 가능'
    ],
    flashes: [
      { at: 4000, index: 0 },
      { at: 8000, index: 1 },
      { at: 14000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    nouvel: 4000,
    nouvelIcon: 6000,
    signature: 8000,
    signatureIcon: 10000,
    once: 14000
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene03TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide02Scene03Config.media;
  return (media && media.titleMs) || 0;
}

function guide02Scene03AtMain(ms, ctx){
  return guide02Scene03TitleMs(ctx) + ms;
}

function guide02Scene03PanelFlashes(ctx){
  return Guide02Scene03Config.panel.flashes.map(function(f){
    return { at: guide02Scene03AtMain(f.at, ctx), index: f.index };
  });
}
</script>
