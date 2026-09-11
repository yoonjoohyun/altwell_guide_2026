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
      var scenes = SceneRunner.getScenes();
      var s0 = scenes[0];
      function probeScene01TitleMs(done){
        if(!SceneMedia.getMediaPath || !SceneMedia.probeDurationPath) return done();
        SceneMedia.probeDurationPath(
          SceneMedia.getMediaPath(0, 'title'),
          Scene01Config.media.fallbackMs[0]
        ).then(function(ms){
          if(ms > 0){
            Scene01Config.media.titleMs = ms;
            if(s0) s0.mediaTitleMs = ms;
          }
          done();
        });
      }

      if(s0 && s0.mediaSequence && SceneMedia.filterSequence){
        SceneMedia.filterSequence(0, s0.mediaSequence).then(function(filtered){
          s0.mediaSequence = filtered.length >= 2 ? filtered : Scene01Config.media.sequence;
          if(SceneMedia.prepareSequence){
            SceneMedia.prepareSequence(0, s0.mediaSequence);
          }
          probeScene01TitleMs(function(){
            SceneMedia.applyDurations(scenes, onGuide01DurationsReady);
          });
        });
      } else {
        probeScene01TitleMs(function(){
          SceneMedia.applyDurations(scenes, onGuide01DurationsReady);
        });
      }
    }

    function onGuide01DurationsReady(){
      var scene0 = SceneRunner.getScenes()[0];
      if(scene0 && scene0.duration) Scene01Config.duration = scene0.duration;
      SceneRunner.renderTimelineMarkers();
      SceneRunner.updatePlayerUI();
    }

    SceneRunner.init();

    var sceneLabel = document.getElementById('lo-scene-label');
    if(sceneLabel) sceneLabel.textContent = this.meta.lessonTitle;

    var pageTitle = document.querySelector('title');
    if(pageTitle) pageTitle.textContent = this.meta.lessonTitle + ' - ALTWELL SMART GUIDE';
  }
};
</script>
