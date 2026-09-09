<script>
/* Series: guide01 — 오토십 알아보기 (씬 순차 제작) */
var SeriesGuide01 = {
  meta: {
    id: 'guide01',
    lessonTitle: '오토십 알아보기',
    chapterTitle: '오토십 알아보기'
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);

    SceneRunner.registerScene(Guide01Scene01);

    if(typeof SceneMedia !== 'undefined'){
      SceneMedia.setSeriesId(this.meta.id);
      SceneMedia.applyDurations(SceneRunner.getScenes(), function(){
        SceneRunner.renderTimelineMarkers();
        SceneRunner.updatePlayerUI();
      });
    }

    SceneRunner.init();

    var sceneLabel = document.getElementById('lo-scene-label');
    if(sceneLabel) sceneLabel.textContent = this.meta.lessonTitle;

    var pageTitle = document.querySelector('title');
    if(pageTitle) pageTitle.textContent = this.meta.lessonTitle + ' - ALTWELL SMART GUIDE';
  }
};
</script>
