<script>
/*
 * defineScene — 씬 1개 = motion(좌) + panel(우) + voice(mp4)
 *
 * voice: voice/{seriesId}/scene01.mp4 … SceneMedia가 register 순서(0-based index)로 자동 재생
 *
 * var MyScene01 = defineScene({
 *   id: 'my-scene-01',
 *   title: '씬 제목',
 *   duration: 16000,
 *   motion: { mountCanvas, reset, endState },
 *   panel:  { reset, endState },
 *   play: async function(ctx){ … motion·panel 타임라인 … }
 * });
 */
function defineScene(spec){
  spec = spec || {};
  var motion = spec.motion || {};
  var panel = spec.panel || {};

  var scene = {
    id: spec.id,
    title: spec.title || '',
    duration: spec.duration || 0,
    mediaStartDelay: spec.mediaStartDelay || 0,
    mediaSequence: spec.mediaSequence || null,
    mediaFallbackMs: spec.mediaFallbackMs || null,

    reset: function(){
      if(typeof spec.reset === 'function') return spec.reset();
      if(motion.reset) motion.reset();
      if(panel.reset) panel.reset();
    },

    play: spec.play || async function(ctx){
      if(motion.play) await motion.play(ctx);
      if(panel.play) await panel.play(ctx);
    },

    endState: function(){
      if(typeof spec.endState === 'function') return spec.endState();
      if(motion.endState) motion.endState();
      if(panel.endState) panel.endState();
    },

    _mountCanvas: motion.mountCanvas || motion._mountCanvas
  };

  scene._motion = motion;
  scene._panel = panel;
  return scene;
}

var SceneMotion = {
  canvas: function(){
    return document.getElementById('motion-canvas');
  }
};

var ScenePanel = {
  els: function(){
    return {
      chapter: document.getElementById('panel-fixed-title'),
      title: document.getElementById('scene-title-main'),
      desc: document.getElementById('panel-scene-desc'),
      bullets: document.getElementById('scene-bullets')
    };
  },

  reset: function(){
    var ids = ['panel-fixed-title','scene-title-main','panel-scene-desc','scene-bullets'];
    for(var i = 0; i < ids.length; i++){
      var el = document.getElementById(ids[i]);
      if(!el) continue;
      if(el.tagName === 'UL') el.innerHTML = '';
      else if(el.tagName === 'H2') el.innerHTML = '';
      else el.textContent = '';
      el.classList.add('is-hidden');
    }
  }
};
</script>
