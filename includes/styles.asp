/* ALTWELL SMART GUIDE — player · motion · simulator (styles.asp) */

/* ??????????????????????????????
   DEPTH-3: PLAYER OVERLAY
?????????????????????????????? */
#overlay{
  position:fixed;inset:0;z-index:200;
  background:#0C1016;
  display:none;flex-direction:column;
}
#overlay.on{display:flex}
#ov-bar{
  height:48px;background:rgba(0,0,0,.55);backdrop-filter:blur(10px);
  border-bottom:1px solid rgba(255,255,255,.1);
  display:flex;align-items:center;padding:0 14px;gap:11px;flex-shrink:0;
}
#ov-back{
  width:32px;height:32px;border-radius:50%;
  background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.18);
  color:#cbd5e1;font-size:15px;
  display:flex;align-items:center;justify-content:center;
  cursor:pointer;transition:background .14s;flex-shrink:0;
}
#ov-back:hover{background:rgba(255,255,255,.2)}
#ov-breadcrumb{font-size:15px;color:#475569;flex-shrink:0}
#ov-sep{font-size:14px;color:#334155;flex-shrink:0}
#ov-title{font-size:16px;font-weight:700;color:#e2e8f0;flex:1}
#ov-dot{width:6px;height:6px;border-radius:50%;background:var(--red);flex-shrink:0;animation:pdot 2s ease-in-out infinite}
#ov-type{font-size:14px;color:#475569;flex-shrink:0}
@keyframes pdot{0%,100%{opacity:1}50%{opacity:.25}}

/* ── PLAYER INTERNALS ── */
#player-wrap{flex:1;display:flex;flex-direction:column;min-height:0;overflow:hidden}
#main-area{display:flex;flex:1;overflow:hidden;min-height:0}
#stage-wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:16px;min-width:0}
#stage{
  position:relative;width:100%;max-width:920px;
  background:radial-gradient(ellipse at 50% 38%,#19243a 0%,#0C1016 68%);
  border-radius:14px;border:1px solid rgba(255,255,255,.1);overflow:visible;
}
#stage::before{content:'';display:block;padding-bottom:56.25%}
#si{position:absolute;inset:0;overflow:visible}
#svgl{position:absolute;inset:0;width:100%;height:100%;pointer-events:none;overflow:visible}
.gl{stroke-dasharray:300;stroke-dashoffset:300;transition:stroke-dashoffset 1s ease,stroke .4s,filter .4s}
.gl.on{stroke-dashoffset:0}
.gl.glow{stroke:#93C5FD;filter:drop-shadow(0 0 4px rgba(147,197,253,.85))}

#hero-s{
  position:absolute;inset:0;z-index:20;
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  opacity:0;transform:scale(.65);transition:opacity .7s,transform .7s;
  pointer-events:none;text-align:center;padding:20px;
}
#hero-s.show{opacity:1;transform:scale(1)}
.h-main{font-size:clamp(18px,3.4vw,36px);font-weight:900;letter-spacing:-.02em;color:#F8FAFC;text-shadow:0 2px 24px rgba(0,0,0,.7);line-height:1.25}
.h-sub{font-size:clamp(13px,1.5vw,17px);color:#94A3B8;margin-top:10px}

.mn{position:absolute;transform:translate(-50%,-50%);opacity:0;transition:opacity .5s;pointer-events:none}
.mn.show{opacity:1}
.mb{position:relative}
.mb.lg{width:clamp(52px,8.5%,84px)}
.mb.md{width:clamp(40px,6.5%,64px)}
.mb.sm{width:clamp(28px,4.5%,44px)}
.mi-wrap{position:relative;width:100%;padding-bottom:100%}
.mi{position:absolute;inset:0;width:100%;height:100%;object-fit:contain;transition:opacity .8s}
.mi.gray{opacity:1}.mi.blue{opacity:0}
.mi-wrap.blue .mi.gray{opacity:0}.mi-wrap.blue .mi.blue{opacity:1}

.m-medal,.m-biz{position:absolute;left:50%;opacity:0;transform:translateX(-50%) scale(.3);transition:opacity .45s,transform .45s;pointer-events:none}
.m-medal{top:-44%;width:54%}.m-medal.show{opacity:1;transform:translateX(-50%) scale(1)}
.m-biz{top:-56%;width:74%}.m-biz.show{opacity:1;transform:translateX(-50%) scale(1)}
.m-as{position:absolute;right:-28%;top:-28%;width:50%;opacity:0;transform:scale(.3);transition:opacity .4s,transform .4s;pointer-events:none}
.m-as.show{opacity:1;transform:scale(1)}
.m-as.glow{filter:drop-shadow(0 0 5px rgba(96,165,250,.9));animation:bglow 1.8s ease-in-out infinite}
.m-sep{
  position:absolute;left:-36%;top:-28%;
  background:linear-gradient(135deg,#f97316,#dc2626);color:#fff;
  font-size:9px;font-weight:900;padding:3px 4px;border-radius:5px;text-align:center;line-height:1.25;
  border:1px solid rgba(255,255,255,.35);box-shadow:0 2px 8px rgba(220,38,38,.5);
  opacity:0;transform:scale(.3);transition:opacity .4s,transform .4s;white-space:nowrap;pointer-events:none;
}
.m-sep.show{opacity:1;transform:scale(1)}.m-sep.glow{animation:bglow 1.8s ease-in-out infinite}
.m-chk{
  position:absolute;right:-14%;top:-14%;
  background:#16A34A;color:#fff;border-radius:50%;width:28%;aspect-ratio:1;
  display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:900;
  border:1.5px solid rgba(255,255,255,.6);box-shadow:0 2px 8px rgba(22,163,74,.65);
  opacity:0;transform:scale(.2);transition:opacity .3s,transform .35s;pointer-events:none;
}
.m-chk.show{opacity:1;transform:scale(1)}
.m-ring{position:absolute;inset:-20%;border-radius:50%;border:2px solid #60A5FA;opacity:0;transition:opacity .5s;pointer-events:none}
.m-ring.show{opacity:1;animation:rpulse 2s ease-in-out infinite}
@keyframes rpulse{0%,100%{box-shadow:0 0 8px rgba(96,165,250,.25)}50%{box-shadow:0 0 22px rgba(96,165,250,.65)}}
.m-plate{
  text-align:center;margin-top:5px;
  background:rgba(255,255,255,.1);backdrop-filter:blur(4px);
  border:1px solid rgba(255,255,255,.2);border-radius:20px;
  padding:4px 12px;font-size:13px;font-weight:700;color:#E2E8F0;
  opacity:0;transform:translateY(5px);transition:opacity .4s,transform .4s;white-space:nowrap;
}
.m-plate.show{opacity:1;transform:translateY(0)}
@keyframes bglow{0%,100%{filter:drop-shadow(0 0 3px currentColor)}50%{filter:drop-shadow(0 0 9px currentColor)}}

#bpw{position:absolute;left:50%;bottom:3%;transform:translateX(-50%);opacity:0;transition:opacity .6s;pointer-events:none}
#bpw.show{opacity:1}
#bpi{position:relative;width:clamp(130px,25%,210px)}
#bpi img{width:100%;display:block}
.bp-tx{position:absolute;top:50%;right:5%;transform:translateY(-50%);text-align:center;width:56%}
.bp-t1{font-size:clamp(9px,1.05vw,13px);font-weight:700;color:#1e293b;letter-spacing:.04em;line-height:1.3}
.bp-t2{font-size:clamp(11px,1.25vw,15px);font-weight:900;color:#dc2626;margin-top:2px;display:none}

.bcoin{
  position:absolute;z-index:30;pointer-events:none;
  width:24px;height:24px;border-radius:50%;
  background:radial-gradient(circle at 35% 35%,#FDE68A,#F59E0B 55%,#D97706);
  border:1.5px solid #FBBF24;box-shadow:0 2px 10px rgba(245,158,11,.7);
  display:flex;align-items:center;justify-content:center;font-size:10px;font-weight:900;color:#78350F;
}

#warn{
  position:absolute;left:50%;top:50%;transform:translate(-50%,-52%);
  background:rgba(239,68,68,.13);backdrop-filter:blur(10px);
  border:1.5px solid rgba(239,68,68,.42);border-radius:14px;
  padding:14px 18px;text-align:center;z-index:25;max-width:240px;
  opacity:0;transition:opacity .5s;pointer-events:none;
}
#warn.show{opacity:1}
.w-ico{font-size:24px;margin-bottom:8px}
.w-ttl{font-size:16px;font-weight:900;color:#FCA5A5;margin-bottom:6px}
.w-txt{font-size:14px;color:#FCA5A5;line-height:1.8}

.sc{
  position:absolute;left:50%;
  background:rgba(255,255,255,.07);backdrop-filter:blur(8px);
  border:1px solid rgba(255,255,255,.16);border-radius:40px;
  padding:6px 16px;font-weight:700;color:#F1F5F9;
  white-space:nowrap;pointer-events:none;
  opacity:0;transition:opacity .4s,transform .4s;
  transform:translateX(-50%) translateY(8px);
  font-size:clamp(11px,1.3vw,15px);
}
.sc.show{opacity:1;transform:translateX(-50%) translateY(0)}
#sc1{bottom:12%}#sc2{bottom:22%}#sc3{bottom:33%}

#ending{
  position:absolute;inset:0;z-index:40;
  background:rgba(12,16,22,.87);backdrop-filter:blur(10px);
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  padding:24px;text-align:center;
  opacity:0;transition:opacity .9s;pointer-events:none;
}
#ending.show{opacity:1;pointer-events:auto}
.e-msg{font-size:clamp(16px,2vw,22px);font-weight:700;color:#E2E8F0;line-height:1.9;margin-bottom:26px}
.e-msg .hl{color:var(--red)}
#cta-row{display:flex;gap:10px;flex-wrap:wrap;justify-content:center;opacity:0;transition:opacity .5s}
#cta-row.show{opacity:1}
.ecta{padding:13px 26px;border-radius:40px;font-size:16px;font-weight:700;cursor:pointer;transition:all .2s;border:none}
.ecta.p{background:var(--red);color:#fff}.ecta.p:hover{background:#c82020}
.ecta.s{background:rgba(255,255,255,.1);color:#CBD5E1;border:1px solid rgba(255,255,255,.2)}.ecta.s:hover{background:rgba(255,255,255,.18)}

#info-panel{
  width:264px;flex-shrink:0;display:flex;align-items:center;justify-content:center;
  padding:14px;border-left:1px solid rgba(255,255,255,.09);background:rgba(0,0,0,.2);
}
#icard{
  width:100%;background:rgba(22,30,45,.96);border:1px solid rgba(255,255,255,.1);
  border-radius:13px;padding:16px;
  opacity:0;transform:translateY(6px);transition:opacity .35s,transform .35s;display:none;
}
#icard.show{opacity:1;transform:translateY(0);display:block}
.ic-lbl{font-size:13px;font-weight:700;letter-spacing:.1em;color:var(--red);margin-bottom:10px;text-transform:uppercase}
.ic-line{font-size:15px;color:#CBD5E1;line-height:1.8;margin-bottom:2px}
.ic-line.b{font-weight:700;color:#F1F5F9;font-size:16px}

#ctrl{
  height:58px;background:rgba(0,0,0,.68);backdrop-filter:blur(10px);
  border-top:1px solid rgba(255,255,255,.1);flex-shrink:0;
  display:flex;flex-direction:column;justify-content:center;padding:0 16px;gap:7px;
}
#tl{height:4px;background:rgba(255,255,255,.12);border-radius:99px;position:relative;cursor:pointer;transition:height .12s}
#tl:hover{height:6px}
#tlf{height:100%;background:var(--red);border-radius:99px;width:0%;transition:width .1s linear}
#tlt{
  position:absolute;top:50%;transform:translate(-50%,-50%);
  width:11px;height:11px;background:#fff;border-radius:50%;
  box-shadow:0 0 5px rgba(0,0,0,.5);left:0%;pointer-events:none;
}
#cr{display:flex;align-items:center;gap:10px}
.cb{
  width:30px;height:30px;border-radius:50%;
  background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.2);
  color:#CBD5E1;font-size:12px;
  display:flex;align-items:center;justify-content:center;transition:background .15s;
}
.cb:hover{background:rgba(255,255,255,.2)}
#tdsp{font-size:15px;color:#94A3B8;font-variant-numeric:tabular-nums}
#slbl{font-size:14px;color:#475569;flex:1;text-align:right;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}

@media(max-width:700px){#info-panel{display:none}#stage-wrap{padding:8px}}

/* ??????????????????????????????
   LAYOUT PREVIEW OVERLAY
   (ALTWELL MOTION DESIGN BIBLE v1.0)
?????????????????????????????? */
#layout-ov{
  position:fixed;inset:0;z-index:200;
  display:none;flex-direction:column;
  background:#e8f4fb;
}
#layout-ov:not(.layout-simulator){--lo-chrome-h:calc(var(--lo-bar-h) + var(--lo-ctrl-h))}
#layout-ov.layout-simulator{--lo-chrome-h:calc(var(--lo-bar-h) + var(--sim-ctrl-h))}
#layout-ov.on{display:flex}

/* ── 메인: 모션 영역 + 텍스트 영역 (분리, 겹침 없음) ── */
#lo-main{
  flex:1;display:flex;flex-direction:row;align-items:stretch;
  min-height:0;overflow:hidden;
  background:linear-gradient(160deg,#dceef8 0%,#c8e4f4 100%);
}

/* 모션 슬롯 — 레이아웃만, 콘텐츠 클리핑 없음 */
.lo-motion-zone{
  flex:0 0 auto;
  display:flex;align-items:center;justify-content:center;
  min-height:0;height:100%;
  max-width:calc(100% - var(--lo-panel-min));
  background:linear-gradient(160deg,#c8e8f8 0%,#b0d8f0 100%);
}

/* 4:3 프레임 — 비율·크기만 담당 (영상 콘텐츠와 분리) */
.lo-stage-frame{
  position:relative;
  flex-shrink:0;
  aspect-ratio:var(--lo-stage-ratio);
  height:100%;
  width:auto;
  max-height:100%;
  max-width:100%;
  background:linear-gradient(160deg,#c8e8f8 0%,#b0d8f0 100%);
  box-shadow:inset 0 0 0 1px rgba(255,255,255,.35);
}

/* 캔버스 — 프레임 내부 100% (모션 콘텐츠 주입면) */
#lo-canvas{
  position:absolute;inset:0;
  width:100%;height:100%;
  overflow:hidden;
}

#motion-canvas{
  position:absolute;inset:0;z-index:1;
  width:100%;height:100%;
  overflow:hidden;
}
/* 고정 스테이지 배경 — 씬 전환 시에도 유지 (#motion-canvas 밖) */
#motion-stage-bg{
  position:absolute;inset:0;z-index:0;pointer-events:none;
}
#motion-stage-bg .scene-bg-circle{z-index:1}
/* 배경 데코 서클 */
.scene-bg-circle{position:absolute;border-radius:50%;pointer-events:none}
#bg-circle-1{
  width:62%;aspect-ratio:1;
  background:radial-gradient(circle,rgba(255,255,255,.4) 0%,transparent 65%);
  top:-20%;left:-12%;
}
#bg-circle-2{
  width:50%;aspect-ratio:1;
  background:radial-gradient(circle,rgba(255,255,255,.25) 0%,transparent 65%);
  bottom:-25%;right:-10%;
}
#bg-circle-3{
  width:32%;aspect-ratio:1;
  background:radial-gradient(circle,rgba(150,210,255,.3) 0%,transparent 65%);
  top:8%;right:15%;
}
/* 도트 패턴 */
#dot-pattern{
  position:absolute;inset:0;pointer-events:none;
  background-image:radial-gradient(circle,rgba(255,255,255,.3) 1px,transparent 1px);
  background-size:28px 28px;
}
/* SVG 관계 연결선 */
#lo-connectors{
  position:absolute;inset:0;width:100%;height:100%;
  pointer-events:none;overflow:visible;
}
#connector-left,#connector-right{
  stroke:rgba(30,90,180,.15);stroke-width:0.6;
  stroke-dasharray:3 3;stroke-linecap:round;fill:none;
}

