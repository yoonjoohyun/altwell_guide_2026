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
    SceneRunner.registerScene(Guide02Scene02);
    SceneRunner.registerScene(Guide02Scene03);
    SceneRunner.registerScene(Guide02Scene04);
    SceneRunner.registerScene(Guide02Scene05);

    if(typeof SceneMedia !== 'undefined'){
      SceneMedia.setSeriesId(this.meta.id);
      var scenes = SceneRunner.getScenes();
      var configs = [];
      if(typeof Guide02Scene01Config !== 'undefined') configs.push(Guide02Scene01Config);
      if(typeof Guide02Scene02Config !== 'undefined') configs.push(Guide02Scene02Config);
      if(typeof Guide02Scene03Config !== 'undefined') configs.push(Guide02Scene03Config);
      if(typeof Guide02Scene04Config !== 'undefined') configs.push(Guide02Scene04Config);
      if(typeof Guide02Scene05Config !== 'undefined') configs.push(Guide02Scene05Config);

      function probeTitles(done){
        var index = 0;
        function next(){
          if(index >= scenes.length) return done();
          var sceneIndex = index;
          var config = configs[sceneIndex];
          var seq = config && config.media && config.media.sequence;
          index += 1;
          if(!seq || !seq.length || seq[0].part !== 'title' || !SceneMedia.probeDurationPath) return next();
          SceneMedia.probeDurationPath(
            SceneMedia.getMediaPath(sceneIndex, 'title'),
            config.media.fallbackMs[0]
          ).then(function(ms){
            if(ms > 0){
              config.media.titleMs = ms;
              if(scenes[sceneIndex]) scenes[sceneIndex].mediaTitleMs = ms;
            }
            next();
          });
        }
        next();
      }

      function prepareAll(done){
        var chain = Promise.resolve();
        scenes.forEach(function(scene, sceneIndex){
          chain = chain.then(function(){
            if(!scene || !scene.mediaSequence || !SceneMedia.filterSequence) return;
            return SceneMedia.filterSequence(sceneIndex, scene.mediaSequence).then(function(filtered){
              var config = configs[sceneIndex];
              var fallback = config && config.media ? config.media.sequence : scene.mediaSequence;
              scene.mediaSequence = filtered.length >= 2 ? filtered : fallback;
              if(SceneMedia.prepareSequence) SceneMedia.prepareSequence(sceneIndex, scene.mediaSequence);
            });
          });
        });
        chain.then(done);
      }

      prepareAll(function(){
        probeTitles(function(){
          SceneMedia.applyDurations(scenes, function(){
            scenes.forEach(function(scene, sceneIndex){
              if(scene && scene.duration && configs[sceneIndex]) configs[sceneIndex].duration = scene.duration;
            });
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
