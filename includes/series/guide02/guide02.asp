<script>
/* Series: guide02 — 스타트팩 알아보기 */
var SeriesGuide02 = {
  meta: {
    id: 'guide02',
    lessonTitle: '스타트팩 알아보기',
    chapterTitle: '스타트팩 알아보기'
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);
    SceneRunner.registerScene(Guide02Scene01);

    if(typeof SceneMedia !== 'undefined'){
      SceneMedia.setSeriesId(this.meta.id);
      var scenes = SceneRunner.getScenes();
      var config = typeof Guide02Scene01Config !== 'undefined' ? Guide02Scene01Config : null;

      function probeTitle(done){
        var seq = config && config.media && config.media.sequence;
        if(!seq || !seq.length || seq[0].part !== 'title' || !SceneMedia.probeDurationPath){
          return done();
        }
        SceneMedia.probeDurationPath(
          SceneMedia.getMediaPath(0, 'title'),
          config.media.fallbackMs[0]
        ).then(function(ms){
          if(ms > 0){
            config.media.titleMs = ms;
            if(scenes[0]) scenes[0].mediaTitleMs = ms;
          }
          done();
        });
      }

      function prepare(done){
        var scene = scenes[0];
        if(!scene || !scene.mediaSequence || !SceneMedia.filterSequence) return done();
        SceneMedia.filterSequence(0, scene.mediaSequence).then(function(filtered){
          var fallback = config && config.media ? config.media.sequence : scene.mediaSequence;
          scene.mediaSequence = filtered.length >= 2 ? filtered : fallback;
          if(SceneMedia.prepareSequence) SceneMedia.prepareSequence(0, scene.mediaSequence);
          done();
        });
      }

      prepare(function(){
        probeTitle(function(){
          SceneMedia.applyDurations(scenes, function(){
            if(scenes[0] && scenes[0].duration && config) config.duration = scenes[0].duration;
            SceneRunner.renderTimelineMarkers();
            SceneRunner.updatePlayerUI();
          });
        });
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