/* ─────────────────────────────
   MEMBER UNIT  (Design Bible §7)
───────────────────────────────*/
.member-unit{
  position:absolute;transform:translate(-50%,-50%);
  display:flex;flex-direction:column;align-items:center;
}

/* member-visual: 이미지 + 앰블럼 레이어 */
.member-visual{position:relative;display:inline-flex}
.member-image{display:block;object-fit:contain;border-radius:50%}
.member-emblems{position:absolute;inset:0;pointer-events:none}

/* rank-medal: 캐릭터 하단 겹침 */
.rank-medal{position:absolute;bottom:0;right:0; z-index:3;}
.rank-medal img{
  width:clamp(66px,9.9vh,132px);height:auto;object-fit:contain;
  filter:drop-shadow(0 3px 8px rgba(0,0,0,.4));
}
/* qualification-badge (BASE BUSINESS): 캐릭터 하단 겹침 */
.qualification-badge{position:absolute;bottom:0; left:30%; z-index:2;}
.qualification-badge img{
  width:clamp(55px,8.25vh,110px);height:auto;object-fit:contain;
  filter:drop-shadow(0 3px 7px rgba(0,0,0,.35));
}
/* condition-emblem (AUTOSHIP): 캐릭터 하단 겹침 */
.condition-emblem{position:absolute;bottom:0;left:0; z-index:1;}
.condition-emblem img{
  width:clamp(55px,8.25vh,110px);height:auto;object-fit:contain;
  filter:drop-shadow(0 2px 5px rgba(0,0,0,.3));
}

/* 메인 멤버 이미지 크기 */
#member-unit-main .member-image{
  width:clamp(150px,21vh,255px);height:clamp(150px,21vh,255px);
}
/* 자식 멤버 이미지 크기 */
.member-child .member-image{
  width:clamp(100px,14vh,188px);height:clamp(100px,14vh,188px);
}

/* 메인 멤버 위치 */
#member-unit-main{left:50%;top:30%}
/* 자식 멤버 위치 */
#member-unit-left{left:20%;top:72%}
#member-unit-right{left:80%;top:72%}

