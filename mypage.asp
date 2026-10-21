<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>마이페이지 - ALTWELL SMART GUIDE</title>
<!--#include file="includes/fonts.asp"-->
<!--#include file="includes/main_css.asp"-->
<link rel="stylesheet" href="_css/mypage.css?v=20261020mp18b"/>
</head>
<body class="d2 page-list mp-page">
<nav id="nav">
  <button type="button" class="nav-logo" onclick="location.href='index.asp'" aria-label="홈으로">ALTWELL<span> SMART GUIDE</span></button>
  <span id="nav-page-title">마이페이지</span>
  <div class="nav-spacer"></div>
</nav>
<div class="list-page" id="mypage">
  <div class="list-wrap">
    <div class="lp-head">
      <div class="lp-title">마이페이지</div>
      <div class="lp-desc">가이드 영상과 시뮬레이션의 씬별 학습 상태를 확인합니다.</div>
    </div>
    <div class="mp-cats" role="tablist" aria-label="카테고리">
      <button type="button" class="mp-cat on" role="tab" aria-selected="true" data-cat="guide">가이드 영상</button>
      <button type="button" class="mp-cat" role="tab" aria-selected="false" data-cat="sim">시뮬레이션</button>
    </div>
    <div id="mp-list"></div>
  </div>
