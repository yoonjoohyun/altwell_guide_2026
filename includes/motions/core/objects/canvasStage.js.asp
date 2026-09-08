<script>
/* Canvas Stage — 표준 배경·데코 레이어 DOM 구성 */
var CanvasStage = {
  mountStandard: function(canvas, options){
    options = options || {};
    if(!canvas) return null;
    if(options.replace !== false) canvas.innerHTML = '';
    if(options.sceneClass){
      var classes = String(options.sceneClass).split(/\s+/);
      for(var i = 0; i < classes.length; i++){
        if(classes[i]) canvas.classList.add(classes[i]);
      }
    }

    var bg = document.createElement('div');
    bg.className = 'scene01-stage-bg scene-canvas-bg';
    canvas.appendChild(bg);

    /* 도트·원형 배경은 #motion-stage-bg (video_layout) 에 고정 — 씬 reset 시 유지 */

    return canvas;
  },

  reset: function(canvas, sceneClasses){
    if(!canvas) return;
    if(sceneClasses){
      var list = Array.isArray(sceneClasses) ? sceneClasses : String(sceneClasses).split(/\s+/);
      for(var i = 0; i < list.length; i++){
        if(list[i]) canvas.classList.remove(list[i]);
      }
    }
    canvas.innerHTML = '';
    canvas.style.opacity = '';
    canvas.style.transition = '';
  }
};
</script>