/* ─────────────────────────────
   METRIC BADGE ? SEP (Design Bible §6-5)
   HTML div component, NOT image
───────────────────────────────*/
/* 캐릭터에 붙는 SEP — 머리 좌측, 살짝 겹침 */
.member-visual .member-metrics{
  position:absolute;
  top:clamp(0px,1%,4px);
  left:0;
  transform:translate(-28%,0);
  margin-top:0;
  z-index:12;
  pointer-events:none;
}
.member-child .member-visual .member-metrics{
  top:clamp(0px,1%,4px);
  transform:translate(-54%,0);
}
.member-visual .member-metrics .metric-badge{position:relative}
.member-metrics{margin-top:clamp(6px,.8%,10px)}
.metric-badge{
  display:inline-flex;align-items:center;gap:clamp(5px,.6vw,8px);
  background:rgba(255,255,255,.9);
  border:1.5px solid rgba(30,90,180,.22);
  border-radius:6px;
  padding:clamp(4px,.5%,6px) clamp(10px,1.2vw,15px);
  white-space:nowrap;box-shadow:0 1px 4px rgba(0,0,0,.06);
}
.metric-label{
  font-size:clamp(11px,1.1vw,14px);font-weight:700;
  color:#1e3a5f;
}
.metric-value{
  font-size:clamp(11px,1.1vw,14px);font-weight:700;
  color:#EE3338;
}

