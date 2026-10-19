$ErrorActionPreference = 'Stop'
$baseUrl = 'https://edupoint.kr'
$assetVersion = '20261019-5'
$phone = '010-2928-3614'
$tel = '01029283614'
$today = Get-Date -Format 'yyyy-MM-dd'
$utf8 = New-Object System.Text.UTF8Encoding $false

$areas = @(
  @{ Name='강남구'; Slug='gangnam-gu'; Neighborhoods='대치동, 도곡동, 개포동, 압구정동'; Nearby='seocho-gu, songpa-gu, seongdong-gu' },
  @{ Name='강동구'; Slug='gangdong-gu'; Neighborhoods='명일동, 고덕동, 암사동, 천호동'; Nearby='songpa-gu, gwangjin-gu, gangnam-gu' },
  @{ Name='강북구'; Slug='gangbuk-gu'; Neighborhoods='미아동, 번동, 수유동, 우이동'; Nearby='dobong-gu, nowon-gu, seongbuk-gu' },
  @{ Name='강서구'; Slug='gangseo-gu'; Neighborhoods='화곡동, 마곡동, 등촌동, 방화동'; Nearby='yangcheon-gu, yeongdeungpo-gu, mapo-gu' },
  @{ Name='관악구'; Slug='gwanak-gu'; Neighborhoods='봉천동, 신림동, 남현동'; Nearby='dongjak-gu, geumcheon-gu, seocho-gu' },
  @{ Name='광진구'; Slug='gwangjin-gu'; Neighborhoods='광장동, 구의동, 자양동, 중곡동'; Nearby='seongdong-gu, dongdaemun-gu, songpa-gu' },
  @{ Name='구로구'; Slug='guro-gu'; Neighborhoods='구로동, 개봉동, 고척동, 오류동'; Nearby='yangcheon-gu, geumcheon-gu, yeongdeungpo-gu' },
  @{ Name='금천구'; Slug='geumcheon-gu'; Neighborhoods='가산동, 독산동, 시흥동'; Nearby='guro-gu, gwanak-gu, yeongdeungpo-gu' },
  @{ Name='노원구'; Slug='nowon-gu'; Neighborhoods='중계동, 상계동, 월계동, 공릉동'; Nearby='dobong-gu, jungnang-gu, gangbuk-gu' },
  @{ Name='도봉구'; Slug='dobong-gu'; Neighborhoods='창동, 방학동, 쌍문동, 도봉동'; Nearby='nowon-gu, gangbuk-gu, seongbuk-gu' },
  @{ Name='동대문구'; Slug='dongdaemun-gu'; Neighborhoods='전농동, 답십리동, 장안동, 이문동'; Nearby='seongbuk-gu, jungnang-gu, seongdong-gu' },
  @{ Name='동작구'; Slug='dongjak-gu'; Neighborhoods='상도동, 흑석동, 사당동, 대방동'; Nearby='gwanak-gu, seocho-gu, yeongdeungpo-gu' },
  @{ Name='마포구'; Slug='mapo-gu'; Neighborhoods='아현동, 공덕동, 상암동, 망원동'; Nearby='seodaemun-gu, yongsan-gu, yeongdeungpo-gu' },
  @{ Name='서대문구'; Slug='seodaemun-gu'; Neighborhoods='북가좌동, 홍제동, 연희동, 충정로'; Nearby='mapo-gu, eunpyeong-gu, jongno-gu' },
  @{ Name='서초구'; Slug='seocho-gu'; Neighborhoods='반포동, 방배동, 잠원동, 양재동'; Nearby='gangnam-gu, dongjak-gu, gwanak-gu' },
  @{ Name='성동구'; Slug='seongdong-gu'; Neighborhoods='옥수동, 금호동, 행당동, 성수동'; Nearby='gwangjin-gu, dongdaemun-gu, jung-gu' },
  @{ Name='성북구'; Slug='seongbuk-gu'; Neighborhoods='길음동, 돈암동, 정릉동, 석관동'; Nearby='jongno-gu, dongdaemun-gu, gangbuk-gu' },
  @{ Name='송파구'; Slug='songpa-gu'; Neighborhoods='잠실동, 문정동, 방이동, 가락동'; Nearby='gangnam-gu, gangdong-gu, gwangjin-gu' },
  @{ Name='양천구'; Slug='yangcheon-gu'; Neighborhoods='목동, 신정동, 신월동'; Nearby='gangseo-gu, guro-gu, yeongdeungpo-gu' },
  @{ Name='영등포구'; Slug='yeongdeungpo-gu'; Neighborhoods='여의도동, 당산동, 문래동, 신길동'; Nearby='yangcheon-gu, dongjak-gu, mapo-gu' },
  @{ Name='용산구'; Slug='yongsan-gu'; Neighborhoods='이촌동, 한남동, 후암동, 효창동'; Nearby='jung-gu, mapo-gu, dongjak-gu' },
  @{ Name='은평구'; Slug='eunpyeong-gu'; Neighborhoods='불광동, 응암동, 진관동, 역촌동'; Nearby='seodaemun-gu, jongno-gu, mapo-gu' },
  @{ Name='종로구'; Slug='jongno-gu'; Neighborhoods='평창동, 무악동, 혜화동, 창신동'; Nearby='jung-gu, seodaemun-gu, seongbuk-gu' },
  @{ Name='중구'; Slug='jung-gu'; Neighborhoods='신당동, 약수동, 황학동, 회현동'; Nearby='jongno-gu, yongsan-gu, seongdong-gu' },
  @{ Name='중랑구'; Slug='jungnang-gu'; Neighborhoods='신내동, 면목동, 묵동, 상봉동'; Nearby='dongdaemun-gu, nowon-gu, gwangjin-gu' }
)
$areaBySlug = @{}
foreach ($area in $areas) { $areaBySlug[$area.Slug] = $area }

