<%@ Language=VBScript CodePage=65001 %>

<!--#include file="includes/asp_utf8.asp"-->

<html lang="ko">

<head>

<meta charset="utf-8"/>

<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

<title>에셋 디자인 - ALTWELL SMART GUIDE</title>

<!--#include file="includes/fonts.asp"-->

<!--#include file="includes/main_css.asp"-->

<link rel="stylesheet" href="_css/icon_style.css"/>

<style>

.asset-preview{padding:40px 24px 60px;display:flex;flex-direction:column;gap:48px}

.asset-preview h2{font-size:14px;font-weight:700;color:#64748b;letter-spacing:.08em;margin-bottom:16px}

.lev_container,.badge_container,.sub_asset_container{display:flex;flex-wrap:wrap;gap:24px;align-items:center}

</style>

</head>

<body class="page-layout" style="overflow:scroll;">



<div class="asset-preview">

  <section>

    <h2>RANK MEDAL</h2>

    <!--#include file="includes/components/lev_container.asp"-->

  </section>

  <section>

    <h2>BADGE</h2>

    <!--#include file="includes/components/badge_container.asp"-->

  </section>

  <section>

    <h2>UNIT</h2>

    <!--#include file="includes/components/person_container.asp"-->

  </section>

  <section>

    <h2>SUB ASSET</h2>

    <!--#include file="includes/components/sub_asset_container.asp"-->

  </section>


  <section>
    <h2>MORE ASSETS</h2>


    <style>
      :root {
        --font-sans: 'MinSansVF', 'Pretendard', 'Noto Sans KR', sans-serif;
        --guide-red: #ee3338;
        --blue-900: #0b2a91;
        --blue-700: #1034ac;
        --blue-500: #4669df;
        --blue-100: #eaf0ff;
        --green-700: #087348;
        --green-100: #e7f7ef;
        --orange-700: #b23c00;
        --orange-500: #ef6c00;
        --orange-100: #fff0df;
        --gold-500: #fdd503;
        --gold-700: #9b7600;
        --ink: #1f2937;
        --muted: #6b7280;
        --line: #dbe2ee;
        --surface: #ffffff;
        --canvas: #f4f7fb;
      }
      
      
      
      .asset_showcase {
        width: min(1180px, 100%);
        margin: 0 auto;
      }
      .asset_showcase_header { margin-bottom: 28px; }
      .asset_showcase_header h1 { margin: 0 0 8px; font-size: 30px; }
      .asset_showcase_header p { margin: 0; color: var(--muted); line-height: 1.65; }
      .asset_section {
        margin-top: 22px;
        padding: 24px;
        border: 1px solid #e3e8f1;
        border-radius: 22px;
        background: #fff;
        box-shadow: 0 12px 34px rgba(31, 41, 55, .06);
      }
      .asset_section_title { margin: 0 0 18px; font-size: 20px; }
      .asset_grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 18px;
      }
      .asset_preview {
        min-height: 210px;
        padding: 18px;
        border: 1px solid #e8ecf3;
        border-radius: 16px;
        background: linear-gradient(145deg, #fff, #f8faff);
      }
      .asset_preview_name { margin: 0 0 20px; color: #536077; font-size: 13px; font-weight: 800; }
      .asset_preview_body {
        min-height: 132px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 16px;
      }
      
      /* 01. 공통 정보 뱃지 ---------------------------------------------------- */
      .guide_info_badge {
        --size: 36px;
        --badge-bg-1: #2c51ca;
        --badge-bg-2: #1034ac;
        --badge-bg-3: #462db3;
        --badge-border: #0b2a91;
        --badge-label-bg: #b3b1ff;
        --badge-label-color: #0b2a91;
        --badge-text-color: #fff;
        display: inline-flex;
        align-items: center;
        width: fit-content;
        height: var(--size);
        padding: calc(var(--size) * 5 / 36) calc(var(--size) * 7 / 36);
        gap: calc(var(--size) * 5 / 36);
        border-radius: calc(var(--size) * 10 / 36);
        background: linear-gradient(120deg, var(--badge-bg-1), var(--badge-bg-2), var(--badge-bg-3));
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 36) var(--badge-border);
        font-family: var(--font-sans);
      }
      .guide_info_badge_label {
        display: grid;
        place-items: center;
        width: calc(var(--size) * 24 / 36);
        height: calc(var(--size) * 24 / 36);
        flex: 0 0 auto;
        border-radius: 50%;
        color: var(--badge-label-color);
        background: var(--badge-label-bg);
        font-size: calc(var(--size) * 14 / 36);
        font-weight: 900;
      }
      .guide_info_badge_text {
        color: var(--badge-text-color);
        font-size: calc(var(--size) * 16 / 36);
        font-weight: 800;
        line-height: 1;
        white-space: nowrap;
      }
      .guide_info_badge.is_green {
        --badge-bg-1: #118839; --badge-bg-2: #08794d; --badge-bg-3: #107474;
        --badge-border: #05653f; --badge-label-bg: #75cf40; --badge-label-color: #fff;
      }
      .guide_info_badge.is_orange {
        --badge-bg-1: #e65100; --badge-bg-2: #f57c00; --badge-bg-3: #ef6c00;
        --badge-border: #b23c00; --badge-label-bg: #ffd180; --badge-label-color: #b23c00;
      }
      .guide_info_badge.is_red {
        --badge-bg-1: #ef5350; --badge-bg-2: #d92f39; --badge-bg-3: #b91c2b;
        --badge-border: #a21927; --badge-label-bg: #ffd7da; --badge-label-color: #a21927;
      }
      
      /* 02. 자동 갱신 ---------------------------------------------------------- */
      .auto_renewal_icon {
        --size: 132px;
        position: relative;
        width: var(--size);
        height: var(--size);
        font-family: var(--font-sans);
      }
      .auto_renewal_ring {
        position: absolute;
        inset: calc(var(--size) * 8 / 132);
        border: calc(var(--size) * 10 / 132) solid #dce5ff;
        border-top-color: var(--blue-500);
        border-right-color: var(--blue-700);
        border-radius: 50%;
        transform: rotate(24deg);
      }
      .auto_renewal_arrow {
        position: absolute;
        top: calc(var(--size) * 8 / 132);
        right: calc(var(--size) * 11 / 132);
        width: 0;
        height: 0;
        border-top: calc(var(--size) * 13 / 132) solid transparent;
        border-bottom: calc(var(--size) * 13 / 132) solid transparent;
        border-left: calc(var(--size) * 20 / 132) solid var(--blue-700);
        transform: rotate(26deg);
      }
      .auto_renewal_center {
        position: absolute;
        inset: calc(var(--size) * 29 / 132);
        display: grid;
        place-items: center;
        border-radius: 50%;
        color: var(--blue-900);
        background: linear-gradient(145deg, #fff, var(--blue-100));
        box-shadow: 0 calc(var(--size) * 5 / 132) calc(var(--size) * 14 / 132) rgba(16, 52, 172, .17);
        text-align: center;
        font-size: calc(var(--size) * 15 / 132);
        font-weight: 900;
        line-height: 1.2;
      }
      
      /* 03. 3개월 자동 갱신 흐름 --------------------------------------------- */
      .subscription_flow_card {
        --size: 340px;
        width: var(--size);
        padding: calc(var(--size) * 18 / 340);
        border-radius: calc(var(--size) * 18 / 340);
        color: var(--ink);
        background: #fff;
        box-shadow: 0 calc(var(--size) * 8 / 340) calc(var(--size) * 24 / 340) rgba(31, 41, 55, .13);
        font-family: var(--font-sans);
      }
      .subscription_flow_title {
        margin-bottom: calc(var(--size) * 14 / 340);
        color: var(--blue-900);
        font-size: calc(var(--size) * 17 / 340);
        font-weight: 900;
      }
      .subscription_flow_track { display: flex; align-items: center; gap: calc(var(--size) * 7 / 340); }
      .subscription_flow_month {
        display: grid;
        place-items: center;
        width: calc(var(--size) * 50 / 340);
        height: calc(var(--size) * 50 / 340);
        flex: 0 0 auto;
        border-radius: calc(var(--size) * 12 / 340);
        color: var(--blue-900);
        background: var(--blue-100);
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 340) #c8d5ff;
        font-size: calc(var(--size) * 13 / 340);
        font-weight: 900;
      }
      .subscription_flow_month.is_next { color: #fff; background: linear-gradient(145deg, var(--blue-500), var(--blue-700)); }
      .subscription_flow_line { height: calc(var(--size) * 3 / 340); flex: 1; border-radius: 999px; background: #bdc9de; }
      .subscription_flow_line.is_renew { position: relative; background: var(--guide-red); }
      .subscription_flow_line.is_renew::after {
        content: '';
        position: absolute;
        top: 50%;
        right: 0;
        width: 0;
        height: 0;
        border-top: calc(var(--size) * 6 / 340) solid transparent;
        border-bottom: calc(var(--size) * 6 / 340) solid transparent;
        border-left: calc(var(--size) * 9 / 340) solid var(--guide-red);
        transform: translate(40%, -50%);
      }
      
      /* 04. 회원 기준 ---------------------------------------------------------- */
      .member_basis_card {
        --size: 220px;
        width: var(--size);
        padding: calc(var(--size) * 18 / 220);
        border-radius: calc(var(--size) * 18 / 220);
        background: linear-gradient(145deg, #fff, #f4f7ff);
        box-shadow: 0 calc(var(--size) * 8 / 220) calc(var(--size) * 22 / 220) rgba(31, 41, 55, .12);
        font-family: var(--font-sans);
        text-align: center;
      }
      .member_basis_person {
        position: relative;
        width: calc(var(--size) * 64 / 220);
        height: calc(var(--size) * 64 / 220);
        margin: 0 auto calc(var(--size) * 10 / 220);
      }
      .member_basis_person::before {
        content: '';
        position: absolute;
        top: 5%; left: 50%;
        width: 34%; height: 34%;
        border-radius: 50%;
        background: #73a5f0;
        transform: translateX(-50%);
      }
      .member_basis_person::after {
        content: '';
        position: absolute;
        bottom: 2%; left: 50%;
        width: 74%; height: 48%;
        border-radius: 50% 50% 12% 12% / 75% 75% 18% 18%;
        background: #73a5f0;
        transform: translateX(-50%);
      }
      .member_basis_point {
        display: inline-flex;
        align-items: center;
        gap: calc(var(--size) * 5 / 220);
        padding: calc(var(--size) * 7 / 220) calc(var(--size) * 11 / 220);
        border-radius: 999px;
        color: #665308;
        background: linear-gradient(120deg, #ffd738, #ffeca0, #ffe373);
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 220) #c7a417;
        font-size: calc(var(--size) * 15 / 220);
        font-weight: 900;
      }
      .member_basis_caption { margin-top: calc(var(--size) * 9 / 220); color: var(--muted); font-size: calc(var(--size) * 12 / 220); font-weight: 700; }
      
      /* 05. 그룹 브래킷 -------------------------------------------------------- */
      .group_bracket {
        --size: 250px;
        position: relative;
        width: var(--size);
        min-height: calc(var(--size) * 68 / 250);
        padding-top: calc(var(--size) * 22 / 250);
        font-family: var(--font-sans);
      }
      .group_bracket_line {
        position: absolute;
        top: 0; left: 4%;
        width: 92%;
        height: calc(var(--size) * 18 / 250);
        border-top: calc(var(--size) * 3 / 250) solid var(--blue-500);
        border-left: calc(var(--size) * 3 / 250) solid var(--blue-500);
        border-right: calc(var(--size) * 3 / 250) solid var(--blue-500);
        border-radius: calc(var(--size) * 9 / 250) calc(var(--size) * 9 / 250) 0 0;
      }
      .group_bracket_label { color: var(--blue-900); font-size: calc(var(--size) * 15 / 250); font-weight: 900; text-align: center; }
      
      /* 06. 상품 변경 불가 ----------------------------------------------------- */
      .product_swap_icon {
        --size: 190px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: calc(var(--size) * 12 / 190);
        width: var(--size);
        font-family: var(--font-sans);
      }
      .product_swap_box {
        display: grid;
        place-items: center;
        width: calc(var(--size) * 58 / 190);
        height: calc(var(--size) * 52 / 190);
        border-radius: calc(var(--size) * 8 / 190);
        color: #fff8e8;
        background: linear-gradient(145deg, #b97a3f, #8c552b);
        box-shadow: inset 0 calc(var(--size) * 6 / 190) 0 rgba(255,255,255,.13), 0 calc(var(--size) * 5 / 190) calc(var(--size) * 10 / 190) rgba(82, 50, 25, .2);
        font-size: calc(var(--size) * 24 / 190);
        font-weight: 900;
      }
      .product_swap_arrows { position: relative; width: calc(var(--size) * 44 / 190); height: calc(var(--size) * 36 / 190); }
      .product_swap_arrows::before,
      .product_swap_arrows::after {
        content: '';
        position: absolute;
        left: 0;
        width: 85%;
        height: calc(var(--size) * 3 / 190);
        border-radius: 999px;
        background: #8a98ae;
      }
      .product_swap_arrows::before { top: 25%; }
      .product_swap_arrows::after { bottom: 25%; transform: rotate(180deg); }
      .product_swap_block {
        position: absolute;
        top: 50%; left: 50%;
        width: calc(var(--size) * 36 / 190);
        height: calc(var(--size) * 36 / 190);
        border: calc(var(--size) * 4 / 190) solid var(--guide-red);
        border-radius: 50%;
        transform: translate(-50%, -50%);
      }
      .product_swap_block::after {
        content: '';
        position: absolute;
        top: 50%; left: 50%;
        width: 112%;
        height: calc(var(--size) * 4 / 190);
        border-radius: 999px;
        background: var(--guide-red);
        transform: translate(-50%, -50%) rotate(-45deg);
      }
      
      /* 07. 해지 신청 카드 ----------------------------------------------------- */
      .cancel_request_card {
        --size: 240px;
        display: flex;
        align-items: center;
        gap: calc(var(--size) * 12 / 240);
        width: var(--size);
        padding: calc(var(--size) * 14 / 240);
        border-radius: calc(var(--size) * 16 / 240);
        color: #8e202b;
        background: linear-gradient(145deg, #fff, #fff1f2);
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 240) #ffc8cd, 0 calc(var(--size) * 7 / 240) calc(var(--size) * 18 / 240) rgba(142,32,43,.10);
        font-family: var(--font-sans);
      }
      .cancel_request_doc {
        position: relative;
        width: calc(var(--size) * 48 / 240);
        height: calc(var(--size) * 58 / 240);
        flex: 0 0 auto;
        border-radius: calc(var(--size) * 7 / 240);
        background: #fff;
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 240) #e65c68;
      }
      .cancel_request_doc::before,
      .cancel_request_doc::after {
        content: '';
        position: absolute;
        left: 22%;
        width: 56%;
        height: calc(var(--size) * 3 / 240);
        border-radius: 999px;
        background: #f0a0a8;
      }
      .cancel_request_doc::before { top: 31%; box-shadow: 0 calc(var(--size) * 11 / 240) 0 #f0a0a8; }
      .cancel_request_doc::after { bottom: 18%; width: 35%; }
      .cancel_request_text strong { display: block; margin-bottom: calc(var(--size) * 4 / 240); font-size: calc(var(--size) * 19 / 240); }
      .cancel_request_text span { display: block; color: #a95b62; font-size: calc(var(--size) * 12 / 240); font-weight: 700; line-height: 1.35; }
      
      /* 08. 자동결제 중단 ------------------------------------------------------ */
      .payment_stop_icon {
        --size: 150px;
        position: relative;
        width: var(--size);
        height: calc(var(--size) * 105 / 150);
        font-family: var(--font-sans);
      }
      .payment_stop_card {
        position: absolute;
        top: 12%; left: 5%;
        width: 90%; height: 70%;
        border-radius: calc(var(--size) * 12 / 150);
        background: linear-gradient(145deg, #98a5b8, #66758b);
        box-shadow: 0 calc(var(--size) * 7 / 150) calc(var(--size) * 14 / 150) rgba(31,41,55,.2);
      }
      .payment_stop_card::before { content: ''; position: absolute; top: 26%; left: 0; width: 100%; height: 16%; background: #3f4d61; }
      .payment_stop_card::after { content: ''; position: absolute; right: 10%; bottom: 16%; width: 25%; height: 12%; border-radius: 999px; background: #cbd3df; }
      .payment_stop_mark {
        position: absolute;
        top: 50%; left: 50%;
        width: 54%; height: 54%;
        border: calc(var(--size) * 7 / 150) solid var(--guide-red);
        border-radius: 50%;
        transform: translate(-50%, -50%);
      }
      .payment_stop_mark::after { content: ''; position: absolute; top: 50%; left: 50%; width: 116%; height: calc(var(--size) * 7 / 150); border-radius: 999px; background: var(--guide-red); transform: translate(-50%, -50%) rotate(-45deg); }
      
      /* 09. 경험 → 추천 → 비즈니스 ------------------------------------------- */
      .business_flow_card {
        --size: 390px;
        display: flex;
        align-items: center;
        width: var(--size);
        padding: calc(var(--size) * 18 / 390);
        border-radius: calc(var(--size) * 18 / 390);
        background: #fff;
        box-shadow: 0 calc(var(--size) * 8 / 390) calc(var(--size) * 24 / 390) rgba(31,41,55,.12);
        font-family: var(--font-sans);
      }
      .business_flow_step { flex: 0 0 calc(var(--size) * 94 / 390); text-align: center; }
      .business_flow_symbol {
        display: grid;
        place-items: center;
        width: calc(var(--size) * 54 / 390);
        height: calc(var(--size) * 54 / 390);
        margin: 0 auto calc(var(--size) * 8 / 390);
        border-radius: 50%;
        color: #fff;
        background: linear-gradient(145deg, var(--blue-500), var(--blue-700));
        box-shadow: 0 calc(var(--size) * 5 / 390) calc(var(--size) * 12 / 390) rgba(16,52,172,.2);
        font-size: calc(var(--size) * 22 / 390);
        font-weight: 900;
      }
      .business_flow_step:nth-child(3) .business_flow_symbol { background: linear-gradient(145deg, #35a76b, #087348); }
      .business_flow_step:nth-child(5) .business_flow_symbol { color: #665308; background: linear-gradient(145deg, #ffe77a, #fdd503); }
      .business_flow_label { font-size: calc(var(--size) * 14 / 390); font-weight: 900; white-space: nowrap; }
      .business_flow_arrow { position: relative; height: calc(var(--size) * 4 / 390); flex: 1; border-radius: 999px; background: #c7d1e2; }
      .business_flow_arrow::after { content: ''; position: absolute; top: 50%; right: 0; border-top: calc(var(--size) * 6 / 390) solid transparent; border-bottom: calc(var(--size) * 6 / 390) solid transparent; border-left: calc(var(--size) * 9 / 390) solid #9aa8be; transform: translate(40%, -50%); }
      
      /* 10. 시스템 프레임 ------------------------------------------------------ */
      .subscription_system_frame {
        --size: 430px;
        width: var(--size);
        padding: calc(var(--size) * 22 / 430);
        border: calc(var(--size) * 3 / 430) solid transparent;
        border-radius: calc(var(--size) * 24 / 430);
        background: linear-gradient(#fff, #fff) padding-box, linear-gradient(120deg, #2c51ca, #8c64ef, #ee3338) border-box;
        box-shadow: 0 calc(var(--size) * 10 / 430) calc(var(--size) * 28 / 430) rgba(31,41,55,.12);
        font-family: var(--font-sans);
      }
      .subscription_system_title { margin-bottom: calc(var(--size) * 13 / 430); color: var(--blue-900); font-size: calc(var(--size) * 19 / 430); font-weight: 900; text-align: center; }
      .subscription_system_body { padding: calc(var(--size) * 14 / 430); border-radius: calc(var(--size) * 15 / 430); background: linear-gradient(145deg, #f7f9ff, #fff5f6); color: var(--muted); font-size: calc(var(--size) * 13 / 430); font-weight: 700; text-align: center; }
      
      /* 11. 시뮬레이션 화면 ---------------------------------------------------- */
      .simulation_screen {
        --size: 390px;
        width: var(--size);
        font-family: var(--font-sans);
      }
      .simulation_monitor {
        padding: calc(var(--size) * 12 / 390);
        border-radius: calc(var(--size) * 18 / 390);
        background: linear-gradient(145deg, #34435a, #1d293b);
        box-shadow: 0 calc(var(--size) * 12 / 390) calc(var(--size) * 26 / 390) rgba(16,24,40,.25);
      }
      .simulation_view {
        padding: calc(var(--size) * 18 / 390);
        border-radius: calc(var(--size) * 10 / 390);
        background: linear-gradient(145deg, #f7f9ff, #fff);
      }
      .simulation_header { margin-bottom: calc(var(--size) * 14 / 390); color: var(--blue-900); font-size: calc(var(--size) * 17 / 390); font-weight: 900; }
      .simulation_steps { display: grid; grid-template-columns: repeat(3, 1fr); gap: calc(var(--size) * 8 / 390); }
      .simulation_step {
        min-height: calc(var(--size) * 73 / 390);
        display: grid;
        place-items: center;
        padding: calc(var(--size) * 8 / 390);
        border-radius: calc(var(--size) * 11 / 390);
        color: #445168;
        background: #fff;
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 390) #dfe6f2;
        font-size: calc(var(--size) * 12 / 390);
        font-weight: 800;
        line-height: 1.3;
        text-align: center;
      }
      .simulation_cta {
        display: block;
        width: 100%;
        margin-top: calc(var(--size) * 14 / 390);
        padding: calc(var(--size) * 12 / 390);
        border: 0;
        border-radius: calc(var(--size) * 10 / 390);
        color: #fff;
        background: linear-gradient(120deg, #2c51ca, #1034ac, #462db3);
        box-shadow: inset 0 0 0 calc(var(--size) * 2 / 390) #0b2a91;
        font-family: inherit;
        font-size: calc(var(--size) * 15 / 390);
        font-weight: 900;
      }
      .simulation_stand { width: 30%; height: calc(var(--size) * 18 / 390); margin: 0 auto; background: linear-gradient(90deg, #728096, #aeb8c8, #728096); clip-path: polygon(35% 0,65% 0,78% 100%,22% 100%); }
      .simulation_base { width: 48%; height: calc(var(--size) * 8 / 390); margin: 0 auto; border-radius: 999px 999px 0 0; background: #4a596e; }
      
      /* 12. CSS 커서 ----------------------------------------------------------- */
      .cursor_click_icon {
        --size: 72px;
        position: relative;
        width: var(--size);
        height: var(--size);
      }
      .cursor_click_pointer {
        position: absolute;
        top: 12%; left: 18%;
        width: 0; height: 0;
        border-top: calc(var(--size) * 52 / 72) solid #fff;
        border-right: calc(var(--size) * 31 / 72) solid transparent;
        filter: drop-shadow(0 calc(var(--size) * 2 / 72) calc(var(--size) * 2 / 72) rgba(0,0,0,.45));
        transform: rotate(-12deg);
      }
      .cursor_click_pointer::after {
        content: '';
        position: absolute;
        top: calc(var(--size) * -49 / 72);
        left: calc(var(--size) * 2 / 72);
        width: calc(var(--size) * 18 / 72);
        height: calc(var(--size) * 4 / 72);
        border-radius: 999px;
        background: #202938;
        transform: rotate(63deg);
        transform-origin: left center;
      }
      .cursor_click_ray { position: absolute; width: calc(var(--size) * 13 / 72); height: calc(var(--size) * 3 / 72); border-radius: 999px; background: var(--guide-red); }
      .cursor_click_ray.is_1 { top: 3%; left: 52%; transform: rotate(-68deg); }
      .cursor_click_ray.is_2 { top: 19%; right: 2%; transform: rotate(-10deg); }
      .cursor_click_ray.is_3 { top: 43%; right: 8%; transform: rotate(40deg); }
      
      @media (max-width: 640px) {
        body { padding: 24px 14px 50px; }
        .asset_section { padding: 18px; }
        .subscription_flow_card { --size: 290px; }
        .business_flow_card { --size: 310px; }
        .subscription_system_frame { --size: 310px; }
        .simulation_screen { --size: 310px; }
      }
      </style>
      </head>
      <body>
      <main class="asset_showcase">
        <header class="asset_showcase_header">
          <h1>GUIDE01 신규 에셋 시안</h1>
          <p>기존 12종 SUB ASSET과 기존 배지·지위·유닛은 제외했습니다.<br>각 루트 클래스는 독립적으로 복사할 수 있고, <strong>--size</strong> 값만 변경하면 내부 요소가 같은 비율로 확대·축소됩니다.</p>
        </header>
      
        <section class="asset_section">
          <h2 class="asset_section_title">공통 뱃지·자동 갱신</h2>
          <div class="asset_grid">
            <article class="asset_preview">
              <p class="asset_preview_name">guide_info_badge — 문구 교체형 공통 뱃지</p>
              <div class="asset_preview_body" style="flex-direction:column">
                <div class="guide_info_badge" role="img" aria-label="자동 연장"><span class="guide_info_badge_label">R</span><span class="guide_info_badge_text">자동 연장</span></div>
                <div class="guide_info_badge is_green" role="img" aria-label="다른 상품 추가 가능"><span class="guide_info_badge_label">+</span><span class="guide_info_badge_text">다른 상품 추가 가능</span></div>
                <div class="guide_info_badge is_red" role="img" aria-label="상품 변경 불가"><span class="guide_info_badge_label">!</span><span class="guide_info_badge_text">상품 변경 불가</span></div>
              </div>
            </article>
            <article class="asset_preview">
              <p class="asset_preview_name">auto_renewal_icon — 3개월 자동 갱신</p>
              <div class="asset_preview_body">
                <div class="auto_renewal_icon" role="img" aria-label="3개월 자동 갱신">
                  <div class="auto_renewal_ring"></div><div class="auto_renewal_arrow"></div><div class="auto_renewal_center">3개월<br>자동 갱신</div>
                </div>
              </div>
            </article>
          </div>
        </section>
      
        <section class="asset_section">
          <h2 class="asset_section_title">기간·추천포인트 기준</h2>
          <div class="asset_grid">
            <article class="asset_preview">
              <p class="asset_preview_name">subscription_flow_card — 4개월 차 자동 연장</p>
              <div class="asset_preview_body">
                <div class="subscription_flow_card" role="img" aria-label="1개월 차부터 4개월 차 자동 연장 흐름">
                  <div class="subscription_flow_title">3개월 구독 후 자동 연장</div>
                  <div class="subscription_flow_track">
                    <div class="subscription_flow_month">1개월</div><div class="subscription_flow_line"></div>
                    <div class="subscription_flow_month">2개월</div><div class="subscription_flow_line"></div>
                    <div class="subscription_flow_month">3개월</div><div class="subscription_flow_line is_renew"></div>
                    <div class="subscription_flow_month is_next">4개월</div>
                  </div>
                </div>
              </div>
            </article>
            <article class="asset_preview">
              <p class="asset_preview_name">member_basis_card — 회원 1인 기준</p>
              <div class="asset_preview_body">
                <div class="member_basis_card" role="img" aria-label="추천포인트는 회원 1인당 매월 1포인트">
                  <div class="member_basis_person"></div>
                  <div class="member_basis_point">매월 1Point</div>
                  <div class="member_basis_caption">상품 수가 아닌 회원 1인 기준</div>
                </div>
              </div>
            </article>
            <article class="asset_preview">
              <p class="asset_preview_name">group_bracket — 여러 상품 그룹 표시</p>
              <div class="asset_preview_body">
                <div class="group_bracket" role="img" aria-label="여러 상품 구독 그룹">
                  <div class="group_bracket_line"></div><div class="group_bracket_label">여러 상품 구독</div>
                </div>
              </div>
            </article>
          </div>
        </section>
      
        <section class="asset_section">
          <h2 class="asset_section_title">상품 변경·해지</h2>
          <div class="asset_grid">
            <article class="asset_preview">
              <p class="asset_preview_name">product_swap_icon — 상품 변경 불가</p>
              <div class="asset_preview_body">
                <div class="product_swap_icon" role="img" aria-label="구독 중 상품 변경 불가">
                  <div class="product_swap_box">A</div>
                  <div class="product_swap_arrows"><div class="product_swap_block"></div></div>
                  <div class="product_swap_box">B</div>
                </div>
              </div>
            </article>
            <article class="asset_preview">
              <p class="asset_preview_name">cancel_request_card — 해지 신청</p>
              <div class="asset_preview_body">
                <div class="cancel_request_card" role="img" aria-label="오토십 해지 신청">
                  <div class="cancel_request_doc"></div>
                  <div class="cancel_request_text"><strong>해지 신청</strong><span>현재 3개월 구독은 유지</span></div>
                </div>
              </div>
            </article>
            <article class="asset_preview">
              <p class="asset_preview_name">payment_stop_icon — 다음 자동결제 중단</p>
              <div class="asset_preview_body">
                <div class="payment_stop_icon" role="img" aria-label="4개월 차 자동결제 중단">
                  <div class="payment_stop_card"></div><div class="payment_stop_mark"></div>
                </div>
              </div>
            </article>
          </div>
        </section>
      
        <section class="asset_section">
          <h2 class="asset_section_title">핵심 요약·시뮬레이션 연결</h2>
          <div class="asset_grid">
            <article class="asset_preview" style="grid-column:1/-1">
              <p class="asset_preview_name">business_flow_card — 제품 경험에서 비즈니스까지</p>
              <div class="asset_preview_body">
                <div class="business_flow_card" role="img" aria-label="제품 경험이 추천 활동과 비즈니스로 연결">
                  <div class="business_flow_step"><div class="business_flow_symbol">P</div><div class="business_flow_label">제품 경험</div></div>
                  <div class="business_flow_arrow"></div>
                  <div class="business_flow_step"><div class="business_flow_symbol">R</div><div class="business_flow_label">추천 활동</div></div>
                  <div class="business_flow_arrow"></div>
                  <div class="business_flow_step"><div class="business_flow_symbol">B</div><div class="business_flow_label">비즈니스</div></div>
                </div>
              </div>
            </article>
            <article class="asset_preview" style="grid-column:1/-1">
              <p class="asset_preview_name">subscription_system_frame — 앨트웰 정기 구독 시스템</p>
              <div class="asset_preview_body">
                <div class="subscription_system_frame" role="group" aria-label="앨트웰 정기 구독 시스템">
                  <div class="subscription_system_title">앨트웰 정기 구독 시스템</div>
                  <div class="subscription_system_body">이 영역에 기존 오토십·할인·추천·BASE사업자 에셋 그룹을 배치합니다.</div>
                </div>
              </div>
            </article>
            <article class="asset_preview" style="grid-column:1/-1">
              <p class="asset_preview_name">simulation_screen + cursor_click_icon — 다음 시뮬레이션</p>
              <div class="asset_preview_body" style="position:relative">
                <div class="simulation_screen" role="img" aria-label="오토십 시뮬레이션 화면">
                  <div class="simulation_monitor">
                    <div class="simulation_view">
                      <div class="simulation_header">오토십 시뮬레이션</div>
                      <div class="simulation_steps">
                        <div class="simulation_step">상품 선택</div>
                        <div class="simulation_step">3개월 구독</div>
                        <div class="simulation_step">E.P·포인트<br>확인</div>
                      </div>
                      <button type="button" class="simulation_cta">시뮬레이션 시작</button>
                    </div>
                  </div>
                  <div class="simulation_stand"></div><div class="simulation_base"></div>
                </div>
                <div class="cursor_click_icon" role="img" aria-label="클릭" style="position:absolute;left:62%;bottom:17%">
                  <div class="cursor_click_pointer"></div><i class="cursor_click_ray is_1"></i><i class="cursor_click_ray is_2"></i><i class="cursor_click_ray is_3"></i>
                </div>
              </div>
            </article>
          </div>
        </section>
      </main>
      
      
    
  </section>



  <section class="g01-anim-section">

    <h2>G01 ZONED ANIMATION</h2>

    <p class="g01-anim-intro">guide01_smartguide.asp에서 사용하는 7×7 존 에셋 Motion Component 미리보기 · <code>asset_animation_rull.md</code> 규칙 기반</p>

    <div class="g01-anim-card">

      <div class="g01-anim-stage-wrap">

        <div class="g01-anim-stage-outer">

          <div id="g01-anim-canvas" class="guide01-canvas g01-anim-stage" aria-label="G01 애니메이션 미리보기 캔버스"></div>

        </div>

        <p id="g01-anim-status" class="g01-anim-status">버튼을 눌러 Motion Component를 확인하세요.</p>

      </div>

      <div class="g01-anim-controls">

        <button type="button" class="g01-anim-btn" data-g01-anim="enterFade">Enter Fade<br><span>g01.zoned.enterFade</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="enterPop">Enter Pop<br><span>g01.zoned.enterPop</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="enterDrop">Enter Drop<br><span>g01.zoned.enterDrop</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="popScale">Pop Scale<br><span>g01.zoned.popScale</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="exit">Exit<br><span>g01.zoned.exit</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="idle">Idle Float<br><span>g01.zoned.idleStart/Stop</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="move">Move Zone<br><span>g01.zoned.move</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-accent" data-g01-anim="sequence">Sequence<br><span>등장→idle→퇴장</span></button>

        <p class="g01-anim-group-label">Badge Fold · _c ↔ _o</p>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeUnfoldAutoship">Unfold<br><span>오토십 구독</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeFoldAutoship">Fold<br><span>오토십 구독</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeUnfoldBase">Unfold<br><span>베이스 사업자</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeFoldBase">Fold<br><span>베이스 사업자</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeUnfoldRecommend">Unfold<br><span>추천 보너스</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeFoldRecommend">Fold<br><span>추천 보너스</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge g01-anim-btn-accent" data-g01-anim="badgeCycle">Cycle<br><span>펼침↔접힘 반복</span></button>

      </div>

    </div>

  </section>

</div>

<link rel="stylesheet" href="_css/guide01.css"/>

<style>
.g01-anim-section{margin-top:16px;padding-top:8px;border-top:2px solid #e2e8f0}
.g01-anim-intro{font-size:13px;color:#64748b;margin:-8px 0 20px;line-height:1.5}
.g01-anim-intro code{font-size:12px;background:#f1f5f9;padding:2px 6px;border-radius:4px}
.g01-anim-card{display:flex;flex-wrap:wrap;gap:28px;align-items:flex-start}
.g01-anim-stage-wrap{
  display:flex;
  flex-direction:column;
  gap:8px;
  flex:0 0 420px;
  width:420px;
  max-width:100%;
}
.g01-anim-stage-outer{
  flex-shrink:0;
  width:420px;
  height:315px;
  max-width:100%;
  box-sizing:border-box;
  padding:14px;
  border:1px solid #dbeafe;
  border-radius:12px;
  background:linear-gradient(160deg,#f8fafc 0%,#eef2ff 100%);
  box-shadow:0 4px 16px rgba(30,90,180,.08);
  overflow:visible;
}
.g01-anim-stage{
  width:100%;
  height:100%;
  position:relative;
  overflow:visible;
  box-sizing:border-box;
}
.g01-anim-stage .g01-zone-wrap{
  overflow:visible;
}
@media(max-width:480px){
  .g01-anim-stage-wrap{width:100%;flex-basis:100%}
  .g01-anim-stage-outer{width:100%;height:auto;aspect-ratio:4/3}
}
.g01-anim-status{font-size:12px;color:#64748b;min-height:18px;margin:0}
.g01-anim-controls{display:flex;flex-wrap:wrap;gap:10px;max-width:520px}
.g01-anim-btn{
  min-width:108px;
  padding:10px 12px;
  border:1px solid #cbd5e1;
  border-radius:10px;
  background:#fff;
  font-size:12px;
  font-weight:700;
  color:#1e293b;
  cursor:pointer;
  line-height:1.35;
  transition:background .15s,border-color .15s,transform .1s;
}
.g01-anim-btn span{display:block;font-size:10px;font-weight:500;color:#64748b;margin-top:4px;font-family:Consolas,monospace}
.g01-anim-btn:hover{background:#f8fafc;border-color:#93c5fd}
.g01-anim-btn:active{transform:scale(.97)}
.g01-anim-btn-accent{border-color:#3b82f6;background:#eff6ff}
.g01-anim-group-label{
  flex-basis:100%;
  margin:12px 0 0;
  padding-top:12px;
  border-top:1px dashed #cbd5e1;
  font-size:11px;
  font-weight:700;
  color:#64748b;
  letter-spacing:.06em;
}
.g01-anim-btn-badge{border-color:#c4b5fd;background:#faf5ff}
.g01-anim-btn-badge:hover{border-color:#8b5cf6;background:#f3e8ff}
</style>

<!--#include file="includes/components/guide01_templates.asp"-->
<!--#include file="includes/images.asp"-->
<!--#include file="includes/motion.js.asp"-->
<!--#include file="includes/motions/core/motionComponent.js.asp"-->
<!--#include file="includes/motions/g01/_load.asp"-->
<!--#include file="includes/motions/g01/preview.js.asp"-->

<script>G01AnimPreview.init();</script>

</body>

</html>

