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

.lev_container,.badge_container{display:flex;flex-wrap:wrap;gap:24px;align-items:center}

</style>

</head>

<body class="page-layout">



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

</div>



</body>

</html>