# 학교급별 콘텐츠. {D}는 지역명, {N}은 대표 동네로 치환된다.
# Intros는 지역마다 다른 문장을 고르도록 여러 개를 둔다(유사문서 방지).
$levels = [ordered]@{
  elementary = @{
    Key = 'elementary'; Label = '초등'; English = 'ELEMENTARY'; Student = '초등학생'
    Title = '{D} 초등 수학과외 | 초등 기초수학·수학공부 1:1 수업'
    Description = '{D} 초등 수학과외. {N} 초등학생의 초등 수학수업, 수학공부 습관, 기초수학 연산까지 1:1로 진단하고 맞춤 수업을 설계합니다. 상담 010-2928-3614'
    Summary = '연산 습관과 개념 이해를 함께 잡아 중학교 수학까지 이어지는 기초를 만듭니다.'
    Hero = '{D} 초등학생의 연산 습관과 개념 이해를 함께 살펴, 중학교 수학까지 이어지는 기초를 만듭니다.'
    Chips = @('초등 수학', '초등 수학수업', '초등 수학공부', '초등 기초수학')
    Intros = @(
      '{N} 등 {D} 초등학생은 학교 진도와 문제집 진도가 서로 다른 경우가 많습니다. 초등 수학수업은 현재 학년 교과서 개념을 먼저 확인하고, 틀린 문제의 원인이 연산인지 문제 이해인지 구분하는 것에서 시작합니다.',
      '초등 수학은 정답 개수보다 풀이 과정이 더 많은 것을 알려줍니다. {N} 등 {D} 지역 학생의 최근 단원평가와 문제집을 살펴, 어떤 개념에서 막히는지 먼저 찾습니다.',
      '{D} 초등 수학과외는 아이가 수학을 어렵게 느끼기 시작한 지점을 찾는 데서 출발합니다. {N} 등 가까운 지역 학생의 학년과 학습 습관에 맞춰 수업 속도를 정합니다.'
    )
    Body = '기초수학이 부족한 학생은 연산과 수 감각을 다시 다지고, 이해가 빠른 학생은 서술형과 응용 문제로 생각을 넓힙니다. 수업마다 배운 내용을 정리해 집에서도 이어서 공부할 수 있도록 안내합니다.'
    Topics = @(
      @{ Title = '초등 수학수업'; Text = '교과서 개념을 그림과 말로 설명하게 하며, 아이가 이해한 내용을 직접 확인합니다.' },
      @{ Title = '초등 수학공부'; Text = '하루 공부 분량과 오답 정리 방법을 정해 스스로 공부하는 습관을 만듭니다.' },
      @{ Title = '초등 기초수학'; Text = '사칙연산, 분수와 소수, 도형 기초처럼 다음 학년에 꼭 필요한 부분을 우선 보완합니다.' },
      @{ Title = '초등 서술형·응용'; Text = '문제를 읽고 조건을 정리하는 연습으로 응용 문제와 서술형 문제에 대비합니다.' }
    )
    Grades = @(
      @{ Code = 'GRADE 1-2'; Name = '초1·초2'; Text = '수 세기와 덧셈·뺄셈, 시계와 길이처럼 수 감각의 기초를 구체물과 그림으로 익힙니다.' },
      @{ Code = 'GRADE 3-4'; Name = '초3·초4'; Text = '곱셈·나눗셈과 분수 개념이 본격적으로 등장하는 시기라 연산 정확도와 개념 이해를 함께 잡습니다.' },
      @{ Code = 'GRADE 5-6'; Name = '초5·초6'; Text = '분수·소수 연산, 비와 비율, 도형의 넓이와 부피를 정리하고 중학교 문자와 식을 준비합니다.' }
    )
    Faqs = @(
      @{ Q = '{D} 초등 수학과외는 몇 학년부터 가능한가요?'; A = '초등 저학년부터 상담할 수 있습니다. 학년보다 현재 이해 수준이 중요하므로 최근 학습 내용을 확인한 뒤 수업 방향을 정합니다.' },
      @{ Q = '기초수학이 많이 부족해도 수업을 받을 수 있나요?'; A = '네. 부족한 단원을 이전 학년 개념까지 거슬러 올라가 확인하고, 연산과 기본 개념부터 차근차근 다시 쌓습니다.' },
      @{ Q = '선행 학습도 함께 하나요?'; A = '현재 학년 개념을 충분히 이해한 경우 학생 속도에 맞춰 다음 학기 내용을 준비합니다. 빠른 진도보다 정확한 이해를 우선합니다.' }
    )
    Tags = @('초등 연산', '초등 서술형 수학', '초등 사고력 수학', '초등 수학 선행', '예비중1 수학', '초등 수학 개인과외')
  }
  middle = @{
    Key = 'middle'; Label = '중등'; English = 'MIDDLE SCHOOL'; Student = '중학생'
    Title = '{D} 중등 수학과외 | 중등 수학내신·기초수학 1:1 수업'
    Description = '{D} 중등 수학과외. {N} 중학생의 중등 수학내신, 기초수학, 서술형까지 중1·중2·중3 학년별 1:1 맞춤 수업으로 준비합니다. 상담 010-2928-3614'
    Summary = '학교 진도와 시험 범위에 맞춰 개념, 유형, 서술형까지 단계별로 준비합니다.'
    Hero = '{D} 중학생의 학교 진도와 시험 범위에 맞춰 개념, 유형, 서술형까지 단계별로 준비합니다.'
    Chips = @('중등 수학', '중등 수학수업', '중등 수학공부', '중등 기초수학', '중등 수학내신')
    Intros = @(
      '{N} 등 {D} 중학교는 학교마다 시험 범위와 서술형 비중이 다릅니다. 중등 수학수업은 학생의 학교 진도와 최근 시험지를 먼저 확인하고, 개념 보완과 내신 대비의 비중을 정합니다.',
      '중학교 수학은 한 단원의 빈틈이 다음 학년까지 이어지기 쉽습니다. {N} 등 {D} 지역 학생의 오답 패턴을 분석해 방정식, 함수, 도형 중 먼저 채워야 할 부분을 찾습니다.',
      '{D} 중등 수학과외는 어디서부터 막혔는지 확인하는 진단에서 시작합니다. {N} 등 가까운 지역 학생의 학교 일정에 맞춰 평소 수업과 시험 기간 수업을 다르게 설계합니다.'
    )
    Body = '기초수학이 부족한 학생은 이전 학년 개념부터 다시 정리하고, 상위권 학생은 고난도 유형과 서술형 감점 요인을 점검합니다. 스스로 풀이를 설명할 수 있을 때까지 확인해 시험장에서 흔들리지 않는 실력을 만듭니다.'
    Topics = @(
      @{ Title = '중등 수학수업'; Text = '개념 설명 후 학생이 직접 풀이를 말로 설명하게 하여 이해 여부를 확인합니다.' },
      @{ Title = '중등 수학공부'; Text = '주간 학습 계획과 오답 노트 작성법을 함께 정해 혼자 공부하는 시간을 효율적으로 만듭니다.' },
      @{ Title = '중등 기초수학'; Text = '정수와 유리수 계산, 문자와 식, 일차방정식처럼 중학 수학의 뼈대가 되는 단원을 먼저 보완합니다.' },
      @{ Title = '중등 수학내신'; Text = '학교별 시험 범위와 교과서, 기출 유형을 바탕으로 서술형까지 대비합니다.' }
    )
    Grades = @(
      @{ Code = 'MIDDLE 01'; Name = '중1'; Text = '정수와 유리수, 문자와 식, 일차방정식, 좌표평면과 그래프를 정리하며 중학 수학의 기본기를 만듭니다.' },
      @{ Code = 'MIDDLE 02'; Name = '중2'; Text = '식의 계산, 연립방정식, 일차함수, 도형의 성질과 확률을 다루며 내신 난도가 높아지는 시기에 대비합니다.' },
      @{ Code = 'MIDDLE 03'; Name = '중3'; Text = '제곱근과 실수, 인수분해, 이차방정식, 이차함수, 삼각비를 정리하고 고등 공통수학과 연결합니다.' }
    )
    Faqs = @(
      @{ Q = '{D} 중등 수학내신은 어떻게 준비하나요?'; A = '학생이 다니는 학교의 시험 범위와 교과서를 기준으로 개념을 정리하고, 시험 기간에는 유형 연습과 서술형 점검 비중을 높입니다.' },
      @{ Q = '중학생인데 기초가 부족하면 어디서부터 시작하나요?'; A = '진단을 통해 막힌 단원을 확인하고, 필요하면 이전 학년 개념까지 돌아가 연산과 기본 개념부터 다시 다집니다.' },
      @{ Q = '예비고1 준비도 가능한가요?'; A = '중3 과정의 핵심 개념을 정리한 뒤 고등 공통수학의 다항식, 방정식과 부등식 단원을 학생 속도에 맞춰 준비합니다.' }
    )
    Tags = @('중등 수학 선행', '중학 수학 서술형', '중간고사 수학 대비', '기말고사 수학 대비', '예비고1 수학', '중등 수학 개인과외')
  }
  high = @{
    Key = 'high'; Label = '고등'; English = 'HIGH SCHOOL'; Student = '고등학생'
    Title = '{D} 고등 수학과외 | 수능수학·수능대비·내신 1:1 수업'
    Description = '{D} 고등 수학과외. {N} 고등학생의 수학내신, 수능대비, 수능수학까지 고1·고2·고3 목표 등급에 맞춘 1:1 수업을 설계합니다. 상담 010-2928-3614'
    Summary = '현재 등급과 목표 전형을 바탕으로 내신과 수능 수학을 함께 설계합니다.'
    Hero = '{D} 고등학생의 내신 일정과 목표 전형, 현재 등급을 바탕으로 내신과 수능 수학을 함께 설계합니다.'
    Chips = @('고등 수학', '고등 수학수업', '고등 수학공부', '고등 기초수학', '고등 수학내신', '고등 수능대비', '고등 수능수학')
    Intros = @(
      '{N} 등 {D} 고등학교는 학교별로 교재와 출제 경향이 다르고, 내신과 수능 준비 시기가 겹칩니다. 고등 수학수업은 학생의 현재 등급과 목표 전형을 확인해 시기별 우선순위를 정합니다.',
      '고등 수학은 진도가 빠르고 범위가 넓어 한 번 놓친 개념을 혼자 메우기 어렵습니다. {N} 등 {D} 지역 학생의 내신 성적과 모의고사 결과를 함께 분석해 학습 순서를 다시 세웁니다.',
      '{D} 고등 수학과외는 내신과 수능 중 어느 한쪽만 보지 않습니다. {N} 등 가까운 지역 학생의 학교 일정과 모의고사 일정을 함께 고려해 학기 중과 방학 계획을 나누어 운영합니다.'
    )
    Body = '기초수학이 흔들리는 학생은 중학 개념과 공통수학의 기본부터 다시 연결하고, 상위권 학생은 고난도 문항과 시간 배분 전략을 훈련합니다. 풀이의 근거를 스스로 설명하도록 하여 새로운 유형에도 대응하는 힘을 기릅니다.'
    Topics = @(
      @{ Title = '고등 수학수업'; Text = '개념의 원리와 대표 유형을 연결해, 공식 암기가 아닌 이해 기반 풀이를 익힙니다.' },
      @{ Title = '고등 수학공부'; Text = '학기 중, 시험 기간, 방학별 학습 계획을 세우고 오답과 취약 단원을 꾸준히 관리합니다.' },
      @{ Title = '고등 기초수학'; Text = '고등 수학이 어려운 원인이 중학 개념에 있다면 해당 단원까지 돌아가 기초를 다시 다집니다.' },
      @{ Title = '고등 수학내신'; Text = '학교별 시험 범위, 부교재, 기출 경향을 분석해 서술형과 고난도 문항까지 준비합니다.' },
      @{ Title = '고등 수능대비'; Text = '모의고사 결과로 취약 단원과 시간 관리 문제를 파악하고, 목표 등급에 맞는 학습 순서를 정합니다.' },
      @{ Title = '고등 수능수학'; Text = '기출 문항 분석과 실전 연습으로 고난도 문항 대응력과 시험 운영 능력을 기릅니다.' }
    )
    Grades = @(
      @{ Code = 'HIGH 01'; Name = '고1'; Text = '공통수학1·2의 다항식, 방정식과 부등식, 도형의 방정식, 함수 등 고등 수학의 기본 개념을 정리하고 첫 내신에 대비합니다.' },
      @{ Code = 'HIGH 02'; Name = '고2'; Text = '학교별 과목 편성에 맞춰 대수, 미적분, 확률과 통계의 개념과 내신 유형을 정리하고 수능 기초를 함께 다집니다.' },
      @{ Code = 'HIGH 03'; Name = '고3'; Text = '목표 전형과 현재 등급을 기준으로 수능 기출 분석, 실전 모의고사 훈련, 남은 내신까지 시기별 전략을 세웁니다.' }
    )
    Faqs = @(
      @{ Q = '{D} 고등 수학과외는 내신과 수능 중 무엇에 집중하나요?'; A = '학생의 학년, 목표 전형, 현재 등급에 따라 다릅니다. 시험 기간에는 학교 내신에 집중하고, 그 외 기간에는 수능 기출과 개념 심화를 병행하도록 계획합니다.' },
      @{ Q = '고등학생인데 기초수학이 부족해도 괜찮을까요?'; A = '괜찮습니다. 진단 후 필요하면 중학 수학의 핵심 개념까지 돌아가 다시 연결하고, 현재 학교 진도와 병행할 수 있게 분량을 조절합니다.' },
      @{ Q = '수능 수학 대비는 언제부터 시작하는 것이 좋나요?'; A = '개념이 충분히 잡혀 있다면 고1부터 모의고사 유형을 함께 접하는 것이 도움이 됩니다. 학생마다 상황이 다르므로 상담을 통해 시기를 정합니다.' }
    )
    Tags = @('공통수학1·2', '대수', '미적분', '확률과 통계', '모의고사 수학 등급', '수능 수학 기출', '고등 수학 개인과외')
  }
}

