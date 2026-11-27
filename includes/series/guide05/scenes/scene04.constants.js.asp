<script>
/* guide05 Scene 04 — 매칭포인트 지급 방식
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide05Scene04Config = {
  id: 'guide05-scene-04',
  title: '매칭포인트 지급 방식',
  duration: 62000,
  canvasCls: 'g05-scene04-canvas',
  panelCls: 'g04-scene-g05-04',

  media: {
    sequence: [
      { part: 'title', file: 'guide05_scene_04_title.mp4' },
      { part: 'main', file: 'guide05_scene_04.mp4' }
    ],
    fallbackMs: [3570, 55960],
    titleMs: 3570
  },

  panel: {
    title: '매칭포인트 지급 방식',
    bullets: [
      '하위 Base 사업자 1명당 최대 5포인트',
      '실제 수령분은 본인 지위에 따라 결정 (예: SP 3포인트)',
      '잔여 포인트는 소멸 없이 상위로 이어짐',
      '예: GC가 나머지 2포인트 수령'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 6000, index: 1 },
      { at: 26000, index: 2 },
      { at: 39000, index: 3 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    header: 300,
    max: 600,
    fill: 1500,
    label: 6000,
    fillers: 10400,
    stack: [11000, 11900, 12800],
    links: 13700,
    sp: 18000,
    remain: 26000,
    gcHi: 34000,
    gc: 39000,
    gcSelf: 41800,
    sumGc: 49500,
    sum: 46000
  },

  layout: { anchorZone: 'd4' }
};
</script>
