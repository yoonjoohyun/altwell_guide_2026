<script>
/* BASE사업자 이해하기 ? Interactive Simulator (Scene01~03 based) */

var BaseSimulatorData = [
  {
    id: 'sm-step-01',
    sourceScenes: ['scene01', 'scene03'],
    title: 'BASE사업자란 무엇일까요?',
    question: 'BASE사업자는 무엇을 의미할까요?',
    questionAudio: null,
    choices: [
      { id: 'a', text: '앨트웰의 새로운 제품명', correct: false },
      { id: 'b', text: '하나의 지위만을 의미하는 명칭', correct: false },
      { id: 'c', text: '권리 소득을 받을 수 있는 자격', correct: true }
    ],
    hint: 'BASE사업자는 D, P, JP와 같은 지위와는 다른 개념입니다.',
    feedback: '맞습니다. BASE사업자는 하나의 지위라기보다 권리 소득이 시작되는 자격입니다.'
  },
  {
    id: 'sm-step-02',
    sourceScenes: ['scene02'],
    title: '비즈니스 성장의 전환점',
    question: '이 디슈머가 BASE사업자로 성장하려면\n다음 화면에 어떤 변화가 필요할까요?',
    questionAudio: null,
    choices: [
      { id: 'a', text: '하위에 오토십을 이용하는 디슈머 2명이 생긴다', correct: true },
      { id: 'b', text: 'D 지위 메달을 제거한다', correct: false },
      { id: 'c', text: '본인의 AUTOSHIP을 해제한다', correct: false }
    ],
    hint: 'BASE BUSINESS Badge는 지위 메달을 교체하지 않습니다.',
    feedback: '맞습니다. BASE사업자 자격과 현재 지위는 독립적으로 표시됩니다.'
  },
  {
    id: 'sm-step-03',
    sourceScenes: ['scene03'],
    title: 'BASE사업자의 의미',
    question: 'BASE사업자가 되는 순간 가장 적합한 변화는 무엇일까요?',
    questionAudio: null,
    choices: [
      { id: 'a', text: '제품을 더 이상 사용하지 않는 상태', correct: false },
      { id: 'b', text: '똑똑한 소비자에서 권리 소득을 만들어가는 사업자로 전환', correct: true },
      { id: 'c', text: '모든 지위를 자동으로 획득하는 상태', correct: false }
    ],
    hint: 'BASE사업자가 된다고 모든 지위가 자동으로 승급되는 것은 아닙니다.',
    feedback: '정확합니다. BASE사업자는 권리 소득 시스템으로 들어가는 첫 번째 전환점입니다.',
    completeLabel: '학습 완료'
  }
];

