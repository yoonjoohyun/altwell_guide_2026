<script>
/* guide03 Scene 10 — 핵심내용 정리 및 마무리
   베이스 사업자 뱃지만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene10Config = {
  id: 'guide03-scene-10',
  title: 'BASE 사업자 핵심 내용',
  duration: 42000,
  canvasCls: 'g03-scene10-canvas',
  panelCls: 'g03-scene10-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_10_title.mp4' },
      { part: 'main', file: 'guide03_scene_10.mp4' }
    ],
    fallbackMs: [4000, 38000],
    titleMs: 4000
  },

  panel: {
    title: 'BASE 사업자 핵심 내용',
    bullets: [
      '본인 : 매월 오토십 포함 SEP 30만 이상 달성',
      '파트너 2명 : 두명 모두 오토십 유지 or 두명 모두 SEP 30만 이상 달성',
      '구성원의 총 SEP 매월 100만 이상',
      '본인 + 파트너 2명 = 앨트웰 사업의 기본 단위',
      '각종 보너스 보상과 승급 조건에 활용',
      '안정적인 조직 확장 구조'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 6000, index: 1 },
      { at: 12000, index: 2 },
      { at: 22000, index: 3 },
      { at: 29000, index: 4 },
      { at: 34000, index: 5 }
    ]
  },

  T: {
    badge: 0,
    badgeFold: 2000,
    self: 0,
    selfAuto: 1000,
    selfSep: 2000,
    partners: [6000, 7000],
    partnerAuto: 8000,
    or: 8800,
    partnerSep: 9600,
    card: 14000,
    orb1: 22000,
    orb2: 30000,
    orb3: 34000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene10TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene10Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene10AtMain(ms, ctx){
  return guide03Scene10TitleMs(ctx) + ms;
}

function guide03Scene10PanelFlashes(ctx){
  return Guide03Scene10Config.panel.flashes.map(function(f){
    return { at: guide03Scene10AtMain(f.at, ctx), index: f.index };
  });
}
</script>
