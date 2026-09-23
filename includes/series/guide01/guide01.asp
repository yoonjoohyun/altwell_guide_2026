<script>
/* Series: guide01 — 오토십 알아보기 (씬 순차 제작) */
var SeriesGuide01 = {
  meta: {
    id: 'guide01',
    lessonTitle: '오토십 알아보기',
    chapterTitle: '오토십 알아보기'
  },

  _sceneMediaMeta: function(){
    return [
      { config: typeof Scene01Config !== 'undefined' ? Scene01Config : null },
      { config: typeof Scene02Config !== 'undefined' ? Scene02Config : null },
      { config: typeof Scene03Config !== 'undefined' ? Scene03Config : null },
      { config: typeof Scene04Config !== 'undefined' ? Scene04Config : null },
      { config: typeof Scene05Config !== 'undefined' ? Scene05Config : null }
    ];
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);

    SceneRunner.registerScene(Guide01Scene01);
    SceneRunner.registerScene(Guide01Scene02);
    SceneRunner.registerScene(Guide01Scene03);
    SceneRunner.registerScene(Guide01Scene04);
    SceneRunner.registerScene(Guide01Scene05);

    if(typeof SceneMedia !== 'undefined'){
      SceneMedia.setSeriesId(this.meta.id);
      var scenes = SceneRunner.getScenes();
      var metaList = this._sceneMediaMeta();

      function probeTitleMs(sceneIndex, config, sceneObj, done){
        if(!config || !config.media || !SceneMedia.getMediaPath || !SceneMedia.probeDurationPath){
          return done();
        }
        var seq = config.media.sequence;
        if(!seq || !seq.length || seq[0].part !== 'title'){
          return done();
        }
        SceneMedia.probeDurationPath(
          SceneMedia.getMediaPath(sceneIndex, 'title'),
          config.media.fallbackMs[0]
        ).then(function(ms){
          if(ms > 0){
            config.media.titleMs = ms;
            if(sceneObj) sceneObj.mediaTitleMs = ms;
          }
          done();
        });
      }

      function probeAllTitleMs(done){
        var i = 0;
        function next(){
          if(i >= scenes.length) return done();
          var idx = i++;
          probeTitleMs(idx, metaList[idx] && metaList[idx].config, scenes[idx], next);
        }
        next();
      }

      function prepareSceneSequences(done){
        var chain = Promise.resolve();
        var i;
        for(i = 0; i < scenes.length; i++){
          (function(idx, scene){
            if(scene && scene.mediaSequence && SceneMedia.filterSequence){
              chain = chain.then(function(){
                return SceneMedia.filterSequence(idx, scene.mediaSequence).then(function(filtered){
                  var fallback = metaList[idx] && metaList[idx].config
                    ? metaList[idx].config.media.sequence
                    : scene.mediaSequence;
                  scene.mediaSequence = filtered.length >= 2 ? filtered : fallback;
                  if(SceneMedia.prepareSequence){
                    SceneMedia.prepareSequence(idx, scene.mediaSequence);
                  }
                });
              });
            }
          })(i, scenes[i]);
        }
        chain.then(done);
      }

      prepareSceneSequences(function(){
        probeAllTitleMs(function(){
          SceneMedia.applyDurations(scenes, onGuide01DurationsReady);
        });
      });
    }

    function onGuide01DurationsReady(){
      var list = SceneRunner.getScenes();
      if(list[0] && list[0].duration && typeof Scene01Config !== 'undefined'){
        Scene01Config.duration = list[0].duration;
      }
      if(list[1] && list[1].duration && typeof Scene02Config !== 'undefined'){
        Scene02Config.duration = list[1].duration;
      }
      if(list[2] && list[2].duration && typeof Scene03Config !== 'undefined'){
        Scene03Config.duration = list[2].duration;
      }
      if(list[3] && list[3].duration && typeof Scene04Config !== 'undefined'){
        Scene04Config.duration = list[3].duration;
      }
      if(list[4] && list[4].duration && typeof Scene05Config !== 'undefined'){
        Scene05Config.duration = list[4].duration;
      }
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
