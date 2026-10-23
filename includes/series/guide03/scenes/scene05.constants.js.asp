<script>
/* guide03 Scene 05 — 오토십으로 BASE사업자 만들기
   파트너 두 명만 타이틀 음성 시작 기준.
   그 외 본편 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다.
   추가 본문(part 02) 시각은 본문 음성이 끝난 시점 기준. */
var Guide03Scene05Config = {
  id: 'guide03-scene-05',
  title: '오토십으로 BASE사업자 만들기',
  duration: 36000,
  canvasCls: 'g03-scene05-canvas',
  panelCls: 'g03-scene05-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_05_title.mp4' },
      { part: 'main', file: 'guide03_scene_05.mp4' },
      { part: '02', file: 'guide03_scene_05-02.mp4' }
    ],
    fallbackMs: [4200, 19500, 12000],
    titleMs: 4000
  },

  panel: {
    title: '오토십으로 BASE사업자 만들기',
    bullets: [
      '직 1대 파트너 2명 모두 오토십 1개 이상 유지',
      'S.E.P 30만 달성 조건의 부담을 오토십 구독으로 완화',
      '베이스 사업자 자격 획득을 위한 가장 쉬운 방법'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 8000, index: 1 }
    ]
  },

  T: {
    partners: [0, 800],
    autos: [0, 1000],
    gauge: 7000,
    boxes: [9000, 11000, 13000],
    stable: 15000,
    coda: {
      board: 0,
      self: 760,
      partners: [1600, 2400],
      autos: [3400, 4400],
      note: 7000
    }
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene05TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene05Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene05AtMain(ms, ctx){
  return guide03Scene05TitleMs(ctx) + ms;
}

function guide03Scene05PartMs(part, fallback){
  var media = Guide03Scene05Config.media;
  var ms = media.partMs && media.partMs[part];
  return ms > 0 ? ms : fallback;
}

function guide03Scene05AddAt(ms, ctx){
  var fb = Guide03Scene05Config.media.fallbackMs;
  return guide03Scene05TitleMs(ctx) + guide03Scene05PartMs('main', fb[1] || 19000) + ms;
}

function guide03Scene05PanelFlashes(ctx){
  return Guide03Scene05Config.panel.flashes.map(function(f){
    return { at: guide03Scene05AtMain(f.at, ctx), index: f.index };
  });
}
</script>
