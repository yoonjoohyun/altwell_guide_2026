<script>
/* guide01 Scene 01 — 상수 (재작업 시 채움) */
var Scene01Config = {
  id: 'guide01-scene-01',
  title: '오토십이란?',
  duration: 29000,
  canvasCls: 'scene01-canvas',

  panel: {
    title: '오토십이란?',
    bullets: [],
    flashes: []
  },

  T: {},

  motion: {
    FADE: { duration: 280 },
    POP: { pop: true, duration: 320 },
    BADGE: { unfoldDuration: 620 }
  }
};

function scene01Motion(preset){
  preset = preset || 'FADE';
  var base = Scene01Config.motion[preset] || Scene01Config.motion.FADE;
  return Object.assign({}, base);
}

function scene01BadgeEnter(extra){
  return Object.assign({}, Scene01Config.motion.POP, Scene01Config.motion.BADGE, extra || {});
}

</script>
