<script>
/* Series: guide05 — 매칭보너스 알아보기 (씬 3~6·클로징은 제작 예정) */
var SeriesGuide05 = {
  meta: {
    id: 'guide05',
    lessonTitle: '매칭보너스 알아보기',
    chapterTitle: '매칭보너스 알아보기'
  },

  init: function(){
    SceneRunner.setLessonMeta(this.meta);
    SceneRunner.registerScene(Guide05Scene01);
    SceneRunner.registerScene(Guide05Scene02);
    SceneRunner.registerScene(Guide05Scene03);
    SceneRunner.registerScene(Guide05Scene04);
    SceneRunner.registerScene(Guide05Scene05);
    SceneRunner.registerScene(Guide05Scene06);
    SceneRunner.registerScene(Guide05Scene07);

    if(typeof SceneMedia !== 'undefined'){
      SceneMedia.setSeriesId(this.meta.id);
      var scenes = SceneRunner.getScenes();
      var configs = [];
      if(typeof Guide05Scene01Config !== 'undefined') configs.push(Guide05Scene01Config);
      if(typeof Guide05Scene02Config !== 'undefined') configs.push(Guide05Scene02Config);
      if(typeof Guide05Scene03Config !== 'undefined') configs.push(Guide05Scene03Config);
      if(typeof Guide05Scene04Config !== 'undefined') configs.push(Guide05Scene04Config);
      if(typeof Guide05Scene05Config !== 'undefined') configs.push(Guide05Scene05Config);
      if(typeof Guide05Scene06Config !== 'undefined') configs.push(Guide05Scene06Config);
      if(typeof Guide05Scene07Config !== 'undefined') configs.push(Guide05Scene07Config);

      function probeTitles(done){
        var index = 0;
        function next(){
          if(index >= scenes.length) return done();
          var sceneIndex = index;
          var config = configs[sceneIndex];
          var seq = config && config.media && config.media.sequence;
          index += 1;
          if(!seq || !seq.length || !SceneMedia.probeDurationPath) return next();
          var fallbacks = config.media.fallbackMs || [];
          var chain = Promise.resolve();
          seq.forEach(function(item, idx){
            chain = chain.then(function(){
              var part = item.part || '';
              return SceneMedia.probeDurationPath(
                SceneMedia.getMediaPath(sceneIndex, part),
                fallbacks[idx] || 30000
              ).then(function(ms){
                if(!(ms > 0)) return;
                if(!config.media.partMs) config.media.partMs = {};
                config.media.partMs[part || 'main'] = ms;
                if(part === 'title'){
                  config.media.titleMs = ms;
                  if(scenes[sceneIndex]) scenes[sceneIndex].mediaTitleMs = ms;
                }
              });
            });
          });
          chain.then(next);
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