/* ─────────────────────────────
   BONUS STACK + PLATE (Design Bible §6-7)
   HTML div component, NOT image
───────────────────────────────*/
.bonus-stack{
  margin-top:clamp(10px,1.4%,18px);
  display:flex;flex-direction:column;align-items:center;
  gap:clamp(5px,.7%,9px);
}
.bonus-plate{
  display:flex;align-items:center;gap:clamp(8px,1vw,14px);
  background:rgba(255,255,255,.92);
  border:1.5px solid rgba(30,90,180,.16);
  border-radius:8px;
  padding:clamp(7px,.9%,12px) clamp(14px,1.7vw,24px);
  white-space:nowrap;
  box-shadow:0 2px 8px rgba(0,0,0,.07);
}
.bonus-indicator{
  width:clamp(9px,1.1vw,13px);height:clamp(9px,1.1vw,13px);
  border-radius:50%;flex-shrink:0;
}
.support-bonus .bonus-indicator{background:#EE3338}
.recommend-bonus .bonus-indicator{background:#10b981}
.bonus-label{
  font-size:clamp(13px,1.5vw,19px);font-weight:600;color:#1e3a5f;
}
.bonus-value{
  font-size:clamp(14px,1.6vw,21px);font-weight:900;
}
.support-bonus .bonus-value{color:#EE3338}
.recommend-bonus .bonus-value{color:#10b981}

/* ── 텍스트 표시 패널 (뷰포트 나머지 영역) ── */
#lo-panel{
  flex:1 1 0;min-width:0;min-height:0;
  background:rgba(255,255,255,.72);
  backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);
  display:flex;flex-direction:column;justify-content:center;
  position:relative;
  padding:clamp(24px,4%,52px) clamp(28px,4vw,60px);
  overflow-y:auto;
  border-left:1px solid rgba(255,255,255,.5);
}
/* 패널 고정 타이틀 (좌상단) */
#panel-fixed-title{
  position:absolute;top:clamp(16px,2.2%,28px);left:clamp(28px,4vw,60px);
  font-size:clamp(24px,1.1vw,26px);font-weight:700;
  letter-spacing:normal;text-transform:uppercase;
  color:rgba(15,23,42,.38);
  max-width:calc(100% - clamp(28px,4vw,60px) * 2);
  white-space:normal;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.scene-title{
  font-size:clamp(24px,2.1vw,34px);font-weight:900;
  color:#0f172a;line-height:1.28;letter-spacing:normal;
  margin:0 0 clamp(20px,2.8%,36px) 0;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.scene-bullet-list{
  list-style:none;padding:0;margin:0;
  display:flex;flex-direction:column;gap:clamp(12px,1.6%,22px);
}
.bullet-item{
  display:flex;align-items:flex-start;gap:clamp(10px,1.2vw,16px);
}
.bullet-dot{
  width:clamp(7px,.8vw,11px);height:clamp(7px,.8vw,11px);
  border-radius:50%;background:#0f172a;
  flex-shrink:0;margin-top:.38em;
}
.bullet-text{
  font-size:clamp(20px,1.6vw,24px);font-weight:500;
  color:#1e293b;line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
}

/* Responsive */
/* ??????????????????????????????????????????????????????
   ALTWELL OBJECT & MOTION LIBRARY  (§3 Object Library)
???????????????????????????????????????????????????????? */

/* ── §3-1/3-2 Member Units ── */
.member-unit{
  position:relative;
  display:inline-flex;flex-direction:column;align-items:center;
}
.member-visual{
  position:relative;
  display:inline-flex;align-items:center;justify-content:center;
}
.member-image{display:block;object-fit:contain}
/* Layer containers ? stacked over member-visual */
.member-emblem-layer,
.member-marker-layer,
.member-metric-layer,
.member-bonus-layer{
  position:absolute;inset:0;pointer-events:none;
}
/* Emblem group wrapper (bottom-center) */
.member-emblem-group{
  position:absolute;bottom:-14%;left:50%;transform:translateX(-50%);
  display:flex;align-items:flex-end;gap:3px;
}
/* Main Member */
.member-main .member-image{
  width:clamp(120px,17vh,210px);height:clamp(120px,17vh,210px);
}
/* Child Member ? ~70% of main */
.member-child .member-image{
  width:clamp(84px,12vh,148px);height:clamp(84px,12vh,148px);
}

/* ── §3-3 Rank Medal ── */
.rank-medal{
  position:relative;z-index:3;
  display:inline-flex;
}
.rank-medal img{
  width:clamp(44px,7.15vh,90px);height:auto;object-fit:contain;
  filter:drop-shadow(0 2px 6px rgba(0,0,0,.35));
}

/* ── §3-4 Autoship Badge (condition-emblem) ── */
.condition-emblem.autoship-badge{
  position:relative;z-index:1;
  display:inline-flex;
}
.condition-emblem.autoship-badge img{
  width:clamp(29px,4.2vh,57px);height:auto;object-fit:contain;
  filter:drop-shadow(0 1px 4px rgba(0,0,0,.25));
}

/* ── §3-5 BASE Badge (qualification-badge) ── */
.qualification-badge.base-badge{
  position:relative;z-index:2;
  display:inline-flex;
}
.qualification-badge.base-badge img{
  width:clamp(35px,5.5vh,73px);height:auto;object-fit:contain;
  filter:drop-shadow(0 2px 5px rgba(0,0,0,.3));
}

/* ── §3-6/3-7 Bonus Plates ── */
.bonus-plate{
  display:inline-flex;align-items:center;gap:8px;
  background:#fff;
  border:1.5px solid rgba(30,90,180,.14);
  border-radius:10px;
  padding:6px 14px;
  white-space:nowrap;
  box-shadow:0 2px 8px rgba(0,0,0,.07);
}
.bonus-dot{
  width:10px;height:10px;border-radius:50%;flex-shrink:0;
}
.support-bonus .bonus-dot{background:var(--red)}
.recommend-bonus .bonus-dot{background:#10b981}
.bonus-label{font-size:clamp(11px,1.3vw,15px);font-weight:600;color:#1e3a5f}
.bonus-value{font-size:clamp(11px,1.3vw,15px);font-weight:900}
.support-bonus .bonus-value{color:var(--red)}
.recommend-bonus .bonus-value{color:#10b981}

/* ── §3-8 SEP Badge (metric-badge) ── */
.metric-badge{
  display:inline-flex;align-items:center;gap:5px;
  background:#fff;
  border:1.5px solid rgba(238,51,56,.22);
  border-radius:6px;
  padding:3px 10px;
  white-space:nowrap;
  box-shadow:0 1px 4px rgba(0,0,0,.06);
  transition:border-color var(--motion-fast) var(--ease-standard),
             box-shadow var(--motion-fast) var(--ease-standard);
}
.metric-badge[data-status="complete"]{
  border-color:rgba(238,51,56,.5);
  box-shadow:0 0 0 2px rgba(238,51,56,.1);
}
.metric-badge[data-status="highlighted"]{
  border-color:var(--red);
  box-shadow:var(--glow-red);
}
.metric-label{font-size:clamp(9px,.95vw,12px);font-weight:700;color:#1e3a5f}
.metric-value{font-size:clamp(9px,.95vw,12px);font-weight:900;color:var(--red)}

/* SEP Badge — S.E.P / 30만↑ rounded rect (#ee3338) */
.metric-badge.sep-badge{
  display:inline-flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;
  gap:0;
  padding:clamp(2px,.55vw,4px) clamp(4px,1vw,6px);
  border:1.5px solid #ee3338;
  border-radius:8px;
  background:rgba(255,255,255,.96);
  white-space:normal;
  text-align:center;
  line-height:1.15;
  min-width:clamp(44px,5.2vw,58px);
  box-shadow:0 1px 4px rgba(238,51,56,.1);
}
.sep-badge .sep-badge-text{
  font-size:clamp(9px,.95vw,11px);
  font-weight:800;
  color:#ee3338;
  letter-spacing:.03em;
}
.metric-badge.sep-badge[data-status="complete"]{
  border-color:#ee3338;
  box-shadow:0 0 0 2px rgba(238,51,56,.14);
}
.metric-badge.sep-badge[data-status="highlighted"]{
  border-color:#ee3338;
  box-shadow:0 0 0 3px rgba(238,51,56,.22);
}

/* ── §3-9/3-10 Markers (Leader Crown / Recommend Star) ── */
.member-marker{
  position:absolute;top:-20%;left:50%;transform:translateX(-50%);
  z-index:4;display:inline-flex;
}
.member-marker img{
  width:clamp(18px,2.6vh,36px);height:auto;object-fit:contain;
  filter:drop-shadow(0 1px 3px rgba(0,0,0,.2));
}

/* ── Status Check §5-5 ── */
.status-check{
  position:absolute;top:-10px;right:-10px;
  width:clamp(16px,2.2vh,26px);height:clamp(16px,2.2vh,26px);
  border-radius:50%;
  background:var(--red);color:#fff;
  display:flex;align-items:center;justify-content:center;
  font-size:clamp(9px,1.2vh,14px);font-weight:900;
  box-shadow:0 2px 6px rgba(238,51,56,.4);
  opacity:0;z-index:5;
  transition:opacity var(--motion-fast) var(--ease-standard);
}
.status-check.is-visible{opacity:1}

/* ── §8 Object States ── */
.is-hidden{opacity:0!important;pointer-events:none}
.is-inactive{opacity:.32;filter:grayscale(.55)}
.is-active{opacity:1;filter:none}

/* ??????????????????????????????????????????????????????
   ALTWELL MOTION LIBRARY  (§5 Keyframes + Classes)
???????????????????????????????????????????????????????? */

/* §5-1 Fade + Scale */
@keyframes kf-enter{
  from{opacity:0;transform:scale(.94) translateY(6px)}
  to  {opacity:1;transform:scale(1) translateY(0)}
}
/* §5-1b Soft Enter (member-visual, emblem) */
@keyframes kf-soft-enter{
  from{opacity:0;transform:scale(.93)}
  to  {opacity:1;transform:scale(1)}
}
/* §5-2 Glow + Bounce */
@keyframes kf-acquire{
  0%  {opacity:0;transform:scale(.75)}
  50% {opacity:1;transform:scale(1.08)}
  70% {transform:scale(.97)}
  85% {transform:scale(1.03)}
  100%{transform:scale(1)}
}
/* §5-2b Soft Acquire (emblem ? no bounce) */
@keyframes kf-soft-acquire{
  0%  {opacity:0;transform:scale(.86)}
  65% {opacity:1;transform:scale(1.03)}
  100%{opacity:1;transform:scale(1)}
}
@keyframes kf-glow-once{
  0%  {filter:drop-shadow(0 0 0 transparent)}
  40% {filter:drop-shadow(0 0 16px rgba(255,204,60,.7)) drop-shadow(0 0 28px rgba(218,170,55,.45))}
  100%{filter:drop-shadow(0 0 0 transparent)}
}
@keyframes kf-badge-hero-enter{
  0%  {opacity:0;transform:scale(.82) rotateY(0deg);filter:drop-shadow(0 0 0 transparent)}
  45% {opacity:1;transform:scale(1.06) rotateY(180deg);filter:drop-shadow(0 0 20px rgba(255,204,60,.75)) drop-shadow(0 0 32px rgba(218,170,55,.5))}
  100%{opacity:1;transform:scale(1) rotateY(360deg);filter:drop-shadow(0 3px 7px rgba(0,0,0,.35))}
}
/* §5-3 Rank Replace */
@keyframes kf-rank-out{
  from{opacity:1;transform:scale(1)}
  to  {opacity:0;transform:scale(.88)}
}
@keyframes kf-rank-in{
  from{opacity:0;transform:scale(.88)}
  to  {opacity:1;transform:scale(1)}
}
/* §5-4 Slide Up */
@keyframes kf-slide-up{
  from{opacity:0;transform:translateY(20px)}
  to  {opacity:1;transform:translateY(0)}
}
@keyframes kf-scene03-equals-enter{
  from{opacity:0;transform:translateY(calc(-50% + 18px))}
  to  {opacity:1;transform:translateY(-50%)}
}
@keyframes kf-scene03-consumer-enter{
  from{opacity:0;transform:translateX(-50%) translateY(18px)}
  to  {opacity:1;transform:translateX(-50%) translateY(0)}
}
@keyframes kf-scene03-badge-img-float{
  0%,100%{transform:translate(-50%,-30%) translateY(0)}
  50%    {transform:translate(-50%,-30%) translateY(-4px)}
}
.motion-scene03-equals-enter{
  animation:kf-scene03-equals-enter 880ms var(--ease-smooth) both;
}
.motion-scene03-consumer-enter{
  animation:kf-scene03-consumer-enter 800ms var(--ease-smooth) both;
}
.motion-scene03-badge-float{
  animation:kf-scene03-badge-img-float 3000ms ease-in-out infinite;
}
.motion-acquire{
  animation:kf-acquire 800ms var(--ease-emphasis) both;
}
.motion-soft-enter{
  animation:kf-soft-enter 720ms var(--ease-smooth) both;
}
.motion-soft-acquire{
  animation:kf-soft-acquire 750ms var(--ease-smooth) both;
}
.motion-badge-hero-enter{
  animation:kf-badge-hero-enter 1100ms var(--ease-smooth) both;
  transform-origin:center center;
  backface-visibility:visible;
}
.motion-slide-up{
  animation:kf-slide-up 600ms var(--ease-smooth) both;
}
.motion-check{
  animation:kf-check-pop 600ms var(--ease-emphasis) both;
}
.motion-idle-float{
  animation:kf-idle-float 3000ms ease-in-out infinite;
}
.is-entering{animation:kf-enter var(--motion-normal) var(--ease-smooth) both}

/* §11 prefers-reduced-motion */
@media(prefers-reduced-motion:reduce){
  *,*::before,*::after{
    animation-duration:1ms!important;
    animation-iteration-count:1!important;
    transition-duration:1ms!important;
  }
}

/* ??????????????????????????????????????????????????????
   COMPONENT PREVIEW PAGE  (§9)
???????????????????????????????????????????????????????? */
#lib-preview{
  position:fixed;inset:0;z-index:500;
  display:none;flex-direction:column;
  background:#0e1117;font-family:var(--font-sans);
}
#lib-preview.on{display:flex}
/* Header */
#lib-hd{
  height:56px;background:#000;flex-shrink:0;
  display:flex;align-items:center;justify-content:space-between;
  padding:0 24px;border-bottom:1px solid rgba(255,255,255,.08);
}
#lib-hd-title{
  font-size:13px;font-weight:700;letter-spacing:.1em;
  text-transform:uppercase;color:#94a3b8;
}
#lib-hd-badge{
  font-size:10px;font-weight:700;padding:2px 8px;
  border-radius:99px;background:rgba(238,51,56,.18);
  color:var(--red);border:1px solid rgba(238,51,56,.3);
  margin-left:10px;letter-spacing:.08em;
}
#lib-close{
  width:30px;height:30px;border-radius:50%;border:none;
  background:rgba(255,255,255,.07);color:#e2e8f0;font-size:14px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;
}
#lib-close:hover{background:rgba(255,255,255,.16)}
/* Tabs */
#lib-tabs{
  height:44px;background:#000;flex-shrink:0;
  display:flex;align-items:flex-end;
  padding:0 24px;gap:0;
  border-bottom:1px solid rgba(255,255,255,.06);
}
.lib-tab{
  height:40px;padding:0 20px;border:none;
  background:transparent;color:#6b7280;font-size:13px;font-weight:600;
  cursor:pointer;position:relative;transition:color .15s;
  font-family:var(--font-sans);
}
.lib-tab::after{
  content:'';position:absolute;bottom:0;left:0;right:0;height:2px;
  background:transparent;transition:background .15s;
}
.lib-tab.active{color:#f1f5f9}
.lib-tab.active::after{background:var(--red)}
.lib-tab:hover:not(.active){color:#cbd5e1}
/* Body */
#lib-body{
  flex:1;overflow-y:auto;padding:32px 28px;
}
.lib-tab-pane{display:none}
.lib-tab-pane.active{display:block}
/* Section headings */
.lib-section{margin-bottom:40px}
.lib-section-title{
  font-size:11px;font-weight:700;letter-spacing:.12em;text-transform:uppercase;
  color:#475569;margin-bottom:16px;padding-bottom:10px;
  border-bottom:1px solid rgba(255,255,255,.06);
}
/* Object grid */
.lib-obj-grid{
  display:flex;flex-wrap:wrap;gap:16px;align-items:flex-end;
}
/* Object card */
.lib-obj-card{
  background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.07);
  border-radius:12px;padding:20px 16px;
  display:flex;flex-direction:column;align-items:center;gap:10px;
  min-width:120px;
}
.lib-obj-card-label{
  font-size:10px;font-weight:600;color:#64748b;letter-spacing:.06em;
  text-transform:uppercase;text-align:center;
}
/* Motion buttons */
.lib-motion-grid{
  display:flex;flex-wrap:wrap;gap:10px;
}
.lib-btn{
  padding:10px 20px;border-radius:8px;border:1px solid rgba(255,255,255,.1);
  background:rgba(255,255,255,.05);color:#cbd5e1;font-size:13px;font-weight:600;
  cursor:pointer;transition:background .14s,border-color .14s;
  font-family:var(--font-sans);
}
.lib-btn:hover{background:rgba(255,255,255,.12);border-color:rgba(255,255,255,.2)}
.lib-btn.btn-reset{border-color:rgba(238,51,56,.3);color:var(--red)}
.lib-btn.btn-reset:hover{background:rgba(238,51,56,.1)}
/* Combo stage */
#lib-combo-stage{
  background:linear-gradient(160deg,#c8e8f8 0%,#b0d8f0 100%);
  border-radius:16px;padding:40px 20px;
  display:flex;flex-direction:column;align-items:center;
  gap:20px;min-height:320px;justify-content:center;
  position:relative;overflow:hidden;
}
#lib-combo-members{
  display:flex;align-items:flex-end;justify-content:center;gap:40px;
}
#lib-combo-bonuses{
  display:flex;flex-direction:column;align-items:center;gap:8px;
}

