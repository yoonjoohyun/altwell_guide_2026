<script>
/* guide04 Scene 05 — 추천보너스 핵심 정리
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준.
   단계: ①BASE 자격 → ②포인트 기준 카드 → ③회원 증가 → ④1P=1만원 → ⑤핵심 3가지 */
var Guide04Scene05Config = {
  id: 'guide04-scene-05',
  title: '추천보너스 핵심 정리',
  duration: 56000,
  canvasCls: 'g04-scene05-canvas',
  panelCls: 'g04-scene05-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide04_scene_05_title.mp4' },
      { part: 'main', file: 'guide04_scene_05.mp4' }
    ],
    fallbackMs: [4000, 50000],
    titleMs: 4000
  },

  panel: {
    title: '추천보너스 핵심 정리',
    bullets: [
      '첫 번째 조건: BASE사업자 자격 유지',
      '오토십 회원 1명당 매월 1P · 스타트팩 최초 1회 5P',
      '추천 회원이 늘수록 포인트 증가, 적립 상한 없음',
      '1포인트당 최대 1만원의 추천보너스로 지급',
      '핵심 3가지: BASE 유지 · 신규 추천 · 제품 이용 지원'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 6000, index: 1 },
      { at: 19000, index: 2 },
      { at: 27000, index: 3 },
      { at: 36000, index: 4 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    base: 300,
    check: 2200,
    cards: [6000, 12000],
    grow: 19000,
    batches: [19400, 20800, 22200, 23600],
    cap: 24200,
    cash: 27000,
    three: 32000,
    slots: [36000, 39000, 43000],
    glow: 46000
  },

  layout: { anchorZone: 'd4' }
};
</script>
