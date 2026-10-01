<script>
/* guide02 Scene 08 — 스타트팩 핵심 내용
   타이틀 음성으로 적힌 시각만 타이틀 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide02Scene08Config = {
  id: 'guide02-scene-08',
  title: '스타트팩 핵심 내용',
  duration: 34000,
  canvasCls: 'g02-scene08-canvas',
  panelCls: 'g02-scene08-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide02_scene_08_title.mp4' },
      { part: 'main', file: 'guide02_scene_08.mp4' }
    ],
    fallbackMs: [4000, 30000],
    titleMs: 4000
  },

  panel: {
    title: '스타트팩 핵심 내용',
    bullets: [
      '가입월 포함 3개월간 혜택 적용',
      '25% 할인된 회원가에 -50% 추가 할인 패키지',
      '50만 승급 EP 제공',
      '추천인에게 최초 1회 5추천포인트 발생'
    ],
    flashes: [
      { at: 4000, index: 0 },
      { at: 13000, index: 1 },
      { at: 18000, index: 2 },
      { at: 23000, index: 3 }
    ]
  },

  T: {
    badge: 0,
    panel: 2000,
    period: 3500,
    nouvel: 8000,
    signature: 10000,
    once: 13000,
    price: 16000,
    ep: 19000,
    points: 22000
  },

  layout: { anchorZone: 'd4' }
};

function guide02Scene08TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide02Scene08Config.media;
  return (media && media.titleMs) || 0;
}

function guide02Scene08AtMain(ms, ctx){
  return guide02Scene08TitleMs(ctx) + ms;
}

function guide02Scene08PanelFlashes(ctx){
  return Guide02Scene08Config.panel.flashes.map(function(f){
    return { at: guide02Scene08AtMain(f.at, ctx), index: f.index };
  });
}
</script>