/* Dev launcher button (floating) */
#lib-launcher{
  position:fixed;bottom:72px;right:16px;z-index:190;
  width:40px;height:40px;border-radius:50%;
  background:#000;border:1px solid rgba(255,255,255,.15);
  color:#475569;font-size:10px;font-weight:700;
  display:flex;align-items:center;justify-content:center;
  cursor:pointer;letter-spacing:.04em;
  transition:color .14s,border-color .14s;
}
#lib-launcher:hover{color:#94a3b8;border-color:rgba(255,255,255,.3)}

/* 세로 모드: layout-ov 자체를 90도 회전하여 가로처럼 강제 표시 */
@media(orientation:portrait){
  #layout-ov.on{
    display:flex;
    position:fixed;
    top:0;left:0;
    width:100vh;
    height:100vw;
    transform:rotate(90deg) translateY(-100%);
    transform-origin:top left;
  }
}
/* === Common Player — motion canvas inside frame === */
#layout-ov #lo-canvas #motion-canvas{
  position:absolute;inset:0;z-index:1;
  width:100%;height:100%;
  overflow:hidden;
}
#layout-ov #lo-canvas #motion-stage-bg{
  position:absolute;inset:0;z-index:0;pointer-events:none;
}
#lo-panel .panel-desc{
  font-size:clamp(20px,1.6vw,24px);
  font-weight:500;
  color:#1e293b;
  line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
  margin:0 0 clamp(20px,2.8%,36px) 0;
}

/* Legacy dark player panel (index.asp.bak reference) */
#info-panel-inner{width:100%;position:relative}
#info-panel #panel-fixed-title{
  position:relative;top:auto;left:auto;
  font-size:11px;font-weight:700;letter-spacing:.1em;
  text-transform:uppercase;color:#475569;
  margin:0 0 12px 0;
}
#info-panel .scene-title{
  font-size:17px;font-weight:900;color:#e2e8f0;
  line-height:1.45;margin:0 0 14px 0;
}
#info-panel .panel-desc{
  font-size:14px;color:#94a3b8;line-height:1.7;margin:0 0 14px 0;
}
#info-panel .scene-bullet-list .bullet-text{color:#cbd5e1;font-size:14px}
#info-panel .scene-bullet-list .bullet-dot{background:#94a3b8}

