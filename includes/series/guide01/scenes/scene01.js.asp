<script>
/* guide01 Scene 01 — 오토십이란? (모션그래픽 재작업용 골격) */
var Guide01Scene01 = defineScene({
  id: Scene01Config.id,
  title: Scene01Config.title,
  duration: Scene01Config.duration,

  reset: function(){
    Guide01.resetScene(Scene01Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene01Config.canvasCls);
    Guide01.mountStage(canvas, Scene01Config.canvasCls);

    await Guide01.panelTitle(Scene01Config.panel.title, 0, tl);
    await runScene01Motion(tl, setupScene01Assets(canvas), ctx);
    await Guide01.finishSceneHold(tl, Scene01Config.duration);
  }
});

async function runScene01Motion(tl, assets, ctx){
  /* TODO: scene01.setup.js.asp · scene01.constants.js.asp 기준으로 타임라인 작성 */
}

</script>
