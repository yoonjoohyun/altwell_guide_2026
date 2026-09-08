<script>
/*
 * 씬 제작 템플릿 — 복사 후 sceneNN.js.asp 로 저장
 *
 * 씬 1개에 필요한 3요소
 *   1. motion  — #motion-canvas 안 그래픽·애니메이션
 *   2. panel   — #lo-panel 부연설명·bullet
 *   3. voice   — voice/{seriesId}/sceneNN.mp4 (파일만 추가, SceneMedia 자동 재생)
 */
var ExampleScene01 = defineScene({
  id: 'example-scene-01',
  title: '씬 제목',
  duration: 10000,

  motion: {
    mountCanvas: function(canvas){
      MotionCanvasStandardStage.run({ canvas: canvas });
      /* canvas.appendChild( … 오브젝트 … ); */
    },
    reset: function(){
      CanvasStage.reset(SceneMotion.canvas());
    },
    endState: function(){}
  },

  panel: {
    reset: function(){
      ScenePanel.reset();
    },
    endState: function(){}
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    this._motion.mountCanvas(canvas);
    var cancelled = function(){ return MotionComponent.cancelled(ctx); };
    var T = createSceneTiming(ctx, this.duration);
    setActiveSceneTiming(T);

    try {
      await T.padStart();
      if(cancelled()) return;

      setSceneTitle(this.title);
      showElement('#scene-title-main');

      /* … 모션·패널 타임라인 … */

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  }
});
</script>
