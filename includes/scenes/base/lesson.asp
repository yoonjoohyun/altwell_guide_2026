<script>
/* BASE lesson - scene registration */
var LessonBase = {
  meta: {
    id: 'base',
    lessonTitle: 'BASE사업자 이해하기',
    chapterTitle: 'BASE사업자 이해하기'
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);
    SceneRunner.registerScene(BaseScene01);

    var sceneLabel = document.getElementById('lo-scene-label');
    if(sceneLabel) sceneLabel.textContent = this.meta.lessonTitle;

    var pageTitle = document.querySelector('title');
    if(pageTitle) pageTitle.textContent = this.meta.lessonTitle + ' - ALTWELL SMART GUIDE';

    SceneRunner.init();
  }
};
</script>