/* Scene01 canvas (video_start.asp reference) */
#motion-canvas .scene01-stage-bg,
#motion-canvas .scene-canvas-bg.scene01-stage-bg{
  position:absolute;inset:0;pointer-events:none;z-index:0;
  background:linear-gradient(160deg,#c8e8f8 0%,#b0d8f0 100%);
}
#motion-canvas > *:not(.scene-canvas-bg){z-index:10}
#motion-canvas #lo-connectors{
  position:absolute;inset:0;width:100%;height:100%;
  pointer-events:none;overflow:visible;z-index:5;
}
#motion-canvas #connector-left,
#motion-canvas #connector-right{
  stroke:rgba(96,165,250,.45);
  stroke-width:0.65;
  stroke-dasharray:4 4;
  stroke-linecap:round;
  fill:none;
  opacity:0;
  stroke-dashoffset:36;
  transition:opacity 700ms var(--ease-smooth), stroke-dashoffset 900ms var(--ease-smooth);
}
#motion-canvas #connector-left.is-visible,
#motion-canvas #connector-right.is-visible{
  opacity:1;
  stroke-dashoffset:0;
}
#motion-canvas .member-unit{z-index:10}
.scene-canvas-badge{
  position:relative;bottom:auto;left:auto;right:auto;
  z-index:3;flex-shrink:0;
}
.scene-canvas-badge img{
  width:clamp(74px,6.6vh,84px);height:auto;object-fit:contain;
  filter:drop-shadow(0 3px 7px rgba(0,0,0,.35));
}
#scene01-base-badge img{
  width:clamp(222px,19.8vh,252px);
  transform-origin:center center;
}
#scene01-base-badge{
  perspective:900px;
}
#scene02-base-badge-fly{
  position:absolute;left:50%;top:50%;
  transform:translate(-50%,-50%);
  z-index:10;
  will-change:left,top,transform,opacity;
  perspective:900px;
}
#scene02-base-badge-fly img{
  width:clamp(222px,19.8vh,252px);
  transform-origin:center center;
  backface-visibility:visible;
}
/* Scene02 — sub members same scale as main */
#motion-canvas.scene02-canvas .member-child .member-image{
  width:clamp(140px,20vh,240px);
  height:clamp(140px,20vh,240px);
}
#motion-canvas.scene02-canvas .member-child .condition-emblem.autoship-emblem{
  bottom:-6%;
  left:50%;
  transform:translateX(-50%);
}
#motion-canvas.scene02-canvas .member-child .condition-emblem img{
  width:clamp(74px,6.6vh,84px);
}
#motion-canvas.scene02-canvas #member-unit-main.scene02-main-hero{
  left:50%;
  top:30%;
  transform:translate(-50%,-50%) scale(1.2);
  z-index:14;
}
#layout-ov #lo-canvas.scene02-canvas .member-child .member-image{
  width:clamp(140px,20vh,240px);
  height:clamp(140px,20vh,240px);
}
#layout-ov #lo-canvas.scene02-canvas .member-child .condition-emblem img{
  width:clamp(74px,6.6vh,84px);
}
/* Scene03 canvas HTML labels */
.scene-canvas-html-label{
  position:absolute;
  z-index:11;
  pointer-events:none;
}
#scene03-base-badge{
  perspective:900px;
}
#motion-canvas.scene03-canvas #scene03-base-badge{
  position:absolute;
  left:43%;
  top:43%;
  transform:translate(-50%,-50%);
  z-index:11;
}
#scene03-base-badge img{
  width:clamp(172px,14.8vh,202px);
  transform:translate(-50%,-30%);
  transform-origin:center center;
}
#scene03-equals-label{
  left:calc(43% + clamp(58px,6.4vh,76px));
  top:43%;
  transform:translateY(-50%);
  display:flex;
  align-items:center;
  gap:0.35em;
  font-size:clamp(14px,2.2vh,20px);
  white-space:nowrap;
}
#scene03-equals-label .equals-sign{
  font-weight:700;
  color:#64748b;
}
#scene03-equals-label .label-text{
  font-weight:600;
  display:inline-block;
  padding:0.12em 0.35em;
  border-radius:6px;
}
#scene03-consumer-transition{
  left:50%;
  bottom:30%;
  transform:translateX(-50%);
  display:flex;
  align-items:center;
  gap:0.5em;
  font-size:clamp(18px,2.8vh,26px);
}
#scene03-consumer-transition .label-consumer{
  font-weight:600;
  color:#475569;
}
#scene03-consumer-transition .label-arrow{
  font-weight:400;
  color:#94a3b8;
  font-size:1.1em;
}
#scene03-consumer-transition .label-business{
  font-weight:700;
  color:#0f172a;
  display:inline-block;
  padding:0.12em 0.35em;
  border-radius:6px;
}
/* Scene04 panel + canvas SEP placement */
.scene04-panel-block{margin:0 0 clamp(14px,2%,22px) 0}
.scene04-panel-heading{
  font-size:clamp(24px,1.1vw,26px);
  font-weight:800;
  color:#64748b;
  margin:0 0 8px 0;
  letter-spacing:.04em;
  line-height:1.26;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.scene04-panel-list{list-style:none;padding:0;margin:0}
.scene04-panel-item{
  font-size:clamp(20px,1.45vw,22px);
  font-weight:500;
  color:#334155;
  line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
  margin:0 0 6px 0;
  padding-left:14px;
  position:relative;
}
.scene04-panel-item::before{
  content:'';
  position:absolute;
  left:0;
  top:.55em;
  width:5px;
  height:5px;
  border-radius:50%;
  background:#94a3b8;
}
.scene04-highlight-message{
  font-size:clamp(24px,1.55vw,26px);
  font-weight:800;
  color:var(--highlight-text);
  line-height:1.28;
  word-break:keep-all;
  overflow-wrap:break-word;
  margin:clamp(12px,1.8%,20px) 0 0 0;
  padding:clamp(8px,1%,12px) clamp(10px,1.2%,16px);
  border-radius:8px;
  background:var(--highlight-bg);
  border:1.5px solid var(--highlight-border);
}
/* Scene05 recommend bonus */
#motion-canvas .member-unit.refer-member{z-index:10}
#motion-canvas.scene05-canvas #member-unit-main{
  left:50%;
  top:40%;
  z-index:12;
}
#motion-canvas.scene05-canvas #member-unit-main .member-visual{
  transform:translateY(-5%);
}
#motion-canvas.scene05-canvas #member-unit-main .member-image{
  transform:translateY(-15px);
}
#motion-canvas.scene05-canvas #member-unit-main .member-marker.leader-crown{
  top:-28%;
}
#motion-canvas.scene05-canvas #member-unit-main .member-metrics{
  top:0;
  transform:translate(-28%,-14%);
}
#motion-canvas.scene05-canvas #member-unit-main .member-emblem-group{
  bottom:2%;
}
#motion-canvas.scene05-canvas #refer-member-1{left:22%;top:32%}
#motion-canvas.scene05-canvas #refer-member-2{left:78%;top:30%}
#motion-canvas.scene05-canvas #refer-member-3{left:20%;top:60%}
#motion-canvas.scene05-canvas #refer-member-4{left:80%;top:58%}
#motion-canvas.scene05-canvas #refer-member-5{left:32%;top:76%}
#motion-canvas.scene05-canvas #refer-member-6{left:68%;top:74%}
#motion-canvas.scene05-canvas .member-unit.refer-member .member-image{
  width:clamp(108px,15.6vh,203px);
  height:clamp(108px,15.6vh,203px);
  border-radius:50%;
}
#motion-canvas.scene05-canvas .member-unit.refer-member .member-emblem-group .condition-emblem img{
  width:clamp(88px,7.9vh,100px);
}
#motion-canvas.scene05-canvas .member-unit.refer-member .member-marker.recommend-star img,
#motion-canvas.scene05-canvas .member-unit.refer-member .member-marker.recommend-star .marker-icon{
  width:clamp(18px,2.7vh,34px);
}
#motion-canvas .member-marker.leader-crown img,
#motion-canvas .member-marker.leader-crown .marker-icon{
  width:clamp(22px,3.2vh,38px);
  height:auto;
}
#motion-canvas .member-marker.recommend-star img,
#motion-canvas .member-marker.recommend-star .marker-icon{
  width:clamp(18px,2.6vh,32px);
  height:auto;
}
.scene05-bonus-area{
  margin-top:0;
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:clamp(6px,.8%,10px);
}
#motion-canvas.scene05-canvas .scene05-bonus-dock{
  position:absolute;
  left:50%;
  top:66%;
  transform:translate(-50%, calc(-50% - 70px));
  z-index:6;
  pointer-events:none;
  display:flex;
  flex-direction:column;
  align-items:center;
}
#motion-canvas.scene05-canvas .member-unit.refer-member{z-index:10}
#motion-canvas #recommend-bonus-main{z-index:auto}
.scene05-bonus-flow-icon{
  position:absolute;
  z-index:25;
  pointer-events:none;
  object-fit:contain;
  filter:drop-shadow(0 3px 8px rgba(0,0,0,.22));
  transform-origin:center center;
}
.scene05-base-status-plate{
  font-size:clamp(11px,1.25vw,16px);
  font-weight:700;
  color:#1e3a5f;
  padding:clamp(6px,.8%,10px) clamp(12px,1.4%,18px);
  border-radius:8px;
  background:rgba(255,255,255,.92);
  border:1.5px solid rgba(30,90,180,.2);
  box-shadow:0 2px 8px rgba(0,0,0,.07);
  white-space:nowrap;
}
.scene05-panel-block{margin:0 0 clamp(12px,1.8%,18px) 0}
.scene05-panel-heading{
  font-size:clamp(24px,1.1vw,26px);
  font-weight:800;
  color:#64748b;
  margin:0 0 6px 0;
  line-height:1.26;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.scene05-panel-list{list-style:none;padding:0;margin:0}
.scene05-panel-item{
  font-size:clamp(20px,1.35vw,22px);
  font-weight:500;
  color:#334155;
  line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
  margin:0 0 5px 0;
  padding-left:14px;
  position:relative;
}
.scene05-panel-item::before{
  content:'';
  position:absolute;
  left:0;
  top:.55em;
  width:5px;
  height:5px;
  border-radius:50%;
  background:#94a3b8;
}
/* Scene06 organization growth */
#motion-canvas #member-unit-main.scene06-main{left:50%;top:42%;z-index:12}
#motion-canvas .base-member{z-index:10;transform:translate(-50%,-50%) scale(0.845)}
#motion-canvas #base-member-1{left:32%;top:30%}
#motion-canvas #base-member-2{left:68%;top:30%}
#motion-canvas #base-member-3{left:26%;top:50%}
#motion-canvas #base-member-4{left:74%;top:50%}
#motion-canvas #base-member-5{left:34%;top:68%}
#motion-canvas #base-member-6{left:66%;top:68%}
#motion-canvas .base-member .member-image{
  width:clamp(115px,16.7vh,193px);
  height:clamp(115px,16.7vh,193px);
}
#motion-canvas .base-member .qualification-badge img{
  width:clamp(67px,6.2vh,81px);
}
#motion-canvas #member-unit-main.scene06-main .scene06-system-plate{
  margin-top:clamp(6px,.9%,10px);
}
.scene06-system-plate{
  font-size:clamp(11px,1.2vw,16px);
  font-weight:800;
  color:#1e3a5f;
  padding:clamp(6px,.8%,10px) clamp(12px,1.4%,18px);
  border-radius:8px;
  background:rgba(255,255,255,.94);
  border:1.5px solid rgba(30,90,180,.24);
  box-shadow:0 2px 10px rgba(30,90,180,.12);
  white-space:nowrap;
}
.scene06-growth-dock{
  position:absolute;
  left:50%;
  bottom:20%;
  transform:translateX(-50%);
  z-index:14;
  display:flex;
  flex-direction:column;
  align-items:center;
}
.scene06-growth-stack{
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:clamp(4px,.6%,7px);
}
.scene06-growth-plate{
  font-size:clamp(10px,1.1vw,15px);
  font-weight:700;
  color:#334155;
  padding:clamp(5px,.7%,8px) clamp(10px,1.2%,16px);
  border-radius:7px;
  background:rgba(255,255,255,.9);
  border:1.5px solid rgba(16,185,129,.28);
  box-shadow:0 1px 6px rgba(16,185,129,.1);
  white-space:nowrap;
}
#motion-canvas #lo-connectors.scene06-connectors line{
  stroke:rgba(96,165,250,.45);
  stroke-width:0.65;
  stroke-dasharray:4 4;
  stroke-linecap:round;
  fill:none;
  opacity:0;
  stroke-dashoffset:36;
  transition:opacity 700ms var(--ease-smooth), stroke-dashoffset 900ms var(--ease-smooth);
}
#motion-canvas #lo-connectors.scene06-connectors line.is-visible{
  opacity:1;
  stroke-dashoffset:0;
}
#motion-canvas #lo-connectors.scene06-connectors line.is-glow{
  stroke:rgba(96,165,250,.75);
  stroke-width:0.85;
  filter:drop-shadow(0 0 4px rgba(96,165,250,.45));
}
/* Scene07 summary end card */
#motion-canvas #member-unit-main.scene07-main{left:38%;top:46%;z-index:12}
.scene07-status-plate{
  margin-top:clamp(8px,1.1%,14px);
  font-size:clamp(11px,1.2vw,16px);
  font-weight:800;
  color:#1e3a5f;
  padding:clamp(6px,.8%,10px) clamp(12px,1.4%,18px);
  border-radius:8px;
  background:rgba(255,255,255,.94);
  border:1.5px solid rgba(30,90,180,.24);
  box-shadow:0 2px 10px rgba(30,90,180,.12);
  white-space:nowrap;
}
.scene07-summary-stack{
  position:absolute;
  right:clamp(8%,10%,12%);
  top:50%;
  transform:translateY(-50%);
  display:flex;
  flex-direction:column;
  align-items:stretch;
  gap:clamp(8px,1.1%,12px);
  z-index:14;
  width:clamp(180px,28%,320px);
}
.scene07-summary-card{
  font-size:clamp(11px,1.25vw,17px);
  font-weight:700;
  color:#1e293b;
  line-height:1.45;
  padding:clamp(8px,1%,12px) clamp(12px,1.4%,18px);
  border-radius:10px;
  background:rgba(255,255,255,.93);
  border:1.5px solid rgba(30,90,180,.18);
  box-shadow:0 2px 10px rgba(0,0,0,.08);
}
#layout-ov .member-child .condition-emblem{
  position:absolute;
  bottom:-4%;
  left:30%;
  transform:translateX(-50%);
  z-index:2;
  will-change:left;
}
#layout-ov .member-child .condition-emblem img{
  width:clamp(65px,6.05vh,75px);
  transform-origin:center center;
}
#motion-canvas .member-unit.member-child.is-dimmed{
  opacity:0.45;
  transition:opacity 600ms ease;
}
#motion-canvas .member-unit.member-child.is-dimmed .member-image{
  transform:scale(0.88);
  transition:transform 600ms ease;
}
#motion-canvas .member-unit{
  position:absolute;
  transform:translate(-50%,-50%);
  display:flex;
  flex-direction:column;
  align-items:center;
  transition:opacity 600ms var(--ease-standard);
}
#motion-canvas .member-unit .member-image{
  transition:opacity 600ms var(--ease-standard), transform 600ms var(--ease-standard);
}
#motion-canvas{
  transition:opacity 450ms var(--ease-standard);
}
#motion-canvas #member-unit-main{left:50%;top:28%}
#motion-canvas #member-unit-left{left:22%;top:72%}
#motion-canvas #member-unit-right{left:78%;top:72%}
#motion-canvas #member-unit-main .member-image{
  width:clamp(140px,20vh,240px);
  height:clamp(140px,20vh,240px);
  border-radius:50%;
}
#motion-canvas .member-child .member-image{
  width:clamp(90px,13vh,170px);
  height:clamp(90px,13vh,170px);
  border-radius:50%;
}
#motion-canvas .member-emblems{
  position:absolute;
  inset:0;
  pointer-events:none;
}
#motion-canvas .member-emblem-group{
  position:absolute;
  bottom:-6%;
  left:50%;
  transform:translateX(-50%);
  display:flex;
  align-items:flex-end;
  justify-content:center;
  gap:0;
  z-index:3;
}
#motion-canvas .member-emblem-group .rank-medal,
#motion-canvas .member-emblem-group .qualification-badge,
#motion-canvas .member-emblem-group .condition-emblem{
  position:relative;
  bottom:auto;
  left:auto;
  right:auto;
  flex-shrink:0;
}
#motion-canvas .member-emblem-group .condition-emblem{z-index:1}
#motion-canvas .member-emblem-group .qualification-badge{
  margin-left:clamp(-16px,-2.2vh,-28px);
  z-index:2;
}
#motion-canvas .member-emblem-group .rank-medal{
  margin-left:clamp(-16px,-2.2vh,-28px);
  z-index:3;
}
#motion-canvas .member-emblem-group .rank-medal img{
  width:clamp(78px,7.15vh,90px);
}
#motion-canvas .member-emblem-group .qualification-badge img,
#motion-canvas .member-emblem-group .condition-emblem img{
  width:clamp(74px,6.6vh,84px);
}
#motion-canvas .member-child .condition-emblem{
  position:absolute;
  bottom:-4%;
  left:30%;
  transform:translateX(-50%);
  z-index:2;
}
#motion-canvas .member-child .condition-emblem img{
  width:clamp(65px,6.05vh,75px);
}
/* Scene04 child autoship — center에서 살짝만 좌측 */
#motion-canvas.scene04-canvas .member-child .member-image{
  width:clamp(117px,16.9vh,221px);
  height:clamp(117px,16.9vh,221px);
}
#motion-canvas.scene04-canvas .member-child .condition-emblem img{
  width:clamp(85px,7.9vh,98px);
}
#motion-canvas.scene04-canvas .member-child .condition-emblem.autoship-emblem{
  left:44%;
}
#layout-ov #lo-canvas.scene04-canvas .member-child .member-image{
  width:clamp(117px,16.9vh,221px);
  height:clamp(117px,16.9vh,221px);
}
#layout-ov #lo-canvas.scene04-canvas .member-child .condition-emblem img{
  width:clamp(85px,7.9vh,98px);
}

