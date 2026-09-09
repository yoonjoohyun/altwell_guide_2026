<script>
/* guide01 Scene 01 — 오토십이란? */
var Guide01Scene01 = defineScene({
  id: 'guide01-scene-01',
  title: '오토십이란?',
  duration: 0,

  reset: function(){
    Guide01.resetScene('scene01-canvas');
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene('scene01-canvas');
    Guide01.mountStage(canvas, 'scene01-canvas');

    /* 씬1 모션·패널 타임라인 — 여기부터 작성 */

    await Guide01.endScene(ctx, canvas, tl);
  }
});
</script>
