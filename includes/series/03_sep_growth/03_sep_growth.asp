<script>
/* Series: 03_sep_growth — SEP 성장하기 테스트 */
var Series03SepGrowth = {
  meta: {
    id: '03_sep_growth',
    lessonTitle: 'SEP 성장하기',
    chapterTitle: 'SEP 성장하기'
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);
    SceneRunner.registerScene(SepScene01);

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