/* === video_start.asp layout (4:3 stage + text panel) === */
body.page-layout #layout-ov{display:flex}

#layout-ov #lo-canvas .member-unit{
  position:absolute;
  transform:translate(-50%,-50%);
  display:flex;
  flex-direction:column;
  align-items:center;
}

#layout-ov #member-unit-main{left:50%;top:28%}
#layout-ov #member-unit-left{left:22%;top:72%}
#layout-ov #member-unit-right{left:78%;top:72%}

#layout-ov #member-unit-main .member-image{
  width:clamp(140px,20vh,240px);
  height:clamp(140px,20vh,240px);
  border-radius:50%;
}

#layout-ov .member-child .member-image{
  width:clamp(90px,13vh,170px);
  height:clamp(90px,13vh,170px);
  border-radius:50%;
}

#layout-ov .member-emblems{
  position:absolute;
  inset:0;
  pointer-events:none;
}

#layout-ov .member-emblem-group{
  position:absolute;
  bottom:-6%;
  left:50%;
  transform:translateX(-50%);
  display:flex;
  align-items:flex-end;
  justify-content:center;
  gap:0;
  z-index:3;
}

#layout-ov .member-emblem-group .rank-medal,
#layout-ov .member-emblem-group .qualification-badge,
#layout-ov .member-emblem-group .condition-emblem{
  position:relative;
  bottom:auto;left:auto;right:auto;
  flex-shrink:0;
}

#layout-ov .member-emblem-group .condition-emblem{
  z-index:1;
}
#layout-ov .member-emblem-group .qualification-badge{
  margin-left:clamp(-16px,-2.2vh,-28px);
  z-index:2;
}
#layout-ov .member-emblem-group .rank-medal{
  margin-left:clamp(-16px,-2.2vh,-28px);
  z-index:3;
}

#layout-ov .member-emblem-group .rank-medal img{
  width:clamp(78px,7.15vh,90px);
}
#layout-ov .member-emblem-group .qualification-badge img{
  width:clamp(74px,6.6vh,84px);
}
#layout-ov .member-emblem-group .condition-emblem img{
  width:clamp(74px,6.6vh,84px);
}

#layout-ov #connector-left,
#layout-ov #connector-right{
  stroke:rgba(96,165,250,.4);
  stroke-width:0.55;
  stroke-dasharray:4 4;
}

#layout-ov #lo-panel .scene-title.motion-slide-up,
#layout-ov #lo-panel #scene-bullets .bullet-item.motion-slide-up{
  animation-name:kf-slide-up;
  animation-duration:900ms;
  animation-timing-function:var(--ease-smooth);
  animation-fill-mode:both;
}
#layout-ov #lo-panel #scene-bullets .bullet-item{
  opacity:1;
}

#layout-ov #panel-fixed-title{
  display:none !important;
}

/* 우측 텍스트 패널 — 넓은 뷰포트(>960px) 폰트 최소 크기 */
@media(min-width:961px){
  #lo-panel .scene-title,
  .scene-title{
    font-size:clamp(36px,2.1vw,42px);
  }
  #lo-panel .panel-desc,
  #lo-panel .bullet-text,
  .bullet-text{
    font-size:clamp(30px,1.6vw,36px);
  }
  #lo-panel .scene04-panel-heading,
  .scene04-panel-heading{
    font-size:clamp(36px,1.1vw,38px);
  }
  #lo-panel .scene04-panel-item,
  .scene04-panel-item{
    font-size:clamp(30px,1.45vw,34px);
  }
  #lo-panel .scene04-highlight-message,
  .scene04-highlight-message{
    font-size:clamp(36px,1.55vw,40px);
  }
  #lo-panel .scene05-panel-heading,
  .scene05-panel-heading{
    font-size:clamp(36px,1.1vw,38px);
  }
  #lo-panel .scene05-panel-item,
  .scene05-panel-item{
    font-size:clamp(30px,1.35vw,34px);
  }
  #lo-panel .sim-step-label,
  .sim-step-label{
    font-size:clamp(36px,1vw,38px);
  }
  #lo-panel .sim-question,
  .sim-question{
    font-size:clamp(30px,1.5vw,34px);
  }
  #lo-panel .sim-choice-key,
  .sim-choice-key{
    font-size:clamp(36px,1.4vw,38px);
  }
  #lo-panel .sim-choice-text,
  .sim-choice-text{
    font-size:clamp(30px,1.45vw,34px);
  }
  #lo-panel .sim-feedback,
  .sim-feedback{
    font-size:clamp(30px,1.4vw,34px);
  }
  #lo-panel .sim-next-btn,
  .sim-next-btn{
    font-size:clamp(36px,1.4vw,38px);
  }
  #lo-panel .sim-result-chapter,
  .sim-result-chapter{
    font-size:clamp(36px,1vw,38px);
  }
  #lo-panel .sim-result-title,
  .sim-result-title{
    font-size:clamp(36px,2.1vw,42px);
  }
  #lo-panel .sim-result-item,
  .sim-result-item{
    font-size:clamp(30px,1.5vw,34px);
  }
  #lo-panel .sim-action-btn,
  .sim-action-btn{
    font-size:clamp(36px,1.4vw,38px);
  }
}

@media(max-width:900px){
  #layout-ov #lo-main{
    flex-direction:column;
  }
  #layout-ov .lo-motion-zone{
    flex:0 0 auto;
    width:100%;
    height:auto;
    min-height:0;
    max-width:100%;
  }
  #layout-ov .lo-stage-frame{
    width:100%;
    height:auto;
    max-height:none;
    aspect-ratio:var(--lo-stage-ratio);
    container-type:size;
    container-name:lo-stage;
  }
  #layout-ov #lo-panel{
    flex:1 1 0;
    width:100%;
    min-height:0;
    border-left:none;
    border-top:1px solid rgba(255,255,255,.5);
    justify-content:flex-start;
    padding:14px 18px 18px;
    overflow-y:auto;
  }
  #layout-ov #lo-panel .scene-title{
    font-size:clamp(24px,4.6vw,28px);
    line-height:1.28;
    margin:0 0 10px 0;
  }
  #layout-ov #lo-panel .panel-desc{
    font-size:clamp(20px,3.8vw,22px);
    line-height:1.32;
    margin:0 0 12px 0;
  }
  #layout-ov #lo-panel .scene-bullet-list{
    gap:10px;
  }
  #layout-ov #lo-panel .bullet-item{
    align-items:flex-start;
    gap:10px;
  }
  #layout-ov #lo-panel .bullet-dot{
    margin-top:.38em;
    flex-shrink:0;
  }
  #layout-ov #lo-panel .bullet-text{
    font-size:clamp(20px,3.6vw,22px);
    line-height:1.32;
  }
  /* 프레임 기준 크기 — viewport vh 대신 프레임 cqh 사용 */
  #layout-ov #motion-canvas #member-unit-main .member-image,
  #layout-ov #lo-canvas #member-unit-main .member-image{
    width:clamp(96px,24cqh,220px);
    height:clamp(96px,24cqh,220px);
  }
  #layout-ov #motion-canvas .member-child .member-image,
  #layout-ov #lo-canvas .member-child .member-image{
    width:clamp(64px,16cqh,150px);
    height:clamp(64px,16cqh,150px);
  }
  #layout-ov #motion-canvas .member-emblem-group .rank-medal img,
  #layout-ov #motion-canvas .member-emblem-group .qualification-badge img,
  #layout-ov #motion-canvas .member-emblem-group .condition-emblem img,
  #layout-ov #lo-canvas .member-emblem-group .rank-medal img,
  #layout-ov #lo-canvas .member-emblem-group .qualification-badge img,
  #layout-ov #lo-canvas .member-emblem-group .condition-emblem img{
    width:clamp(48px,8cqh,90px);
  }
}