var BaseSimulator = {
  currentStep: 0,
  selectedChoice: null,
  completedSteps: [false, false, false],
  stepSnapshots: {},
  isAnswered: false,
  isCorrect: false,
  isAnimating: false,
  isResult: false,
  _flyBadge: null,
  _questionAudio: null,
  _introToken: 0,

  _setAnimating: function(v){
    this.isAnimating = !!v;
  },

  _animTimeout: function(promise, ms){
    ms = ms || 5000;
    return Promise.race([promise, wait(ms)]);
  },

  _onAnimEnd: function(el, ms){
    ms = ms || 3500;
    return new Promise(function(resolve){
      if(!el){ resolve(); return; }
      var settled = false;
      function done(){
        if(settled) return;
        settled = true;
        el.removeEventListener('animationend', onEnd);
        resolve();
      }
      function onEnd(){ done(); }
      el.addEventListener('animationend', onEnd);
      setTimeout(done, ms);
    });
  },

  _startFloatMain: function(){
    var visual = document.querySelector('#member-unit-main .member-visual');
    if(visual) visual.classList.add('motion-idle-float');
  },

  _stopFloatMain: function(){
    var visual = document.querySelector('#member-unit-main .member-visual');
    if(visual) visual.classList.remove('motion-idle-float');
  },

  initializeSimulator: function(){
    this.currentStep = 0;
    this.selectedChoice = null;
    this.completedSteps = [false, false, false];
    this.stepSnapshots = {};
    this.isAnswered = false;
    this.isCorrect = false;
    this.isAnimating = false;
    this.isResult = false;
    this._flyBadge = null;
    this._stopQuestionAudio();

    var qPanel = document.getElementById('sim-question-panel');
    var rPanel = document.getElementById('sim-result-panel');
    if(qPanel) qPanel.classList.remove('is-hidden');
    if(rPanel) rPanel.classList.add('is-hidden');

    this._bindControls();
    this.renderStep(0);
    this.playStepIntro(0);
  },

  _bindControls: function(){
    var self = this;
    var prev = document.getElementById('sim-btn-prev');
    var next = document.getElementById('sim-btn-next');
    var restart = document.getElementById('sim-btn-restart');
    var panelNext = document.getElementById('sim-next-btn');
    var relearn = document.getElementById('sim-btn-relearn');
    var watch = document.getElementById('sim-btn-watch-video');
    var back = document.getElementById('sim-btn-back-list');

    if(prev && !prev._simBound){
      prev._simBound = true;
      prev.addEventListener('click', function(){ self.previousStep(); });
    }
    if(next && !next._simBound){
      next._simBound = true;
      next.addEventListener('click', function(){ self.nextStep(); });
    }
    if(restart && !restart._simBound){
      restart._simBound = true;
      restart.addEventListener('click', function(){ self.restartSimulator(); });
    }
    if(panelNext && !panelNext._simBound){
      panelNext._simBound = true;
      panelNext.addEventListener('click', function(){ self.nextStep(); });
    }
    if(relearn && !relearn._simBound){
      relearn._simBound = true;
      relearn.addEventListener('click', function(){ self.restartSimulator(); });
    }
    if(watch && !watch._simBound){
      watch._simBound = true;
      watch.addEventListener('click', function(){
        location.href = '01_base_business_running.asp?from=sim';
      });
    }
    if(back && !back._simBound){
      back._simBound = true;
      back.addEventListener('click', function(){ closeSimulator(); });
    }
  },

  _stopQuestionAudio: function(){
    if(this._questionAudio){
      try{
        this._questionAudio.pause();
        this._questionAudio.src = '';
      }catch(e){}
      this._questionAudio = null;
    }
  },

  _playQuestionAudio: function(src){
    this._stopQuestionAudio();
    if(!src) return;
    try{
      var audio = new Audio(src);
      this._questionAudio = audio;
      audio.play().catch(function(){});
    }catch(e){}
  },

  renderStep: function(index){
    if(this.isResult) return;

    var step = BaseSimulatorData[index];
    if(!step) return;

    this.currentStep = index;
    this.isAnswered = !!this.completedSteps[index];
    this.isCorrect = this.isAnswered;
    this.selectedChoice = this.stepSnapshots[index] ? this.stepSnapshots[index].choiceId : null;

    var stepLabel = document.getElementById('sim-step-label');
    var title = document.getElementById('scene-title-main');
    var question = document.getElementById('sim-question');
    var choices = document.getElementById('sim-choices');
    var feedback = document.getElementById('sim-feedback');
    var nextBtn = document.getElementById('sim-next-btn');

    if(stepLabel) stepLabel.textContent = 'STEP ' + (index + 1);
    if(title){
      title.textContent = step.title;
      title.classList.remove('is-hidden');
    }
    if(question){
      question.textContent = step.question;
      question.style.whiteSpace = 'pre-line';
    }

    if(choices){
      choices.innerHTML = '';
      var self = this;
      step.choices.forEach(function(choice, ci){
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'sim-choice-btn';
        btn.id = 'sim-choice-' + index + '-' + choice.id;
        btn.setAttribute('data-choice-index', String(ci));
        btn.setAttribute('aria-label', String.fromCharCode(65 + ci) + '. ' + choice.text);
        btn.innerHTML =
          '<span class="sim-choice-key" aria-hidden="true">' + String.fromCharCode(65 + ci) + '.</span>' +
          '<span class="sim-choice-text">' + choice.text + '</span>';
        btn.addEventListener('click', function(){
          self.selectChoice(index, ci);
        });
        choices.appendChild(btn);
      });
    }

    if(feedback){
      feedback.classList.add('is-hidden');
      feedback.innerHTML = '';
      feedback.className = 'sim-feedback is-hidden';
    }

    if(nextBtn){
      nextBtn.classList.add('is-hidden');
      nextBtn.disabled = true;
      nextBtn.textContent = (index === BaseSimulatorData.length - 1) ? '학습 완료' : '다음 단계';
    }

    if(this.completedSteps[index]){
      this._restoreChoiceUI(index);
      this.showCorrectFeedback(step.feedback, true);
      this.enableNextStep();
    }

    this._updateProgressUI();
    this._updateControlButtons();

    var canvas = document.getElementById('motion-canvas');
    if(!canvas) return;

    if(this.completedSteps[index] && this.stepSnapshots[index]){
      this._restoreCanvasState(index);
    } else {
      this._mountStepCanvas(index, false);
    }
  },

  playStepIntro: async function(index){
    if(this.isResult) return;
    if(this.completedSteps[index]) return;
    if(this.isAnimating) return;

    var token = ++this._introToken;
    this._setAnimating(true);
    this._updateControlButtons();
    try{
      if(index === 0){
        await this._animTimeout(this._introStep01(), 8000);
      } else if(index === 1){
        await this._animTimeout(this._introStep02(), 12000);
      } else if(index === 2){
        await this._animTimeout(this._introStep03(), 10000);
      }
      if(token !== this._introToken) return;
      this._playQuestionAudio(BaseSimulatorData[index].questionAudio);
    } finally {
      if(token === this._introToken){
        this._setAnimating(false);
        this._updateControlButtons();
      }
    }
  },

  selectChoice: async function(stepIndex, choiceIndex){
    if(this.isAnimating) return;
    if(this.isResult) return;
    if(stepIndex !== this.currentStep) return;

    var step = BaseSimulatorData[stepIndex];
    if(!step) return;

    if(this.isAnswered && this.isCorrect) return;

    var choice = step.choices[choiceIndex];
    if(!choice) return;

    this.selectedChoice = choice.id;
    this._highlightChoice(stepIndex, choiceIndex, choice.correct ? 'correct' : 'incorrect');

    if(choice.correct){
      this.isAnswered = true;
      this.isCorrect = true;
      this.completedSteps[stepIndex] = true;
      this.stepSnapshots[stepIndex] = { choiceId: choice.id, choiceIndex: choiceIndex };

      this.showCorrectFeedback(step.feedback, false);
      this._updateProgressUI();
      this._updateControlButtons();

      this._setAnimating(true);
      this._updateControlButtons();
      try{
        if(stepIndex === 0) await this._animTimeout(this._correctStep01(), 10000);
        else if(stepIndex === 1) await this._animTimeout(this._correctStep02(), 20000);
        else if(stepIndex === 2) await this._animTimeout(this._correctStep03(), 10000);

        this.stepSnapshots[stepIndex].canvasReady = true;
      } finally {
        this._setAnimating(false);
      }

      this.enableNextStep();
      this._updateControlButtons();
    } else {
      this.showIncorrectFeedback(step.hint);
      if(stepIndex === 1){
        this._setAnimating(true);
        this._updateControlButtons();
        try{
          await this._animTimeout(this._hintStep02(), 3000);
        } finally {
          this._setAnimating(false);
          this._updateControlButtons();
        }
      }
    }
  },

  showCorrectFeedback: function(message, instant){
    var fb = document.getElementById('sim-feedback');
    if(!fb) return;
    fb.className = 'sim-feedback sim-feedback-correct';
    fb.innerHTML =
      '<span class="sim-feedback-icon" aria-hidden="true">&#10003;</span>' +
      '<span class="sim-feedback-text">' + message + '</span>';
    fb.classList.remove('is-hidden');
    if(!instant) slideUpElement(fb, { duration: 400 });
  },

  showIncorrectFeedback: function(hint){
    var fb = document.getElementById('sim-feedback');
    if(!fb) return;
    fb.className = 'sim-feedback sim-feedback-incorrect';
    fb.innerHTML =
      '<span class="sim-feedback-icon" aria-hidden="true">&#10007;</span>' +
      '<span class="sim-feedback-text">' + hint + '</span>';
    fb.classList.remove('is-hidden');
    slideUpElement(fb, { duration: 350 });
  },

  enableNextStep: function(){
    var nextBtn = document.getElementById('sim-next-btn');
    if(nextBtn){
      nextBtn.classList.remove('is-hidden');
      nextBtn.disabled = false;
    }
    var ctrlNext = document.getElementById('sim-btn-next');
    if(ctrlNext) ctrlNext.disabled = false;
  },

  nextStep: function(){
    if(this.isResult) return;
    if(this.isAnimating) return;
    if(!this.completedSteps[this.currentStep]) return;

    this._introToken++;

    if(this.currentStep >= BaseSimulatorData.length - 1){
      this.showFinalResult();
      return;
    }

    this.resetCurrentStep();
    this.currentStep++;
    this.isAnswered = false;
    this.isCorrect = false;
    this.selectedChoice = null;

    this.renderStep(this.currentStep);
    this.playStepIntro(this.currentStep);
  },

  previousStep: function(){
    if(this.isAnimating) return;
    this._introToken++;
    this._setAnimating(false);
    if(this.isResult){
      this.isResult = false;
      var qPanel = document.getElementById('sim-question-panel');
      var rPanel = document.getElementById('sim-result-panel');
      if(qPanel) qPanel.classList.remove('is-hidden');
      if(rPanel) rPanel.classList.add('is-hidden');
      this.renderStep(BaseSimulatorData.length - 1);
      this._updateControlButtons();
      return;
    }
    if(this.currentStep <= 0) return;

    this.resetCurrentStep();
    this.currentStep--;
    this.renderStep(this.currentStep);
    this._updateControlButtons();
  },

  restartSimulator: function(){
    this._introToken++;
    this._setAnimating(false);
    this._stopQuestionAudio();
    var fly = document.getElementById('scene02-base-badge-fly');
    if(fly && fly.parentNode) fly.parentNode.removeChild(fly);
    this._flyBadge = null;

    var canvas = document.getElementById('motion-canvas');
    if(canvas) canvas.innerHTML = '';

    this.currentStep = 0;
    this.selectedChoice = null;
    this.completedSteps = [false, false, false];
    this.stepSnapshots = {};
    this.isAnswered = false;
    this.isCorrect = false;
    this.isAnimating = false;
    this.isResult = false;

    var qPanel = document.getElementById('sim-question-panel');
    var rPanel = document.getElementById('sim-result-panel');
    if(qPanel) qPanel.classList.remove('is-hidden');
    if(rPanel) rPanel.classList.add('is-hidden');

    this.renderStep(0);
    this.playStepIntro(0);
  },

  showFinalResult: function(){
    this.isResult = true;
    this._stopQuestionAudio();

    var qPanel = document.getElementById('sim-question-panel');
    var rPanel = document.getElementById('sim-result-panel');
    if(qPanel) qPanel.classList.add('is-hidden');
    if(rPanel) rPanel.classList.remove('is-hidden');

    this._mountFinalCanvas();
    this._updateProgressUI();
    this._updateControlButtons();
  },

  resetCurrentStep: function(){
    var fb = document.getElementById('sim-feedback');
    if(fb){
      fb.classList.add('is-hidden');
      fb.innerHTML = '';
    }
    var nextBtn = document.getElementById('sim-next-btn');
    if(nextBtn){
      nextBtn.classList.add('is-hidden');
      nextBtn.disabled = true;
    }
  },

  _highlightChoice: function(stepIndex, choiceIndex, state){
    var buttons = document.querySelectorAll('#sim-choices .sim-choice-btn');
    for(var i=0;i<buttons.length;i++){
      buttons[i].classList.remove('is-selected', 'is-wrong', 'is-correct-choice', 'is-locked');
      if(i === choiceIndex){
        buttons[i].classList.add('is-selected');
        if(state === 'incorrect') buttons[i].classList.add('is-wrong');
        if(state === 'correct') buttons[i].classList.add('is-correct-choice');
      }
    }
    if(state === 'correct'){
      for(var j=0;j<buttons.length;j++){
        buttons[j].classList.add('is-locked');
        buttons[j].disabled = true;
      }
    }
  },

  _restoreChoiceUI: function(stepIndex){
    var snap = this.stepSnapshots[stepIndex];
    if(!snap || snap.choiceIndex == null) return;
    this._highlightChoice(stepIndex, snap.choiceIndex, 'correct');
  },

  _updateProgressUI: function(){
    var total = BaseSimulatorData.length;
    var done = 0;
    for(var i=0;i<this.completedSteps.length;i++){
      if(this.completedSteps[i]) done++;
    }
    if(this.isResult) done = total;

    var pct = Math.round((done / total) * 100);
    var fill = document.getElementById('sim-progress-fill');
    var track = document.getElementById('sim-progress-track');
    var num = document.getElementById('sim-step-number');

    if(fill) fill.style.width = pct + '%';
    if(track){
      track.setAttribute('aria-valuenow', String(pct));
      track.setAttribute('aria-label', '진행률 ' + pct + '%');
    }
    if(num){
      num.textContent = this.isResult
        ? '완료'
        : (this.currentStep + 1) + ' / ' + total;
    }
  },

  _updateControlButtons: function(){
    var prev = document.getElementById('sim-btn-prev');
    var next = document.getElementById('sim-btn-next');
    var restart = document.getElementById('sim-btn-restart');
    var busy = this.isAnimating;

    if(prev) prev.disabled = busy || (!this.isResult && this.currentStep <= 0);
    if(restart) restart.disabled = busy;
    if(next){
      if(this.isResult || busy){
        next.disabled = true;
      } else {
        next.disabled = !this.completedSteps[this.currentStep];
      }
    }
  },

  /* ── Canvas mount helpers ── */
  _mountStageBg: function(canvas){
    var bg = document.createElement('div');
    bg.className = 'scene01-stage-bg scene-canvas-bg';
    canvas.appendChild(bg);
    ['bg-circle-1','bg-circle-2','bg-circle-3'].forEach(function(id){
      var c = document.createElement('div');
      c.className = 'scene-bg-circle scene-canvas-bg';
      c.id = id;
      canvas.appendChild(c);
    });
    var dots = document.createElement('div');
    dots.id = 'dot-pattern';
    dots.className = 'scene-canvas-bg';
    canvas.appendChild(dots);
  },

  _mountStepCanvas: function(index, completed){
    var canvas = document.getElementById('motion-canvas');
    if(!canvas) return;
    canvas.innerHTML = '';
    this._mountStageBg(canvas);

    if(index === 0){
      this._buildStep01Canvas(canvas, completed);
    } else if(index === 1){
      this._buildStep02Canvas(canvas, completed);
    } else if(index === 2){
      this._buildStep03Canvas(canvas, completed);
    }
  },

  _restoreCanvasState: function(index){
    this._mountStepCanvas(index, true);
  },

  _buildStep01Canvas: function(canvas, completed){
    var badge = document.createElement('div');
    badge.className = 'qualification-badge base-business scene-canvas-badge';
    badge.id = 'scene01-base-badge';
    badge.innerHTML = '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>';
    canvas.appendChild(badge);

    if(completed){
      showElement(badge);
      this._appendEqualsLabel(canvas);
      this._appendConsumerTransition(canvas);
      showElement('#sm-equals-label');
      showElement('#sm-consumer-transition');
    } else {
      badge.classList.add('is-hidden');
    }
  },

  _buildStep02Canvas: function(canvas, completed){
    var svgNS = 'http://www.w3.org/2000/svg';
    var connectors = document.createElementNS(svgNS, 'svg');
    connectors.setAttribute('id', 'lo-connectors');
    connectors.setAttribute('viewBox', '0 0 100 100');
    connectors.setAttribute('preserveAspectRatio', 'none');
    var canvasH = canvas.clientHeight || canvas.offsetHeight || 500;
    var y1Start = 48 - (20 / canvasH) * 100;
    var specs = [
      ['connector-left', 50, y1Start, 22, 68],
      ['connector-right', 50, y1Start, 78, 68]
    ];
    specs.forEach(function(s){
      var line = document.createElementNS(svgNS, 'line');
      line.setAttribute('id', s[0]);
      line.setAttribute('x1', s[1]);
      line.setAttribute('y1', s[2]);
      line.setAttribute('x2', s[3]);
      line.setAttribute('y2', s[4]);
      connectors.appendChild(line);
    });
    canvas.appendChild(connectors);

    var main = document.createElement('div');
    main.className = 'member-unit' + (completed ? '' : ' is-hidden');
    main.id = 'member-unit-main';
    main.innerHTML =
      '<div class="member-visual" id="member-visual-main">' +
        '<img class="member-image" id="member-image-main" src="' + (completed ? '<%=memberImg%>' : '<%=peopleImg%>') + '" alt="멤버"/>' +
        '<div class="member-emblems" id="member-emblems-main">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem' + (completed ? '' : ' is-hidden') + '" id="autoship-emblem-main">' +
              '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
            '</div>' +
            '<div class="qualification-badge base-business' + (completed ? '' : ' is-hidden') + '" id="base-business-badge-main">' +
              '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>' +
            '</div>' +
            '<div class="rank-medal' + (completed ? '' : ' is-hidden') + '" id="rank-medal-main">' +
              '<img src="<%=lev01Img%>" alt="D 지위"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
      '</div>';
    canvas.appendChild(main);

    var left = document.createElement('div');
    left.className = 'member-unit member-child' + (completed ? '' : ' is-hidden');
    left.id = 'member-unit-left';
    left.innerHTML =
      '<div class="member-visual" id="member-visual-left">' +
        '<img class="member-image" id="member-image-left" src="<%=memberImg%>" alt="멤버"/>' +
        '<div class="member-emblems" id="member-emblems-left">' +
          '<div class="condition-emblem autoship-emblem' + (completed ? '' : ' is-hidden') + '" id="autoship-emblem-left">' +
            '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
          '</div>' +
        '</div>' +
      '</div>';
    canvas.appendChild(left);

    var right = document.createElement('div');
    right.className = 'member-unit member-child' + (completed ? '' : ' is-hidden');
    right.id = 'member-unit-right';
    right.innerHTML =
      '<div class="member-visual" id="member-visual-right">' +
        '<img class="member-image" id="member-image-right" src="<%=memberImg%>" alt="멤버"/>' +
        '<div class="member-emblems" id="member-emblems-right">' +
          '<div class="condition-emblem autoship-emblem' + (completed ? '' : ' is-hidden') + '" id="autoship-emblem-right">' +
            '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
          '</div>' +
        '</div>' +
      '</div>';
    canvas.appendChild(right);

    if(completed){
      var cl = document.getElementById('connector-left');
      var cr = document.getElementById('connector-right');
      if(cl) cl.classList.add('is-visible');
      if(cr) cr.classList.add('is-visible');
      showElement('#member-unit-main');
      showElement('#member-unit-left');
      showElement('#member-unit-right');
      showElement('#autoship-emblem-main');
      showElement('#base-business-badge-main');
      showElement('#rank-medal-main');
      showElement('#autoship-emblem-left');
      showElement('#autoship-emblem-right');
      var img = document.getElementById('member-image-main');
      if(img){
        img.src = '<%=memberImg%>';
        img.alt = 'BASE사업자';
      }
      this._startFloatMain();
    }
  },

  _buildStep03Canvas: function(canvas, completed){
    var main = document.createElement('div');
    main.className = 'member-unit' + (completed ? '' : ' is-hidden');
    main.id = 'member-unit-main';
    var hid = completed ? '' : ' is-hidden';
    main.innerHTML =
      '<div class="member-visual" id="member-visual-main">' +
        '<img class="member-image" id="member-image-main" src="<%=memberImg%>" alt="BASE사업자"/>' +
        '<div class="member-emblems" id="member-emblems-main">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem' + hid + '" id="autoship-emblem-main">' +
              '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
            '</div>' +
            '<div class="qualification-badge base-business' + hid + '" id="base-business-badge-main">' +
              '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>' +
            '</div>' +
            '<div class="rank-medal' + hid + '" id="rank-medal-main">' +
              '<img src="<%=lev01Img%>" alt="D 지위"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
      '</div>';
    canvas.appendChild(main);

    if(completed){
      this._appendConsumerTransition(canvas);
      showElement('#member-unit-main');
      showElement('#autoship-emblem-main');
      showElement('#base-business-badge-main');
      showElement('#rank-medal-main');
      showElement('#sm-consumer-transition');
    }
  },

  _mountFinalCanvas: function(){
    var canvas = document.getElementById('motion-canvas');
    if(!canvas) return;
    canvas.innerHTML = '';
    this._mountStageBg(canvas);

    var main = document.createElement('div');
    main.className = 'member-unit';
    main.id = 'member-unit-main';
    main.innerHTML =
      '<div class="member-visual" id="member-visual-main">' +
        '<img class="member-image" id="member-image-main" src="<%=memberImg%>" alt="BASE사업자"/>' +
        '<div class="member-emblems" id="member-emblems-main">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem" id="autoship-emblem-main">' +
              '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
            '</div>' +
            '<div class="qualification-badge base-business" id="base-business-badge-main">' +
              '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>' +
            '</div>' +
            '<div class="rank-medal" id="rank-medal-main">' +
              '<img src="<%=lev01Img%>" alt="D 지위"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
      '</div>';
    canvas.appendChild(main);

    this._appendEqualsLabel(canvas);
    this._appendConsumerTransition(canvas);
    showElement('#sm-equals-label');
    showElement('#sm-consumer-transition');
    showElement('#member-unit-main');
  },

  _appendEqualsLabel: function(canvas){
    if(document.getElementById('sm-equals-label')) return;
    var el = document.createElement('div');
    el.id = 'sm-equals-label';
    el.className = 'scene-canvas-html-label is-hidden';
    el.innerHTML =
      '<span class="equals-sign">=</span>' +
      '<span class="label-text">권리 소득 자격</span>';
    canvas.appendChild(el);
  },

  _appendConsumerTransition: function(canvas){
    if(document.getElementById('sm-consumer-transition')) return;
    var el = document.createElement('div');
    el.id = 'sm-consumer-transition';
    el.className = 'scene-canvas-html-label is-hidden';
    el.innerHTML =
      '<span class="label-consumer">소비자</span>' +
      '<span class="label-arrow" aria-hidden="true">→</span>' +
      '<span class="label-business">사업자</span>';
    canvas.appendChild(el);
  },

  /* ── Step intros ── */
  _introStep01: async function(){
    var badge = document.getElementById('scene01-base-badge');
    if(!badge) return;
    await softAcquireElement(badge, { duration: 900, glow: true, hero: true });
    badge.classList.add('motion-idle-float');
  },

  _introStep02: async function(){
    await enterMember('member-unit-main', { duration: 700 });
    showElement('#member-unit-main');
    await wait(400);
    await this._replaceMainToMember();
    await this._animTimeout(softAcquireElement('#rank-medal-main', { duration: 700, glow: true }), 3000);
    await wait(500);
    await this._animTimeout(softAcquireElement('#autoship-emblem-main', { duration: 700, glow: true }), 3000);
    this._startFloatMain();
  },

  _introStep03: async function(){
    showElement('#member-unit-main');
    await enterMember('member-unit-main', { duration: 650 });
    await wait(300);
    await softAcquireElement('#autoship-emblem-main', { duration: 600, glow: true });
    await wait(350);
    await softAcquireElement('#rank-medal-main', { duration: 600, glow: true });
    await wait(350);
    await softAcquireElement('#base-business-badge-main', { duration: 600, glow: true });
  },

  /* ── Correct answer animations ── */
  _correctStep01: async function(){
    var badge = document.getElementById('scene01-base-badge');
    if(badge){
      badge.classList.remove('motion-idle-float');
      var img = badge.querySelector('img');
      if(img){
        img.style.animation = 'kf-glow-once 800ms ease forwards';
        await wait(800);
        img.style.animation = '';
      }
    }
    var canvas = document.getElementById('motion-canvas');
    if(canvas){
      this._appendEqualsLabel(canvas);
      this._appendConsumerTransition(canvas);
    }
    showElement('#sm-equals-label');
    await slideUpElement('#sm-equals-label', { duration: 500 });
    await wait(400);
    await enterElement('#sm-consumer-transition', { duration: 550 });
  },

  _correctStep02: async function(){
    await Promise.all([
      enterMember('member-unit-left', { duration: 650 }),
      this._showConnector('connector-left')
    ]);
    await wait(600);
    await Promise.all([
      enterMember('member-unit-right', { duration: 650 }),
      this._showConnector('connector-right')
    ]);
    await wait(500);
    await this._acquireChildAutoship('autoship-emblem-left');
    await wait(700);
    await this._acquireChildAutoship('autoship-emblem-right');
    await wait(500);

    var canvas = document.getElementById('motion-canvas');
    if(!canvas) return;

    var flyBadge = document.createElement('div');
    flyBadge.className = 'qualification-badge base-business scene-canvas-badge is-hidden';
    flyBadge.id = 'scene02-base-badge-fly';
    flyBadge.innerHTML = '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>';
    canvas.appendChild(flyBadge);
    this._flyBadge = flyBadge;

    showElement(flyBadge);
    flyBadge.style.position = 'absolute';
    flyBadge.style.left = '50%';
    flyBadge.style.top = '50%';
    flyBadge.style.margin = '0';
    flyBadge.style.transform = 'translate(-50%,-50%)';
    flyBadge.style.zIndex = '10';

    var flyImg = flyBadge.querySelector('img');
    if(flyImg) await this._animTimeout(softAcquireElement(flyImg, { duration: 900, glow: true, hero: true }), 4000);
    else await this._animTimeout(softAcquireElement(flyBadge, { duration: 900, glow: true, hero: true }), 4000);

    await wait(250);
    await this._attachFlyBadge(flyBadge);
  },

  _correctStep03: async function(){
    var canvas = document.getElementById('motion-canvas');
    if(canvas) this._appendConsumerTransition(canvas);
    await enterElement('#sm-consumer-transition', { duration: 550 });
    await wait(400);
    var biz = document.querySelector('#sm-consumer-transition .label-business');
    if(biz){
      biz.style.animation = 'kf-highlight-pulse 700ms ease forwards';
      await wait(700);
      biz.style.animation = '';
    }
    var badge = document.getElementById('base-business-badge-main');
    if(badge){
      badge.style.animation = 'kf-highlight-pulse 700ms ease forwards';
      await wait(700);
      badge.style.animation = '';
    }
  },

  _hintStep02: async function(){
    var rank = document.getElementById('rank-medal-main');
    var base = document.getElementById('base-business-badge-main');
    if(rank){
      rank.style.animation = 'kf-highlight-pulse 600ms ease forwards';
      await wait(600);
      rank.style.animation = '';
    }
    if(base){
      base.style.animation = 'kf-highlight-pulse 600ms ease forwards';
      await wait(600);
      base.style.animation = '';
    }
  },

  /* ── Scene02-style helpers (simulator-local) ── */
  _replaceMainToMember: function(){
    var img = document.getElementById('member-image-main');
    if(!img) return Promise.resolve();
    return new Promise(function(resolve){
      img.style.transition = 'opacity 700ms var(--ease-smooth), transform 700ms var(--ease-smooth)';
      img.style.transform = 'scale(0.95)';
      img.style.opacity = '0';
      setTimeout(function(){
        img.src = '<%=memberImg%>';
        img.alt = 'BASE사업자';
        void img.offsetWidth;
        img.style.transform = 'scale(1)';
        img.style.opacity = '1';
        setTimeout(function(){
          img.style.transition = '';
          img.style.transform = '';
          resolve();
        }, 700);
      }, 700);
    });
  },

  _acquireChildAutoship: async function(emblemId){
    var el = document.getElementById(emblemId);
    if(!el) return;
    el.classList.remove('is-hidden');
    el.style.left = '50%';
    el.style.transform = 'translateX(-50%)';
    el.style.transition = 'none';
    var img = el.querySelector('img');
    if(img){
      _clearAnim(img);
      img.style.animationDuration = '650ms';
      img.classList.add('motion-soft-acquire');
      await this._onAnimEnd(img, 2000);
      img.classList.remove('motion-soft-acquire');
      img.style.animationDuration = '';
    }
    el.style.transition = 'left 900ms var(--ease-smooth)';
    await wait(40);
    el.style.left = '30%';
    await wait(900);
    el.style.transition = '';
  },

  _attachFlyBadge: async function(flyBadge){
    var canvas = document.getElementById('motion-canvas');
    var mainBadge = document.getElementById('base-business-badge-main');
    if(!canvas || !flyBadge || !mainBadge) return;

    var canvasRect = canvas.getBoundingClientRect();
    var centerX = canvasRect.width / 2;
    var centerY = canvasRect.height / 2;

    mainBadge.classList.remove('is-hidden');
    mainBadge.style.visibility = 'hidden';
    var targetRect = mainBadge.getBoundingClientRect();
    mainBadge.style.visibility = '';
    mainBadge.classList.add('is-hidden');

    var endX = targetRect.left + targetRect.width / 2 - canvasRect.left;
    var endY = targetRect.top + targetRect.height / 2 - canvasRect.top;
    var flyRect = flyBadge.getBoundingClientRect();
    var targetScale = targetRect.width / Math.max(flyRect.width, 1);
    var flyDur = 1600;

    flyBadge.style.transition = 'left ' + flyDur + 'ms var(--ease-smooth), top ' + flyDur + 'ms var(--ease-smooth), transform ' + flyDur + 'ms var(--ease-smooth)';
    await wait(50);
    flyBadge.style.left = endX + 'px';
    flyBadge.style.top = endY + 'px';
    flyBadge.style.transform = 'translate(-50%,-50%) scale(' + targetScale + ')';
    await wait(flyDur);

    flyBadge.style.transition = 'opacity 400ms var(--ease-smooth)';
    flyBadge.style.opacity = '0';
    await wait(400);
    if(flyBadge.parentNode) flyBadge.parentNode.removeChild(flyBadge);
    this._flyBadge = null;

    showElement(mainBadge);
    await this._animTimeout(softAcquireElement(mainBadge, { duration: 450, glow: true }), 3000);
    this._startFloatMain();
  },

  _showConnector: function(id){
    var line = document.getElementById(id);
    if(!line) return Promise.resolve();
    return new Promise(function(resolve){
      line.classList.remove('is-visible');
      void line.getBoundingClientRect();
      line.classList.add('is-visible');
      setTimeout(resolve, 850);
    });
  }
};
</script>
