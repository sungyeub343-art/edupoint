$ErrorActionPreference = 'Stop'
$baseUrl = 'https://edupoint.kr'
$areas = @(
  @{ Name='강남구'; Slug='gangnam-gu'; Neighborhoods='대치동, 도곡동, 개포동, 압구정동' },
  @{ Name='강동구'; Slug='gangdong-gu'; Neighborhoods='명일동, 고덕동, 암사동, 천호동' },
  @{ Name='강북구'; Slug='gangbuk-gu'; Neighborhoods='미아동, 번동, 수유동, 우이동' },
  @{ Name='강서구'; Slug='gangseo-gu'; Neighborhoods='화곡동, 마곡동, 등촌동, 방화동' },
  @{ Name='관악구'; Slug='gwanak-gu'; Neighborhoods='봉천동, 신림동, 남현동' },
  @{ Name='광진구'; Slug='gwangjin-gu'; Neighborhoods='광장동, 구의동, 자양동, 중곡동' },
  @{ Name='구로구'; Slug='guro-gu'; Neighborhoods='구로동, 개봉동, 고척동, 오류동' },
  @{ Name='금천구'; Slug='geumcheon-gu'; Neighborhoods='가산동, 독산동, 시흥동' },
  @{ Name='노원구'; Slug='nowon-gu'; Neighborhoods='중계동, 상계동, 월계동, 공릉동' },
  @{ Name='도봉구'; Slug='dobong-gu'; Neighborhoods='창동, 방학동, 쌍문동, 도봉동' },
  @{ Name='동대문구'; Slug='dongdaemun-gu'; Neighborhoods='전농동, 답십리동, 장안동, 이문동' },
  @{ Name='동작구'; Slug='dongjak-gu'; Neighborhoods='상도동, 흑석동, 사당동, 대방동' },
  @{ Name='마포구'; Slug='mapo-gu'; Neighborhoods='아현동, 공덕동, 상암동, 망원동' },
  @{ Name='서대문구'; Slug='seodaemun-gu'; Neighborhoods='북가좌동, 홍제동, 연희동, 충정로' },
  @{ Name='서초구'; Slug='seocho-gu'; Neighborhoods='반포동, 방배동, 잠원동, 양재동' },
  @{ Name='성동구'; Slug='seongdong-gu'; Neighborhoods='옥수동, 금호동, 행당동, 성수동' },
  @{ Name='성북구'; Slug='seongbuk-gu'; Neighborhoods='길음동, 돈암동, 정릉동, 석관동' },
  @{ Name='송파구'; Slug='songpa-gu'; Neighborhoods='잠실동, 문정동, 방이동, 가락동' },
  @{ Name='양천구'; Slug='yangcheon-gu'; Neighborhoods='목동, 신정동, 신월동' },
  @{ Name='영등포구'; Slug='yeongdeungpo-gu'; Neighborhoods='여의도동, 당산동, 문래동, 신길동' },
  @{ Name='용산구'; Slug='yongsan-gu'; Neighborhoods='이촌동, 한남동, 후암동, 효창동' },
  @{ Name='은평구'; Slug='eunpyeong-gu'; Neighborhoods='불광동, 응암동, 진관동, 역촌동' },
  @{ Name='종로구'; Slug='jongno-gu'; Neighborhoods='평창동, 무악동, 혜화동, 창신동' },
  @{ Name='중구'; Slug='jung-gu'; Neighborhoods='신당동, 약수동, 황학동, 회현동' },
  @{ Name='중랑구'; Slug='jungnang-gu'; Neighborhoods='신내동, 면목동, 묵동, 상봉동' }
)

$template = @'
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{NAME}} 수학과외 | 예비중·예비고 1:1 맞춤 수업</title>
  <meta name="description" content="서울 {{NAME}} 초중고 1:1 수학과외. 예비중1, 예비중2, 예비중3, 예비고1, 예비고2, 예비고3 학생의 내신과 수능 학습을 맞춤 설계합니다.">
  <meta name="theme-color" content="#16332d">
  <meta property="og:type" content="website">
  <meta property="og:title" content="{{NAME}} 수학과외">
  <meta property="og:description" content="{{NAME}} 학생을 위한 학년별 1:1 맞춤 수학 수업">
  <meta property="og:url" content="{{URL}}">
  <link rel="canonical" href="{{URL}}">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@700&amp;family=Noto+Sans+KR:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
  <link rel="stylesheet" href="../../styles.css">
  <script src="../../script.js" defer></script>