$hubFaqs = @(
  @{ Q = '{D} 수학과외 상담은 어떻게 진행되나요?'; A = '전화로 학생의 학년, 학교, 현재 고민을 알려주시면 확인 후 연락드립니다. 최근 시험지나 사용 중인 교재가 있으면 더 정확하게 상담할 수 있습니다.' },
  @{ Q = '어떤 학년까지 수업이 가능한가요?'; A = '초등학생부터 중1~중3, 고1~고3까지 상담할 수 있습니다. 학년별 교육과정과 학생의 목표에 맞춰 수업 내용을 정합니다.' },
  @{ Q = '수업 횟수와 시간은 어떻게 정하나요?'; A = '학생의 학교 일정, 현재 실력, 목표에 따라 상담 후 함께 정합니다.' }
)
$hubIntros = @(
  '{D} {N} 등 지역 학생의 학년과 학교 진도를 고려해 상담합니다. 최근 시험지와 오답, 공부 습관을 먼저 살펴 개념 보완과 내신 대비 중 어디에 집중할지 정합니다.',
  '{N} 등 {D} 학생은 같은 학년이라도 학교 진도와 시험 유형이 다릅니다. 상담에서 최근 시험지와 오답, 공부 습관을 확인해 개념 보완과 내신 대비의 우선순위를 정합니다.',
  '{D} 수학과외는 학생의 현재 위치를 확인하는 것에서 시작합니다. {N} 등 가까운 지역 학생의 최근 시험지와 공부 습관을 살펴 지금 필요한 수업이 무엇인지 정합니다.'
)

