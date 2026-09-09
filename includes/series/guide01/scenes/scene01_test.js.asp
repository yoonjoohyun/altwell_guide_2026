<script>
/* guide01 Scene 01 — 멤버 에셋 부착 테스트 (0909test.asp 전용) */
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

    Guide01.resetScene('scene01-canvas');
    Guide01.mountStage(canvas, 'scene01-canvas');

    var memberWrap = Guide01.mountMemberAtZone(canvas, 'scene01-member', 'd4');
    var attachPlans = [
      Guide01.prepareMemberAttach(memberWrap, {
        slot: 'autoship',
        openTemplate: 'autoship_icon',
        closedTemplate: 'autoship_icon_c'
      }),
      Guide01.prepareMemberAttach(memberWrap, {
        slot: 'rank',
        openTemplate: 'lev_p',
        closedTemplate: 'lev_p'
      }),
      Guide01.prepareMemberAttach(memberWrap, {
        slot: 'base',
        openTemplate: 'base_business_icon',
        closedTemplate: 'base_business_icon_c'
      }),
      Guide01.prepareMemberAttach(memberWrap, {
        slot: 'bonus',
        openTemplate: 'recommend_bonus_icon',
        closedTemplate: 'recommend_bonus_icon_c'
      })
    ].filter(Boolean);

    await Guide01.showMemberWrap(memberWrap);

    await Promise.all([
      Guide01.runMemberAttachSequence(ctx, canvas, attachPlans, tl, [1000, 8000, 15000, 22000]),
      (async function(){
        await Guide01.panelTitle('오토십이란?', 0, tl);
        await Guide01.endScene(ctx, canvas, tl);
      })()
    ]);
  }
});
</script>
