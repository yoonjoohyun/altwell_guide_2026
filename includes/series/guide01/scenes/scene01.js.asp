<script>
/* guide01 Scene 01 — 오토십이란? */
var Guide01Scene01 = defineScene({
  id: 'guide01-scene-01',
  title: '오토십이란?',
  duration: 29000,

  reset: function(){
    Guide01.resetScene('scene01-canvas');
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var tl = Guide01.timeline(ctx);
    var sceneDur = ctx.sceneDuration || 29000;

    Guide01.resetScene('scene01-canvas');
    Guide01.mountStage(canvas, 'scene01-canvas');

    var autoshipWrap = Guide01.addZonedAsset(canvas, 'autoship_icon', 'scene01-autoship', 'a1');
    var autoship = autoshipWrap && autoshipWrap.firstElementChild;
    if(autoship) Guide01.badgeToOpen(autoship);

    await Guide01.showZoned(autoshipWrap);

    await Promise.all([
      Guide01.animateZoneBouncePath(ctx, autoshipWrap, {
        from: 'a1',
        to: 'g7',
        duration: sceneDur,
        bounces: 13,
        bouncePx: 16
      }),
      (async function(){
        await Guide01.panelTitle('오토십이란?', 0, tl);
        await Guide01.endScene(ctx, canvas, tl);
      })()
    ]);
  }
});
</script>