$pages = New-Object System.Collections.ArrayList

function Fill([string]$text, [hashtable]$ctx) {
  $text.Replace('{D}', $ctx.D).Replace('{N}', $ctx.N)
}

function E([string]$text) {
  $text.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

function J([string]$text) {
  '"' + $text.Replace('\', '\\').Replace('"', '\"') + '"'
}

function Get-JsonLd($areaServed, $crumbs, $faqs) {
  $organization = '{"@type":"EducationalOrganization","@id":"' + $baseUrl + '/#organization","name":"서울 수학과외","url":"' + $baseUrl + '/","telephone":"+82-10-2928-3614","logo":"' + $baseUrl + '/apple-touch-icon.png","image":"' + $baseUrl + '/og-image.png","areaServed":{"@type":"AdministrativeArea","name":' + (J $areaServed) + '}}'
  $items = for ($i = 0; $i -lt $crumbs.Count; $i++) {
    '{"@type":"ListItem","position":' + ($i + 1) + ',"name":' + (J $crumbs[$i].Name) + ',"item":"' + $crumbs[$i].Url + '"}'
  }
  $breadcrumb = '{"@type":"BreadcrumbList","itemListElement":[' + ($items -join ',') + ']}'
  $questions = foreach ($faq in $faqs) {
    '{"@type":"Question","name":' + (J $faq.Q) + ',"acceptedAnswer":{"@type":"Answer","text":' + (J $faq.A) + '}}'
  }
  $faqPage = '{"@type":"FAQPage","mainEntity":[' + ($questions -join ',') + ']}'
  '{"@context":"https://schema.org","@graph":[' + $organization + ',' + $breadcrumb + ',' + $faqPage + ']}'
}

function Get-Breadcrumb($crumbs, [string]$prefix) {
  $links = for ($i = 0; $i -lt $crumbs.Count; $i++) {
    if ($i -eq $crumbs.Count - 1) { "<span aria-current=`"page`">$(E $crumbs[$i].Name)</span>" }
    else { "<a href=`"$prefix$($crumbs[$i].Path)`">$(E $crumbs[$i].Name)</a>" }
  }
  "<nav class=`"breadcrumb`" aria-label=`"현재 위치`">$($links -join ' / ')</nav>"
}

# 첫 방문 페이지에서 한 번 뜨는 지역 선택 창 (index.html과 같은 마크업)
function Get-RegionDialog([string]$prefix) {
  $links = for ($i = 0; $i -lt $areas.Count; $i++) {
    "        <a href=`"${prefix}areas/$($areas[$i].Slug)/`"><span>$('{0:D2}' -f ($i + 1))</span><strong>$($areas[$i].Name)</strong><i aria-hidden=`"true`">↗</i></a>"
  }
@"
  <dialog class="region-dialog" id="region-dialog" aria-labelledby="region-dialog-title" aria-describedby="region-dialog-description">
    <div class="region-dialog-inner">
      <button class="region-dialog-close" type="button" aria-label="지역 선택 창 닫기" data-region-dialog-close>
        <span aria-hidden="true"></span>
      </button>
      <p class="region-dialog-label">REGION SELECT</p>
      <p class="region-dialog-title" id="region-dialog-title">어느 지역의<br>수학과외를 찾으시나요?</p>
      <p id="region-dialog-description">자치구를 선택하면 해당 지역 안내로 바로 이동합니다.</p>
      <div class="region-dialog-grid" aria-label="서울 자치구 선택">
$($links -join "`n")
      </div>
    </div>
  </dialog>
"@
}

function Get-Page($meta, [string]$body) {
  $p = $meta.Prefix
@"
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$(E $meta.Title)</title>
  <meta name="description" content="$(E $meta.Description)">
  <meta name="robots" content="index, follow">
  <meta name="theme-color" content="#16332d">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="서울 수학과외">
  <meta property="og:locale" content="ko_KR">
  <meta property="og:title" content="$(E $meta.Title)">
  <meta property="og:description" content="$(E $meta.Description)">
  <meta property="og:url" content="$($meta.Url)">
  <meta property="og:image" content="$baseUrl/og-image.png">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta name="twitter:card" content="summary_large_image">
  <link rel="canonical" href="$($meta.Url)">
  <link rel="icon" href="${p}favicon.ico" sizes="any">
  <link rel="icon" type="image/png" href="${p}favicon.png">
  <link rel="apple-touch-icon" href="${p}apple-touch-icon.png">
  <link rel="alternate" type="application/rss+xml" title="서울 수학과외" href="$baseUrl/rss.xml">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@700&amp;family=Noto+Sans+KR:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${p}styles.css?v=$assetVersion">
  <script src="${p}script.js?v=$assetVersion" defer></script>
  <script type="application/ld+json">$($meta.JsonLd)</script>
</head>
<body>
  <a class="skip-link" href="#main">본문으로 바로가기</a>
$(Get-RegionDialog $p)
  <header class="site-header sub-header">
    <a class="brand" href="$p" aria-label="서울 수학과외 홈"><span class="brand-mark" aria-hidden="true">Σ</span><span>서울 수학과외</span></a>
    <nav class="desktop-nav" aria-label="주요 메뉴"><a href="${p}elementary/">초등 수학</a><a href="${p}middle/">중등 수학</a><a href="${p}high/">고등 수학</a><a href="${p}#areas">지역 안내</a></nav>
    <a class="header-cta" href="tel:$tel">전화 상담</a>
  </header>
  <main id="main">
$body
  </main>
  <footer class="area-footer"><a class="brand footer-brand" href="$p"><span class="brand-mark" aria-hidden="true">Σ</span><span>서울 수학과외</span></a><a class="footer-phone" href="tel:$tel">$phone</a><p>© <span id="year"></span> 서울 수학과외</p></footer>
</body>
</html>
"@
}

function Get-Hero($crumbs, [string]$prefix, [string]$eyebrow, [string]$h1, [string]$copy, $chips) {
  $chipItems = ($chips | ForEach-Object { "<li>$(E $_)</li>" }) -join ''
@"
    <section class="area-hero">
      $(Get-Breadcrumb $crumbs $prefix)
      <p class="eyebrow">$(E $eyebrow)</p>
      <h1>$(E $h1)</h1>
      <p class="hero-copy">$(E $copy)</p>
      <ul class="keyword-chips" aria-label="주요 수업">$chipItems</ul>
      <div class="area-hero-actions">
        <a class="button button-primary" href="tel:$tel" aria-label="${phone}로 전화하기">$phone 전화 상담</a>
      </div>
    </section>
"@
}

function Get-Faq([string]$number, $faqs) {
  $items = ($faqs | ForEach-Object { "<details><summary>$(E $_.Q)</summary><p>$(E $_.A)</p></details>" }) -join "`n          "
@"
      <section class="area-section faq" aria-labelledby="faq-title">
        <p class="section-number">$number / FAQ</p>
        <h2 id="faq-title">자주 묻는 질문</h2>
        <div class="faq-list">
          $items
        </div>
      </section>
"@
}

function Get-Related([string]$number, [string]$heading, $links, $tags) {
  $linkItems = ($links | ForEach-Object { "<a href=`"$($_.Href)`">$(E $_.Text)<span aria-hidden=`"true`">↗</span></a>" }) -join "`n          "
  $tagItems = ''
  if ($tags) { $tagItems = "<ul class=`"tag-list`" aria-label=`"관련 키워드`">" + (($tags | ForEach-Object { "<li>$(E $_)</li>" }) -join '') + '</ul>' }
@"
      <section class="area-section related" aria-labelledby="related-title">
        <p class="section-number">$number / RELATED</p>
        <h2 id="related-title">$heading</h2>
        <div class="related-links">
          $linkItems
        </div>
        $tagItems
      </section>
"@
}

function Get-Cta([string]$heading, [string]$prefix) {
@"
      <section class="area-cta">
        <h2>$(E $heading)</h2>
        <p>학생의 학년과 거주 지역, 현재 학습 고민을 알려주세요. 최근 시험지나 교재가 있으면 더 정확한 상담이 가능합니다.</p>
        <div class="area-cta-actions">
          <a class="button" href="tel:$tel" aria-label="${phone}로 전화하기">$phone 전화하기</a>
        </div>
      </section>
"@
}

function Save-Page([string]$relativeDir, [string]$html, [string]$title, [string]$description, [string]$priority) {
  $directory = Join-Path $PSScriptRoot $relativeDir
  New-Item -ItemType Directory -Path $directory -Force | Out-Null
  [System.IO.File]::WriteAllText((Join-Path $directory 'index.html'), $html.Replace("`r`n", "`n"), $utf8)
  [void]$pages.Add(@{ Url = "$baseUrl/$relativeDir/"; Title = $title; Description = $description; Priority = $priority })
}

function New-LevelPage($level, $ctx, [int]$index, [string]$relativeDir, [string]$prefix, $crumbs, $relatedLinks, [string]$areaServed) {
  $title = Fill $level.Title $ctx
  $description = Fill $level.Description $ctx
  $faqs = $level.Faqs | ForEach-Object { @{ Q = (Fill $_.Q $ctx); A = (Fill $_.A $ctx) } }
  $intro = Fill $level.Intros[$index % $level.Intros.Count] $ctx
  $topics = ($level.Topics | ForEach-Object { "<article class=`"topic-card`"><h3>$(E $_.Title)</h3><p>$(E $_.Text)</p></article>" }) -join "`n          "
  $grades = ($level.Grades | ForEach-Object { "<article class=`"grade-card`"><span>$($_.Code)</span><h3>$(E "$($ctx.D) $($_.Name) 수학과외")</h3><p>$(E $_.Text)</p></article>" }) -join "`n          "
  $label = $level.Label
  $hero = Get-Hero $crumbs $prefix "$($ctx.D) · $($level.English) MATH" "$($ctx.D) $label 수학과외" (Fill $level.Hero $ctx) $level.Chips
  $body = @"
$hero
    <div class="area-main">
      <section class="area-intro" aria-labelledby="intro-title">
        <div><p class="section-number">01 / LOCAL CLASS</p><h2 id="intro-title">$(E $ctx.D) $label 수학수업,<br>이렇게 진행합니다</h2></div>
        <div><p>$(E $intro)</p><p>$(E $level.Body)</p></div>
      </section>
      <section class="area-section topic-guide" aria-labelledby="topic-title">
        <p class="section-number">02 / CLASS FOCUS</p>
        <h2 id="topic-title">$(E $ctx.D) $label 수학,<br>필요한 것부터 채웁니다</h2>
        <div class="topic-cards">
          $topics
        </div>
      </section>
      <section class="area-section grade-guide" id="grades" aria-labelledby="grade-title">
        <p class="section-number">03 / GRADE GUIDE</p>
        <h2 id="grade-title">학년별<br>$(E $ctx.D) $label 수학과외</h2>
        <div class="grade-cards">
          $grades
        </div>
      </section>
$(Get-Faq '04' $faqs)
$(Get-Related '05' '함께 찾는<br>수학 수업' $relatedLinks $level.Tags)
$(Get-Cta "$($ctx.D) $label 수학과외 상담" $prefix)
    </div>
"@
  $jsonLd = Get-JsonLd $areaServed $crumbs $faqs
  $html = Get-Page @{ Title = $title; Description = $description; Url = "$baseUrl/$relativeDir/"; Prefix = $prefix; JsonLd = $jsonLd } $body
  Save-Page $relativeDir $html $title $description '0.7'
}

function Get-NeighborhoodText([string]$neighborhoods) {
  ($neighborhoods -split ',\s*') -join '·'
}

# 서울 전체 학교급 페이지: /elementary/, /middle/, /high/
foreach ($level in $levels.Values) {
  $ctx = @{ D = '서울'; N = '강남·노원·목동·잠실' }
  $crumbs = @(
    @{ Name = '서울 수학과외'; Path = ''; Url = "$baseUrl/" },
    @{ Name = "서울 $($level.Label) 수학과외"; Path = "$($level.Key)/"; Url = "$baseUrl/$($level.Key)/" }
  )
  $links = @($areas | ForEach-Object { @{ Href = "../areas/$($_.Slug)/$($level.Key)/"; Text = "$($_.Name) $($level.Label) 수학" } })
  New-LevelPage $level $ctx 0 $level.Key '../' $crumbs $links '서울특별시'
}

# 자치구 허브 + 학교급 페이지
for ($i = 0; $i -lt $areas.Count; $i++) {
  $area = $areas[$i]
  $ctx = @{ D = $area.Name; N = (Get-NeighborhoodText $area.Neighborhoods) }
  $nearby = @(($area.Nearby -split ',\s*') | ForEach-Object { $areaBySlug[$_] })
  $hubDir = "areas/$($area.Slug)"
  $hubCrumbs = @(
    @{ Name = '서울 수학과외'; Path = ''; Url = "$baseUrl/" },
    @{ Name = "$($area.Name) 수학과외"; Path = "$hubDir/"; Url = "$baseUrl/$hubDir/" }
  )

  foreach ($level in $levels.Values) {
    $crumbs = $hubCrumbs + @(@{ Name = "$($level.Label) 수학"; Path = "$hubDir/$($level.Key)/"; Url = "$baseUrl/$hubDir/$($level.Key)/" })
    $links = @(@{ Href = '../'; Text = "$($area.Name) 수학과외" })
    $links += $levels.Values | Where-Object { $_.Key -ne $level.Key } | ForEach-Object { @{ Href = "../$($_.Key)/"; Text = "$($area.Name) $($_.Label) 수학" } }
    $links += $nearby | ForEach-Object { @{ Href = "../../$($_.Slug)/$($level.Key)/"; Text = "$($_.Name) $($level.Label) 수학" } }
    $links += @{ Href = "../../../$($level.Key)/"; Text = "서울 $($level.Label) 수학과외" }
    New-LevelPage $level $ctx $i "$hubDir/$($level.Key)" '../../../' $crumbs $links "서울특별시 $($area.Name)"
  }

  $title = "$($area.Name) 수학과외 | 초등·중등·고등 1:1 맞춤 수학수업"
  $description = "서울 $($area.Name) 수학과외. $($ctx.N) 초등·중등·고등 학생의 기초수학, 수학내신, 수능수학까지 1:1로 진단하고 맞춤 수업을 설계합니다. 상담 $phone"
  $faqs = $hubFaqs | ForEach-Object { @{ Q = (Fill $_.Q $ctx); A = (Fill $_.A $ctx) } }
  $levelCards = ($levels.Values | ForEach-Object {
    $chips = ($_.Chips | Select-Object -Skip 1 | ForEach-Object { "<li>$(E $_)</li>" }) -join ''
    "<a class=`"level-card`" href=`"$($_.Key)/`"><span>$($_.English)</span><h3>$(E "$($area.Name) $($_.Label) 수학")</h3><p>$(E $_.Summary)</p><ul>$chips</ul><i>자세히 보기 ↗</i></a>"
  }) -join "`n          "
  $gradeLinks = @(@{ Href = 'elementary/#grades'; Text = '초등' })
  $gradeLinks += 'middle', 'high' | ForEach-Object { $key = $_; $levels[$key].Grades | ForEach-Object { @{ Href = "$key/#grades"; Text = $_.Name } } }
  $gradeItems = ($gradeLinks | ForEach-Object { "<a href=`"$($_.Href)`">$(E "$($area.Name) $($_.Text) 수학과외")<span aria-hidden=`"true`">↗</span></a>" }) -join "`n          "
  $neighborhoodTags = (($area.Neighborhoods -split ',\s*') | ForEach-Object { "<li>$(E "$_ 수학과외")</li>" }) -join ''
  $hubLinks = @($nearby | ForEach-Object { @{ Href = "../$($_.Slug)/"; Text = "$($_.Name) 수학과외" } })
  $hubLinks += $levels.Values | ForEach-Object { @{ Href = "../../$($_.Key)/"; Text = "서울 $($_.Label) 수학과외" } }
  $intro = Fill $hubIntros[$i % $hubIntros.Count] $ctx
  $hero = Get-Hero $hubCrumbs '../../' "$($area.Name) · PERSONAL MATH TUTORING" "$($area.Name) 수학과외" '학교 진도와 현재 실력을 함께 살펴, 학생에게 필요한 순서로 수학 공부를 설계합니다.' @('초등 수학', '중등 수학', '고등 수학', '수학내신', '수능수학', '기초수학')
  $body = @"
$hero
    <div class="area-main">
      <section class="area-intro" aria-labelledby="intro-title">
        <div><p class="section-number">01 / LOCAL CLASS</p><h2 id="intro-title">$(E $area.Name)에서 만나는<br>맞춤 수학 수업</h2></div>
        <div><p>$(E $intro)</p><p>빠른 선행만을 목표로 하기보다 배운 내용을 스스로 설명하고 새로운 문제에 적용할 수 있도록 수업과 과제의 난이도를 조정합니다.</p></div>
      </section>
      <section class="area-section level-guide" aria-labelledby="level-title">
        <p class="section-number">02 / SCHOOL LEVEL</p>
        <h2 id="level-title">초등·중등·고등<br>$(E $area.Name) 수학수업</h2>
        <div class="level-cards">
          $levelCards
        </div>
      </section>
      <section class="area-section grade-links" aria-labelledby="grade-title">
        <p class="section-number">03 / GRADE</p>
        <h2 id="grade-title">학년별<br>$(E $area.Name) 수학과외</h2>
        <div class="grade-link-grid">
          $gradeItems
        </div>
        <p class="area-note">$(E $ctx.N) 등 $(E $area.Name) 전 지역에서 상담할 수 있습니다.</p>
        <ul class="tag-list" aria-label="동네별 수학과외">$neighborhoodTags</ul>
      </section>
$(Get-Faq '04' $faqs)
$(Get-Related '05' '가까운 지역<br>수학과외' $hubLinks $null)
$(Get-Cta "$($area.Name) 수학과외 상담" '../../')
    </div>
"@
  $jsonLd = Get-JsonLd "서울특별시 $($area.Name)" $hubCrumbs $faqs
  $html = Get-Page @{ Title = $title; Description = $description; Url = "$baseUrl/$hubDir/"; Prefix = '../../'; JsonLd = $jsonLd } $body
  Save-Page $hubDir $html $title $description '0.8'
}

# sitemap.xml
$sorted = @(@{ Url = "$baseUrl/"; Title = '서울 수학과외 | 초등·중등·고등 1:1 맞춤 수학수업'; Description = '서울 25개 구 1:1 수학과외. 초등 기초수학, 중등 수학내신, 고등 수능수학까지 학생의 현재 실력과 목표에 맞춰 수업을 설계합니다.'; Priority = '1.0' }) + ($pages | Sort-Object { -[double]$_.Priority }, { $_.Url })
$urlEntries = $sorted | ForEach-Object { "  <url><loc>$($_.Url)</loc><lastmod>$today</lastmod><priority>$($_.Priority)</priority></url>" }
$sitemap = @('<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">') + $urlEntries + '</urlset>'
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'sitemap.xml'), ($sitemap -join "`n") + "`n", $utf8)

# rss.xml (네이버 서치어드바이저 RSS 제출용)
$pubDate = (Get-Date).ToUniversalTime().ToString('r')
$rssItems = $sorted | ForEach-Object { "    <item><title>$(E $_.Title)</title><link>$($_.Url)</link><guid>$($_.Url)</guid><description>$(E $_.Description)</description><pubDate>$pubDate</pubDate></item>" }
$rss = @(
  '<?xml version="1.0" encoding="UTF-8"?>',
  '<rss version="2.0">',
  '  <channel>',
  '    <title>서울 수학과외</title>',
  "    <link>$baseUrl/</link>",
  '    <description>서울 25개 구 초등·중등·고등 1:1 맞춤 수학과외 안내</description>',
  '    <language>ko</language>',
  "    <lastBuildDate>$pubDate</lastBuildDate>"
) + $rssItems + @('  </channel>', '</rss>')
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'rss.xml'), ($rss -join "`n") + "`n", $utf8)

Write-Host "Generated $($pages.Count) pages, sitemap.xml and rss.xml"