</div>
<script>
(function(){
  var DATA = {
    guide: [
      {
        title: '오토십 알아보기',
        href: 'guide01_smartguide.asp?from=guide',
        tone: 'tone-a',
        doneLabel: '학습 완료',
        scenes: [
          { title: '오토십이란?', done: true },
          { title: '오토십의 장점', done: true },
          { title: '어떻게 구독하나요?', done: true },
          { title: '결제와 배송', done: true },
          { title: 'E.P와 추천포인트 발생', done: true },
          { title: '구독 중 추가·변경·해지', done: true },
          { title: '오토십, 이것만 기억하세요', done: true }
        ]
      },
      {
        title: '스타트팩 알아보기',
        href: 'guide02_smartguide.asp?from=guide',
        tone: 'tone-b',
        doneLabel: '학습 완료',
        scenes: [
          { title: '스타트팩이란?', done: true },
          { title: '누가, 언제 구매할 수 있나요?', done: true },
          { title: '스타트팩은 두 종류 입니다.', done: true },
          { title: '스타트팩의 가장 큰 혜택', done: true },
          { title: '추천인에게는 어떤 혜택이 있나요?', done: false },
          { title: '스타트팩과 초기 승급', done: false },
          { title: '왜 스타트팩을 운영할까요?', done: false },
          { title: '스타트팩 핵심 내용', done: false }
        ]
      },
      {
        title: 'BASE사업자 이해하기',
        href: 'guide03_smartguide.asp?from=guide',
        tone: 'tone-c',
        doneLabel: '학습 완료',
        scenes: [
          { title: 'BASE사업자란?', done: false },
          { title: 'BASE사업자의 기본 구성', done: false },
          { title: 'BASE사업자 본인 조건', done: false },
          { title: '파트너 2명의 조건', done: false },
          { title: '오토십으로 BASE사업자 만들기', done: false },
          { title: 'S.E.P실적으로 BASE사업자 만들기', done: false },
          { title: '파트너 실적에서 꼭 기억할 점', done: false },
          { title: 'BASE사업자 자격과 보상', done: false },
          { title: 'BASE사업자를 늘려야 하는 이유', done: false },
          { title: 'BASE 사업자 핵심 내용', done: false }
        ]
      }
    ],
    sim: [
      {
        title: '오토십 알아보기',
        href: 'guide01_simulator.asp',
        tone: 'tone-a',
        doneLabel: '복습 완료',
        scenes: [
          { title: '오토십이란?', done: false },
          { title: '오토십의 장점', done: false },
          { title: '어떻게 구독하나요?', done: false },
          { title: '결제와 배송', done: false },
          { title: 'E.P와 추천포인트 발생', done: false },
          { title: '구독 중 추가·변경·해지', done: false },
          { title: '오토십, 이것만 기억하세요', done: false }
        ]
      },
      {
        title: '스타트팩 알아보기',
        href: 'guide02_simulator.asp',
        tone: 'tone-b',
        doneLabel: '복습 완료',
        scenes: [
          { title: '스타트팩이란?', done: false },
          { title: '누가, 언제 구매할 수 있나요?', done: false },
          { title: '스타트팩은 두 종류 입니다.', done: false },
          { title: '스타트팩의 가장 큰 혜택', done: false },
          { title: '추천인에게는 어떤 혜택이 있나요?', done: false },
          { title: '스타트팩과 초기 승급', done: false },
          { title: '왜 스타트팩을 운영할까요?', done: false },
          { title: '스타트팩 핵심 내용', done: false }
        ]
      },
      {
        title: 'BASE사업자 이해하기',
        href: '01_base_business_simulator.asp',
        tone: 'tone-s',
        doneLabel: '복습 완료',
        scenes: [
          { title: 'BASE사업자는 지위가 아닌 권리 자격', done: false },
          { title: '혜택을 공유하고 오토십 이용자 2명을 확보', done: false },
          { title: '소비자에서 권리 소득을 만드는 사업자로 전환', done: false }
        ]
      }
    ]
  };

  function countDone(scenes){
    var n = 0;
    var i;
    for(i = 0; i < scenes.length; i++) if(scenes[i].done) n++;
    return n;
  }

  function sceneHref(lesson, index){
    var join = lesson.href.indexOf('?') >= 0 ? '&' : '?';
    return lesson.href + join + 'scene=' + (index + 1);
  }

  function renderLesson(lesson){
    var section = document.createElement('section');
    var head = document.createElement('div');
    var title = document.createElement('h2');
    var count = document.createElement('span');
    var row = document.createElement('div');
    var done = countDone(lesson.scenes);
    var total = lesson.scenes.length;
    var i;
    var scene;
    var card;
    var thumb;
    var cover;
    var stamp;
    var name;

    section.className = 'mp-lesson';
    head.className = 'mp-lesson-head';
    title.className = 'mp-lesson-title';
    title.textContent = lesson.title;
    if(done === total && total > 0){
      count.className = 'mp-badge';
      count.textContent = lesson.doneLabel + ' ' + done + '/' + total;
    }else{
      count.className = 'mp-count';
      count.textContent = done + '/' + total;
    }
    head.appendChild(title);
    head.appendChild(count);

    row.className = 'mp-row';
    for(i = 0; i < lesson.scenes.length; i++){
      scene = lesson.scenes[i];
      card = document.createElement('button');
      card.type = 'button';
      card.className = 'mp-card';
      card.setAttribute('data-href', sceneHref(lesson, i));
      card.addEventListener('click', function(){
        location.href = this.getAttribute('data-href');
      });
      thumb = document.createElement('div');
      thumb.className = 'mp-thumb ' + lesson.tone;
      if(scene.done){
        cover = document.createElement('span');
        cover.className = 'mp-cover';
        stamp = document.createElement('span');
        stamp.className = 'mp-stamp';
        lesson.doneLabel.split(' ').forEach(function(part){
          var line = document.createElement('span');
          line.textContent = part;
          stamp.appendChild(line);
        });
        cover.appendChild(stamp);
        thumb.appendChild(cover);
      }
      name = document.createElement('div');
      name.className = 'mp-scene-title';
      name.textContent = (i + 1) + '. ' + scene.title;
      card.appendChild(thumb);
      card.appendChild(name);
      row.appendChild(card);
    }

    section.appendChild(head);
    section.appendChild(row);
    return section;
  }

  function render(cat){
    var host = document.getElementById('mp-list');
    var list = DATA[cat] || [];
    var i;
    host.innerHTML = '';
    for(i = 0; i < list.length; i++) host.appendChild(renderLesson(list[i]));
  }

  document.querySelectorAll('.mp-cat').forEach(function(btn){
    btn.addEventListener('click', function(){
      document.querySelectorAll('.mp-cat').forEach(function(el){
        el.classList.remove('on');
        el.setAttribute('aria-selected', 'false');
      });
      btn.classList.add('on');
      btn.setAttribute('aria-selected', 'true');
      render(btn.getAttribute('data-cat'));
    });
  });

  render('guide');
})();
</script>
</body>
</html>