</head>
<body>
  <a class="skip-link" href="#main">본문으로 바로가기</a>
  <header class="site-header sub-header">
    <a class="brand" href="../../" aria-label="서울 수학과외 홈"><span class="brand-mark" aria-hidden="true">Σ</span><span>서울 수학과외</span></a>
    <nav class="desktop-nav" aria-label="주요 메뉴"><a href="../../#approach">수업 방식</a><a href="../../#program">학년별 수업</a><a href="../../#areas">지역 안내</a></nav>
    <a class="header-cta" href="../../#contact">상담 신청</a>
  </header>
  <main id="main">
    <section class="area-hero">
      <p class="breadcrumb"><a href="../../">서울 수학과외</a> / {{NAME}}</p>
      <p class="eyebrow">{{NAME}} · PERSONAL MATH TUTORING</p>
      <h1>{{NAME}} 수학과외</h1>
      <p class="hero-copy">학교 진도와 현재 실력을 함께 살펴, 학생에게 필요한 순서로 수학 공부를 설계합니다.</p>
    </section>
    <div class="area-main">
      <section class="area-intro" aria-labelledby="intro-title">
        <div><p class="section-number">01 / LOCAL CLASS</p><h2 id="intro-title">{{NAME}}에서 만나는<br>맞춤 수학 수업</h2></div>
        <div><p>{{NAME}} {{NEIGHBORHOODS}} 등 지역 학생의 학년과 학교 진도를 고려해 상담합니다. 최근 시험지와 오답, 공부 습관을 먼저 살펴 개념 보완과 내신 대비 중 어디에 집중할지 정합니다.</p><p>빠른 선행만을 목표로 하기보다 배운 내용을 스스로 설명하고 새로운 문제에 적용할 수 있도록 수업과 과제의 난이도를 조정합니다.</p></div>
      </section>
      <section class="grade-guide" aria-labelledby="grade-title">
        <p class="section-number">02 / GRADE GUIDE</p>
        <h2 id="grade-title">새 학년을 준비하는<br>단계별 학습</h2>
        <div class="grade-cards">
          <article class="grade-card"><span>MIDDLE 01</span><h3>예비중1</h3><p>초등 핵심 연산과 분수·비례를 점검하고 문자와 식의 기초를 준비합니다.</p></article>
          <article class="grade-card"><span>MIDDLE 02</span><h3>예비중2</h3><p>방정식과 함수의 빈틈을 보완하고 새 학년 내신 유형에 적응합니다.</p></article>
          <article class="grade-card"><span>MIDDLE 03</span><h3>예비중3</h3><p>식의 계산과 함수 이해를 단단히 해 고등 수학과 연결되는 기반을 만듭니다.</p></article>
          <article class="grade-card"><span>HIGH 01</span><h3>예비고1</h3><p>중학 전 과정의 핵심을 정리하고 고등수학의 빠른 진도에 대비합니다.</p></article>
          <article class="grade-card"><span>HIGH 02</span><h3>예비고2</h3><p>학교별 내신 범위와 선택 과목에 맞춰 개념과 문제 유형을 정리합니다.</p></article>
          <article class="grade-card"><span>HIGH 03</span><h3>예비고3</h3><p>목표 전형과 현재 등급을 바탕으로 수능 학습 순서와 실전 전략을 세웁니다.</p></article>
        </div>
      </section>
      <section class="area-cta">
        <h2>{{NAME}} 수학과외 상담</h2>
        <p>학생의 학년과 거주 지역, 현재 학습 고민을 알려주세요.</p>
        <a class="button" href="../../#contact">상담 내용 작성하기</a>
      </section>
    </div>
  </main>
  <footer class="area-footer"><a class="brand footer-brand" href="../../"><span class="brand-mark" aria-hidden="true">Σ</span><span>서울 수학과외</span></a><p>© <span id="year"></span> 서울 수학과외</p></footer>
</body>
</html>
'@

$areasRoot = Join-Path $PSScriptRoot 'areas'
New-Item -ItemType Directory -Path $areasRoot -Force | Out-Null
foreach ($area in $areas) {
  $directory = Join-Path $areasRoot $area.Slug
  New-Item -ItemType Directory -Path $directory -Force | Out-Null
  $url = "$baseUrl/areas/$($area.Slug)/"
  $html = $template.Replace('{{NAME}}', $area.Name).Replace('{{NEIGHBORHOODS}}', $area.Neighborhoods).Replace('{{URL}}', $url)
  Set-Content -Path (Join-Path $directory 'index.html') -Value $html -Encoding utf8
}

$today = Get-Date -Format 'yyyy-MM-dd'
$urlEntries = @("  <url><loc>$baseUrl/</loc><lastmod>$today</lastmod><priority>1.0</priority></url>")
$urlEntries += $areas | ForEach-Object { "  <url><loc>$baseUrl/areas/$($_.Slug)/</loc><lastmod>$today</lastmod><priority>0.8</priority></url>" }
$sitemap = @("<?xml version=`"1.0`" encoding=`"UTF-8`"?>", '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">') + $urlEntries + '</urlset>'
Set-Content -Path (Join-Path $PSScriptRoot 'sitemap.xml') -Value $sitemap -Encoding utf8

Write-Host "Generated $($areas.Count) district pages and sitemap.xml"