/* ??????????????????????????????
   SIMULATOR (BASE사업자 이해하기)
?????????????????????????????? */
#sim-ctrl{
  height:56px;background:#000;flex-shrink:0;
  border-top:1px solid rgba(255,255,255,.07);
  display:flex;flex-direction:column;
  justify-content:center;padding:0 24px;gap:6px;
}
#sim-progress-wrap{width:100%}
#sim-progress-track{
  height:4px;background:rgba(255,255,255,.15);
  border-radius:99px;position:relative;overflow:hidden;
}
#sim-progress-fill{
  height:100%;background:#10b981;border-radius:99px;
  width:0;transition:width .35s var(--ease-smooth);
}
#sim-cr{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
.sim-ctrl-btn{
  font-size:13px;font-weight:700;letter-spacing:.06em;
  color:#6b7280;background:rgba(255,255,255,.05);
  border:1px solid rgba(255,255,255,.14);border-radius:6px;
  padding:5px 12px;cursor:pointer;transition:background .14s,color .14s;
}
.sim-ctrl-btn:hover:not(:disabled){background:rgba(255,255,255,.18)}
.sim-ctrl-btn:disabled{opacity:.35;cursor:not-allowed}
.sim-ctrl-restart{margin-left:auto}
#sim-step-number{
  font-size:12px;color:#9ca3af;font-variant-numeric:tabular-nums;
  min-width:48px;text-align:center;
}

.layout-simulator #lo-panel{
  justify-content:flex-start;
  padding-top:clamp(40px,5%,56px);
}
#sim-question-panel.is-hidden,
#sim-result-panel.is-hidden{display:none!important}
.sim-step-label{
  font-size:clamp(24px,1vw,26px);font-weight:800;
  letter-spacing:.14em;text-transform:uppercase;
  color:#64748b;margin:0 0 8px 0;
  line-height:1.26;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.sim-question{
  font-size:clamp(20px,1.5vw,22px);font-weight:600;
  color:#334155;line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
  margin:0 0 clamp(16px,2.2%,24px) 0;
  white-space:pre-line;
}
.sim-choices{
  display:flex;flex-direction:column;
  gap:clamp(10px,1.4%,14px);
  margin:0 0 clamp(16px,2.2%,24px) 0;
}
.sim-choice-btn{
  display:flex;align-items:flex-start;gap:10px;
  width:100%;text-align:left;
  background:rgba(255,255,255,.85);
  border:2px solid rgba(30,90,180,.14);
  border-radius:10px;
  padding:clamp(12px,1.6%,16px) clamp(14px,1.8%,18px);
  cursor:pointer;transition:border-color .14s,background .14s,box-shadow .14s;
  font-family:inherit;
}
.sim-choice-btn:hover:not(:disabled){
  border-color:rgba(30,90,180,.35);
  background:#fff;
}
.sim-choice-btn:focus-visible{
  outline:2px solid #1e5ab4;outline-offset:2px;
}
.sim-choice-btn.is-wrong{
  border-color:#EE3338;
  background:rgba(238,51,56,.06);
  animation:sim-shake .35s ease;
}
.sim-choice-btn.is-correct-choice{
  border-color:#10b981;
  background:rgba(16,185,129,.08);
}
.sim-choice-btn.is-locked:not(.is-correct-choice){opacity:.55}
.sim-choice-key{
  font-size:clamp(24px,1.4vw,26px);font-weight:800;
  color:#64748b;flex-shrink:0;min-width:1.4em;
}
.sim-choice-text{
  font-size:clamp(20px,1.45vw,22px);font-weight:500;
  color:#1e293b;line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
}
@keyframes sim-shake{
  0%,100%{transform:translateX(0)}
  25%{transform:translateX(-4px)}
  75%{transform:translateX(4px)}
}

.sim-feedback{
  display:flex;align-items:flex-start;gap:10px;
  border-radius:10px;padding:clamp(12px,1.6%,16px);
  margin:0 0 clamp(14px,2%,20px) 0;
  font-size:clamp(20px,1.4vw,22px);line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.sim-feedback-correct{
  background:rgba(16,185,129,.1);
  border:1.5px solid rgba(16,185,129,.35);
  color:#065f46;
}
.sim-feedback-incorrect{
  background:rgba(238,51,56,.08);
  border:1.5px solid rgba(238,51,56,.3);
  color:#991b1b;
}
.sim-feedback-icon{font-weight:900;flex-shrink:0;line-height:1.4}
.sim-feedback-text{font-weight:500}

.sim-next-btn{
  align-self:flex-start;
  font-size:clamp(24px,1.4vw,26px);font-weight:700;
  color:#fff;background:#1e5ab4;
  border:none;border-radius:8px;
  padding:10px 22px;cursor:pointer;
  transition:background .14s,opacity .14s;
}
.sim-next-btn:hover:not(:disabled){background:#164a96}
.sim-next-btn.is-hidden{display:none!important;pointer-events:none}
.sim-next-btn:disabled{opacity:.4;cursor:not-allowed}
.sim-next-btn:focus-visible{outline:2px solid #0f172a;outline-offset:2px}

#sim-result-panel{padding-top:clamp(8px,1.5%,16px)}
.sim-result-chapter{
  font-size:clamp(24px,1vw,26px);font-weight:700;
  letter-spacing:.12em;text-transform:uppercase;
  color:rgba(15,23,42,.38);margin:0 0 10px 0;
  line-height:1.26;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.sim-result-title{
  font-size:clamp(24px,2.1vw,30px);font-weight:900;
  color:#0f172a;line-height:1.28;margin:0 0 clamp(18px,2.5%,28px) 0;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.sim-result-summary{
  list-style:none;padding:0;margin:0 0 clamp(22px,3%,32px) 0;
  display:flex;flex-direction:column;gap:clamp(12px,1.6%,18px);
}
.sim-result-item{
  display:flex;align-items:flex-start;gap:10px;
  font-size:clamp(20px,1.5vw,22px);font-weight:500;
  color:#1e293b;line-height:1.32;
  word-break:keep-all;
  overflow-wrap:break-word;
}
.sim-result-icon{
  color:#10b981;font-weight:900;flex-shrink:0;
}
.sim-result-actions{
  display:flex;flex-direction:column;gap:10px;
}
.sim-action-btn{
  font-size:clamp(24px,1.4vw,26px);font-weight:700;
  border-radius:8px;padding:11px 18px;cursor:pointer;
  border:1.5px solid rgba(30,90,180,.2);
  background:rgba(255,255,255,.9);color:#1e3a5f;
  transition:background .14s,border-color .14s;
  font-family:inherit;
}
.sim-action-btn:hover{background:#fff;border-color:rgba(30,90,180,.4)}
.sim-action-btn:focus-visible{outline:2px solid #1e5ab4;outline-offset:2px}
.sim-action-primary{
  background:#1e5ab4;color:#fff;border-color:#1e5ab4;
}
.sim-action-primary:hover{background:#164a96}
.sim-action-muted{color:#64748b;border-color:rgba(100,116,139,.25)}

/* Simulator canvas HTML labels (reuse Scene03 style) */
#sm-equals-label{
  left:calc(50% + clamp(90px,10vh,118px));
  top:50%;transform:translateY(-50%);
  display:flex;align-items:center;gap:0.35em;
  font-size:clamp(14px,2.2vh,20px);white-space:nowrap;
}
#sm-equals-label .equals-sign{font-weight:700;color:#64748b}
#sm-equals-label .label-text{font-weight:600;display:inline-block;padding:0.12em 0.35em;border-radius:6px}
#sm-consumer-transition{
  left:50%;bottom:12%;transform:translateX(-50%);
  display:flex;align-items:center;gap:0.5em;
  font-size:clamp(16px,2.8vh,24px);
}
#sm-consumer-transition .label-consumer{font-weight:600;color:#475569}
#sm-consumer-transition .label-arrow{font-weight:400;color:#94a3b8;font-size:1.1em}
#sm-consumer-transition .label-business{font-weight:700;color:#0f172a;display:inline-block;padding:0.12em 0.35em;border-radius:6px}

#motion-canvas #scene01-base-badge{
  position:relative;z-index:10;
}

/* Simulator: main member float on member-visual (avoids member-unit transform conflict) */
#motion-canvas #member-unit-main .member-visual.motion-idle-float{
  animation:kf-idle-float 3000ms ease-in-out infinite;
  will-change:transform;
}

@media(max-width:900px){
  .sim-ctrl-restart{margin-left:0}
  #sim-cr{gap:8px}
  .sim-choice-btn{padding:12px 14px}
}