<script>
/* Series: 01_base_business_running ? scene registration */
var Series01BaseBusinessRunning = {
  meta: {
    id: '01_base_business_running',
    lessonTitle: 'BASE사업자 이해하기',
    chapterTitle: 'BASE사업자 이해하기'
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);
    SceneRunner.registerScene(BaseScene01);
    SceneRunner.registerScene(BaseScene02);
    SceneRunner.registerScene(BaseScene03);
    SceneRunner.registerScene(BaseScene04);
    SceneRunner.registerScene(BaseScene05);
    SceneRunner.registerScene(BaseScene06);
    SceneRunner.registerScene(BaseScene07);

    if(typeof SceneMedia !== 'undefined'){
      SceneMedia.setSeriesId(this.meta.id);
      SceneMedia.applyDurations(SceneRunner.getScenes(), function(){
        SceneRunner.renderTimelineMarkers();
        SceneRunner.updatePlayerUI();
      });
    }

    var sceneLabel = document.getElementById('lo-scene-label');
    if(sceneLabel) sceneLabel.textContent = this.meta.lessonTitle;

    var pageTitle = document.querySelector('title');
    if(pageTitle) pageTitle.textContent = this.meta.lessonTitle + ' - ALTWELL SMART GUIDE';

    SceneRunner.init();
  }
};
</script>
