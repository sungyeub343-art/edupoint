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

# 서울 전체 주제 페이지: /topics/{slug}/
$topics = [ordered]@{
  'pre-middle1' = @{
    Name = '예비중1 수학과외'; English = 'PRE-MIDDLE 1'
    Title = '서울 예비중1 수학과외 | 초6 중1 수학 준비 1:1 수업'
    Description = '서울 예비중1 수학과외. 초6 수학 결손 점검부터 중1 정수와 유리수, 문자와 식, 일차방정식까지 중학교 첫 수학을 1:1로 준비합니다. 상담 010-2928-3614'
    Hero = '초등 수학의 빈틈을 먼저 확인하고, 중1 첫 단원부터 흔들리지 않도록 순서대로 준비합니다.'
    Chips = @('예비중1 수학', '초6 수학', '중1 수학 선행', '중학교 수학 준비')
    IntroHeading = @('중학교 수학,', '시작이 중요합니다')
    Intro = @(
      '중1 수학은 정수와 유리수, 문자와 식처럼 초등 수학과 다른 방식으로 생각해야 하는 단원으로 시작합니다. 이 시기에 개념을 대충 넘기면 일차방정식과 함수에서 같은 실수가 반복됩니다.',
      '예비중1 수업은 분수·소수 연산, 비와 비율 같은 초5·초6 핵심 단원을 먼저 점검한 뒤 중1 1학기 개념으로 넘어갑니다. 진도 속도보다 학생이 풀이를 스스로 설명할 수 있는지를 기준으로 다음 단계를 정합니다.'
    )
    CardsHeading = @('예비중1이', '준비할 것')
    Cards = @(
      @{ Title = '초등 수학 결손 점검'; Text = '분수와 소수의 사칙연산, 비와 비율, 도형의 넓이처럼 중학교 수학의 바탕이 되는 단원을 다시 확인합니다.' },
      @{ Title = '정수와 유리수'; Text = '음수 개념과 부호 규칙을 그림과 수직선으로 이해하고, 계산 실수를 줄이는 풀이 습관을 만듭니다.' },
      @{ Title = '문자와 식·일차방정식'; Text = '문자를 사용해 식을 세우는 방법을 익히고, 문장제를 방정식으로 바꾸는 연습을 합니다.' },
      @{ Title = '중학교 시험 적응'; Text = '서술형 풀이 쓰는 법과 수행평가 준비 방법을 미리 익혀 첫 시험에서 당황하지 않도록 합니다.' }
    )
    StepsHeading = @('예비중1 수학', '진행 순서')
    Steps = @(
      @{ Code = 'STEP 01'; Name = '초등 핵심 진단'; Text = '초5·초6 핵심 단원 문제로 연산 정확도와 개념 이해 정도를 확인합니다.' },
      @{ Code = 'STEP 02'; Name = '중1 개념 수업'; Text = '정수와 유리수부터 일차방정식까지 학생 속도에 맞춰 개념과 기본 유형을 정리합니다.' },
      @{ Code = 'STEP 03'; Name = '적용과 점검'; Text = '단원별 확인 문제와 서술형 연습으로 이해한 내용을 다시 점검하고 입학 후 학교 진도와 연결합니다.' }
    )
    Faqs = @(
      @{ Q = '예비중1 수학은 언제부터 준비하면 좋나요?'; A = '초6 2학기나 겨울방학에 시작하는 경우가 많습니다. 초등 과정에 빈틈이 있다면 선행보다 그 부분을 먼저 채우는 것이 좋습니다.' },
      @{ Q = '중1 선행을 어디까지 해야 하나요?'; A = '학생마다 다르지만 중1 1학기 개념을 충분히 이해하는 것이 우선입니다. 이해가 빠른 학생은 2학기 내용까지 이어갈 수 있습니다.' },
      @{ Q = '수학을 싫어하는 아이도 괜찮을까요?'; A = '네. 아이가 어디서 수학을 어렵게 느끼기 시작했는지 먼저 찾고, 작은 성공 경험을 쌓을 수 있도록 난이도를 조절합니다.' }
    )
    Tags = @('예비중1 수학 선행', '초6 겨울방학 수학', '중1 정수와 유리수', '중1 일차방정식', '중학교 수학 준비', '예비중1 수학 개인과외')
    Related = @('pre-high1', 'winter-math', 'visiting')
    LevelLinks = @('elementary', 'middle')
  }
  'pre-high1' = @{
    Name = '예비고1 수학과외'; English = 'PRE-HIGH 1'
    Title = '서울 예비고1 수학과외 | 중3 공통수학1·2 준비 1:1 수업'
    Description = '서울 예비고1 수학과외. 중3 수학 결손 점검부터 고1 공통수학1·2 다항식, 방정식과 부등식, 도형의 방정식까지 고등 첫 내신을 1:1로 준비합니다. 상담 010-2928-3614'
    Hero = '중3 개념의 빈틈을 채우고, 공통수학1·2를 학교 진도보다 한 걸음 먼저 준비합니다.'
    Chips = @('예비고1 수학', '중3 수학', '공통수학1', '공통수학2', '고1 수학 선행')
    IntroHeading = @('고등 수학,', '첫 내신이 기준이 됩니다')
    Intro = @(
      '고1 수학은 진도가 빠르고 시험 범위가 넓어, 첫 중간고사 결과가 이후 공부 방향에 큰 영향을 줍니다. 공통수학1·2는 인수분해와 이차방정식, 이차함수 같은 중3 개념 위에서 시작하므로 이 부분이 흔들리면 진도를 따라가기 어렵습니다.',
      '예비고1 수업은 중3 핵심 단원을 먼저 진단하고, 공통수학1의 다항식과 방정식·부등식부터 순서대로 정리합니다. 개념 이해, 대표 유형, 서술형 풀이 쓰기까지 고1 내신에 필요한 흐름을 미리 경험합니다.'
    )
    CardsHeading = @('예비고1이', '준비할 것')
    Cards = @(
      @{ Title = '중3 수학 결손 점검'; Text = '제곱근과 실수, 인수분해, 이차방정식, 이차함수를 점검해 고등 수학의 출발점을 다시 다집니다.' },
      @{ Title = '공통수학1'; Text = '다항식의 연산, 나머지정리, 복소수와 이차방정식, 여러 가지 방정식과 부등식, 경우의 수, 행렬을 정리합니다.' },
      @{ Title = '공통수학2'; Text = '도형의 방정식, 집합과 명제, 함수와 그래프처럼 고1 2학기 내신의 핵심 단원을 준비합니다.' },
      @{ Title = '고1 첫 내신 대비'; Text = '학교별 부교재와 서술형 비중을 고려해 입학 직후 첫 시험까지 학습 계획을 세웁니다.' }
    )
    StepsHeading = @('예비고1 수학', '진행 순서')
    Steps = @(
      @{ Code = 'STEP 01'; Name = '중3 핵심 진단'; Text = '인수분해, 이차방정식, 이차함수 문제로 고등 수학을 시작할 준비가 되었는지 확인합니다.' },
      @{ Code = 'STEP 02'; Name = '공통수학 개념'; Text = '공통수학1부터 개념과 대표 유형을 정리하고, 학생 속도에 따라 공통수학2까지 이어갑니다.' },
      @{ Code = 'STEP 03'; Name = '내신형 훈련'; Text = '고난도 유형과 서술형 풀이를 연습하고, 입학 후 학교 진도와 시험 범위에 맞춰 복습합니다.' }
    )
    Faqs = @(
      @{ Q = '예비고1 수학은 무엇부터 시작하나요?'; A = '중3 핵심 단원을 먼저 진단합니다. 인수분해와 이차함수가 탄탄하면 공통수학1로 바로 넘어가고, 부족하면 그 단원부터 보완합니다.' },
      @{ Q = '공통수학1·2를 모두 선행해야 하나요?'; A = '공통수학1을 충분히 이해하는 것이 우선입니다. 시간과 이해도에 여유가 있으면 공통수학2까지 이어갑니다.' },
      @{ Q = '중학교 성적이 낮아도 고등 수학을 따라갈 수 있을까요?'; A = '입학 전 기간을 활용해 중학 개념을 다시 연결하면 충분히 따라갈 수 있습니다. 진단 결과에 맞춰 보완과 선행의 비중을 정합니다.' }
    )
    Tags = @('예비고1 수학 선행', '중3 겨울방학 수학', '공통수학1 선행', '공통수학2 선행', '고1 첫 내신', '예비고1 수학 개인과외')
    Related = @('pre-middle1', 'winter-math', 'visiting')
    LevelLinks = @('middle', 'high')
  }
  'visiting' = @{
    Name = '수학 방문과외'; English = 'HOME VISIT'
    Title = '서울 수학 방문과외 | 초등·중등·고등 집에서 받는 1:1 수학수업'
    Description = '서울 수학 방문과외. 서울 25개 구 초등·중등·고등 학생의 집으로 찾아가 학교 진도와 실력에 맞춘 1:1 수학수업을 진행합니다. 상담 010-2928-3614'
    Hero = '학생이 공부하는 공간에서, 학생의 속도에 맞춰 1:1로 수학 수업을 진행합니다.'
    Chips = @('수학 방문과외', '1:1 수학과외', '집에서 받는 수학수업', '수학 개인과외')
    IntroHeading = @('집에서 받는', '1:1 수학수업')
    Intro = @(
      '방문과외는 학원 이동 시간이 없어 학교와 다른 일정 사이에 수업 시간을 잡기 쉽습니다. 학생이 평소 공부하는 책상에서 수업하기 때문에 공부 환경과 교재, 오답 노트 상태까지 함께 확인할 수 있습니다.',
      '수업은 학교 교과서와 최근 시험지를 기준으로 진행합니다. 1:1 수업이라 학생이 이해하지 못한 부분에서 바로 멈추고 다시 설명할 수 있고, 수업이 끝나면 과제와 다음 수업 계획을 정리해 안내합니다.'
    )
    CardsHeading = @('방문과외가', '도움이 되는 경우')
    Cards = @(
      @{ Title = '이동 시간이 부담될 때'; Text = '학원 왕복 시간을 줄여 그 시간을 복습과 과제에 쓸 수 있습니다.' },
      @{ Title = '집중이 어려울 때'; Text = '여러 학생과 함께하는 수업에서 질문을 못 하거나 흐름을 놓치는 학생에게 맞습니다.' },
      @{ Title = '공부 습관이 필요할 때'; Text = '집에서의 공부 방법, 교재 정리, 오답 관리 습관을 수업 안에서 함께 잡습니다.' },
      @{ Title = '일정이 불규칙할 때'; Text = '학교 시험 기간, 방학, 다른 활동 일정에 맞춰 수업 시간을 상담 후 조정합니다.' }
    )
    StepsHeading = @('수학 방문과외', '진행 순서')
    Steps = @(
      @{ Code = 'STEP 01'; Name = '전화 상담'; Text = '학생의 학년, 학교, 거주 지역, 현재 고민과 희망 수업 시간을 확인합니다.' },
      @{ Code = 'STEP 02'; Name = '첫 수업 진단'; Text = '최근 시험지와 교재를 바탕으로 막힌 단원과 공부 습관을 확인하고 수업 방향을 정합니다.' },
      @{ Code = 'STEP 03'; Name = '정기 수업'; Text = '학교 진도와 시험 일정에 맞춰 수업하고, 과제와 학습 상황을 꾸준히 점검합니다.' }
    )
    Faqs = @(
      @{ Q = '서울 어느 지역까지 방문 수업이 가능한가요?'; A = '서울 25개 자치구를 기준으로 상담합니다. 정확한 수업 가능 여부와 시간은 거주 지역과 희망 일정을 확인한 뒤 안내합니다.' },
      @{ Q = '방문과외는 어떤 학년까지 가능한가요?'; A = '초등학생부터 중학생, 고등학생까지 상담할 수 있습니다. 학년과 목표에 따라 개념 보완, 내신, 수능 대비 중심으로 수업을 구성합니다.' },
      @{ Q = '수업 준비물은 무엇인가요?'; A = '학교 교과서, 사용 중인 문제집, 최근 시험지를 준비해 주시면 됩니다. 필요한 교재는 진단 후 함께 정합니다.' }
    )
    Tags = @('서울 수학 방문과외', '초등 수학 방문과외', '중등 수학 방문과외', '고등 수학 방문과외', '1:1 수학 개인과외', '집 근처 수학과외')
    Related = @('winter-math', 'pre-middle1', 'pre-high1')
    LevelLinks = @('elementary', 'middle', 'high')
  }
  'winter-math' = @{
    Name = '겨울방학 수학과외'; English = 'WINTER BREAK'
    Title = '서울 겨울방학 수학과외 | 초등·중등·고등 방학 수학 집중 1:1'
    Description = '서울 겨울방학 수학과외. 지난 학년 복습과 다음 학기 예습, 예비중1·예비고1 준비, 고3 수능 기초까지 방학 기간에 맞춘 1:1 수학 계획을 세웁니다. 상담 010-2928-3614'
    Hero = '지난 학년의 빈틈을 채우고 다음 학년을 준비하는, 방학 기간에 맞춘 수학 계획을 세웁니다.'
    Chips = @('겨울방학 수학', '방학 수학 특강', '다음 학기 예습', '지난 학년 복습')
    IntroHeading = @('겨울방학,', '수학 순서를 다시 잡는 시간')
    Intro = @(
      '겨울방학은 학기 중보다 공부 시간을 길게 쓸 수 있어 지난 학년 복습과 다음 학기 예습을 함께 하기 좋은 시기입니다. 다만 목표 없이 진도만 빠르게 나가면 새 학기에 같은 단원에서 다시 막히기 쉽습니다.',
      '겨울방학 수업은 2학기 기말고사 결과와 오답을 먼저 확인하고, 방학 기간 안에 끝낼 목표를 정합니다. 주 단위로 진도와 복습 분량을 나누어 개학 전까지 다음 학기 첫 단원을 준비합니다.'
    )
    CardsHeading = @('학년별', '겨울방학 수학')
    Cards = @(
      @{ Title = '초등 겨울방학'; Text = '지난 학년 연산과 분수·소수 개념을 정리하고 다음 학년 1학기 첫 단원을 미리 익힙니다.' },
      @{ Title = '중등 겨울방학'; Text = '지난 학년 결손 단원을 보완하고 다음 학기 개념과 기본 유형을 정리해 첫 시험에 대비합니다.' },
      @{ Title = '예비중1·예비고1'; Text = '학교급이 바뀌는 시기에 맞춰 중1 수학 또는 공통수학1·2를 순서대로 준비합니다.' },
      @{ Title = '예비고2·예비고3'; Text = '내신 과목 개념을 정리하고 모의고사 결과를 바탕으로 수능 수학 취약 단원을 보완합니다.' }
    )
    StepsHeading = @('겨울방학 수학', '진행 순서')
    Steps = @(
      @{ Code = 'STEP 01'; Name = '방학 전 진단'; Text = '2학기 시험지와 오답을 분석해 복습할 단원과 예습할 범위를 정합니다.' },
      @{ Code = 'STEP 02'; Name = '방학 집중 수업'; Text = '주 단위 계획에 따라 복습과 예습을 병행하고, 과제로 배운 내용을 바로 확인합니다.' },
      @{ Code = 'STEP 03'; Name = '개학 전 정리'; Text = '방학 동안 배운 내용을 다시 점검하고 새 학기 학교 진도와 연결되도록 마무리합니다.' }
    )
    Faqs = @(
      @{ Q = '겨울방학 수학 수업은 언제 상담하면 좋나요?'; A = '기말고사가 끝난 직후나 방학 시작 전에 상담하면 방학 첫 주부터 계획대로 수업을 시작하기 좋습니다.' },
      @{ Q = '방학에는 복습과 선행 중 무엇을 먼저 하나요?'; A = '지난 학년에 막힌 단원이 있다면 복습을 먼저 합니다. 기초가 탄탄한 학생은 다음 학기 예습 비중을 늘립니다.' },
      @{ Q = '방학이 끝난 뒤에도 수업을 이어갈 수 있나요?'; A = '네. 방학 동안 정리한 내용을 바탕으로 학기 중에는 학교 진도와 내신 대비 중심으로 이어갈 수 있습니다.' }
    )
    Tags = @('겨울방학 수학 특강', '초등 겨울방학 수학', '중등 겨울방학 수학', '고등 겨울방학 수학', '방학 수학 선행', '방학 수학 복습')
    Related = @('pre-middle1', 'pre-high1', 'visiting')
    LevelLinks = @('elementary', 'middle', 'high')
  }
}

# 학원가 동네 페이지: /towns/{slug}/
$towns = @(
  @{ Name='대치동'; Slug='daechi-dong'; Area='gangnam-gu'
     Point='서울에서 학원이 가장 많이 모인 지역으로, 선행 속도가 빠르고 학교 내신 난도가 높은 편입니다.'
     Intro='대치동 학생들은 학원 수업과 학교 내신, 선행 진도를 동시에 관리하는 경우가 많습니다. 여러 수업을 듣다 보면 정작 스스로 풀어본 문제가 적어 개념이 쌓이지 않는 경우가 생깁니다.'
     Focus='1:1 수업은 학원 진도를 따라가며 놓친 개념을 메우고, 학교별 고난도 내신 문항과 서술형을 따로 점검하는 데 집중합니다.'
     Faq=@{ Q='대치동 학원과 함께 과외를 받아도 되나요?'; A='네. 학원 진도와 숙제를 함께 확인해 이해가 부족한 부분을 보완하고, 학교 내신 대비는 학생이 다니는 학교 기준으로 따로 준비합니다.' } },
  @{ Name='도곡동'; Slug='dogok-dong'; Area='gangnam-gu'
     Point='대치동 학원가와 가까워 학원 수업과 내신 대비를 함께 하는 학생이 많은 지역입니다.'
     Intro='도곡동 학생들은 대치동 학원가를 이용하면서도 학교마다 다른 시험 범위와 부교재를 따로 준비해야 합니다. 학원 진도와 학교 진도가 어긋날 때 혼자 정리하기 어려운 부분이 생깁니다.'
     Focus='1:1 수업은 학원 진도와 학교 진도의 차이를 정리하고, 시험 기간에는 학교 교과서와 기출 유형 중심으로 내신을 준비합니다.'
     Faq=@{ Q='도곡동 중학생 내신은 어떻게 준비하나요?'; A='학교 교과서와 부교재, 최근 기출을 기준으로 시험 범위를 정리하고 서술형 감점 요인을 점검합니다.' } },
  @{ Name='목동'; Slug='mok-dong'; Area='yangcheon-gu'
     Point='강서·양천권 대표 학원가가 있는 지역으로, 중학교 내신 경쟁이 치열한 편입니다.'
     Intro='목동 학생들은 중학교 때부터 내신과 선행을 함께 준비하는 경우가 많습니다. 선행 진도가 앞서 있어도 현재 학년 개념이 흔들리면 학교 시험에서 실수가 반복됩니다.'
     Focus='1:1 수업은 현재 학년 개념과 학교 시험 유형을 먼저 다지고, 학생의 이해 속도에 맞춰 선행 범위를 조절합니다.'
     Faq=@{ Q='목동 중학생은 선행을 얼마나 해야 하나요?'; A='학생마다 다릅니다. 현재 학년 내신이 안정적인지 먼저 확인한 뒤, 이해 속도에 맞춰 다음 학기 또는 다음 학년 범위를 정합니다.' } },
  @{ Name='중계동'; Slug='junggye-dong'; Area='nowon-gu'
     Point='은행사거리 학원가를 중심으로 강북 지역 학생들이 많이 찾는 교육 중심지입니다.'
     Intro='중계동은 노원구와 도봉구, 강북구 학생들이 함께 찾는 학원가가 있어 학교별 시험 경향이 다양합니다. 같은 학년이라도 학교에 따라 시험 범위와 서술형 비중이 다릅니다.'
     Focus='1:1 수업은 학생이 다니는 학교의 시험 경향을 기준으로 개념과 유형을 정리하고, 학년이 올라갈수록 수능형 문항 대비 비중을 늘립니다.'
     Faq=@{ Q='중계동 근처 상계동·하계동도 상담 가능한가요?'; A='네. 상계동, 하계동, 월계동, 공릉동 등 노원구 전 지역과 인근 도봉구, 강북구도 상담할 수 있습니다.' } },
  @{ Name='반포동'; Slug='banpo-dong'; Area='seocho-gu'
     Point='대단지 아파트가 모여 있고 강남권 학원가 접근성이 좋아 내신 대비 수요가 높은 지역입니다.'
     Intro='반포동 학생들은 학원 이용이 편리한 대신 수업과 과제가 많아 스스로 정리할 시간이 부족한 경우가 많습니다. 문제를 많이 풀어도 오답 원인을 정리하지 않으면 같은 유형에서 계속 감점됩니다.'
     Focus='1:1 수업은 오답의 원인을 개념, 계산, 문제 해석으로 나누어 점검하고, 학교별 고난도 문항에 대비한 풀이 습관을 만듭니다.'
     Faq=@{ Q='반포동 고등학생 내신과 수능을 함께 준비할 수 있나요?'; A='네. 시험 기간에는 학교 내신에 집중하고, 그 외 기간에는 모의고사 결과를 바탕으로 수능 수학 취약 단원을 보완합니다.' } },
  @{ Name='잠실동'; Slug='jamsil-dong'; Area='songpa-gu'
     Point='대단지 아파트와 학원가가 함께 있어 초등부터 고등까지 학생 수가 많은 지역입니다.'
     Intro='잠실동은 초등학생부터 고등학생까지 학년 구성이 다양해 학년마다 필요한 수업이 뚜렷하게 다릅니다. 초등은 기초와 습관, 중등은 내신, 고등은 내신과 수능의 균형이 중요합니다.'
     Focus='1:1 수업은 학생의 학년과 현재 실력에 맞춰 기초 보완, 내신 대비, 수능 대비의 비중을 다르게 설계합니다.'
     Faq=@{ Q='잠실동 초등학생도 수업이 가능한가요?'; A='네. 초등학생은 연산 정확도와 개념 이해, 공부 습관을 중심으로 수업하고 학년이 올라가면 중학교 수학 준비로 이어갑니다.' } },
  @{ Name='여의도동'; Slug='yeouido-dong'; Area='yeongdeungpo-gu'
     Point='맞벌이 가정이 많아 학생의 일정에 맞춘 1:1 수업 수요가 높은 지역입니다.'
     Intro='여의도동 학생들은 부모님 일정과 학교, 학원 일정을 함께 조율해야 하는 경우가 많습니다. 학습 상황을 꾸준히 공유받기 어려워 성적이 떨어진 뒤에야 문제를 알게 되기도 합니다.'
     Focus='1:1 수업은 학생 일정에 맞춰 수업 시간을 정하고, 수업 내용과 과제 수행 상황을 정리해 학부모님께 꾸준히 안내합니다.'
     Faq=@{ Q='여의도동 근처 당산동·신길동도 상담 가능한가요?'; A='네. 여의도동, 당산동, 문래동, 신길동 등 영등포구 전 지역과 인근 지역을 상담할 수 있습니다.' } },
  @{ Name='마곡동'; Slug='magok-dong'; Area='gangseo-gu'
     Point='새로 조성된 주거 단지가 많아 초등·중등 학생 비중이 높은 지역입니다.'
     Intro='마곡동은 젊은 가정이 많아 초등학생과 중학생 수요가 특히 많습니다. 수학 공부 습관이 자리 잡는 시기라 기초 개념과 공부 방법을 함께 잡는 것이 중요합니다.'
     Focus='1:1 수업은 연산과 개념 이해를 탄탄히 다지고, 예비중1·예비고1처럼 학교급이 바뀌는 시기에 필요한 준비를 미리 계획합니다.'
     Faq=@{ Q='마곡동 근처 발산동·등촌동도 상담 가능한가요?'; A='네. 마곡동, 발산동, 등촌동, 화곡동 등 강서구 전 지역과 인근 양천구도 상담할 수 있습니다.' } }
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

# 주제·동네 페이지 공용 본문: 소개 → 수업 카드 → 진행 단계 → FAQ → 관련 링크
function New-GuidePage($g) {
  $intro = ($g.Intro | ForEach-Object { "<p>$(E $_)</p>" }) -join ''
  $cards = ($g.Cards | ForEach-Object { "<article class=`"topic-card`"><h3>$(E $_.Title)</h3><p>$(E $_.Text)</p></article>" }) -join "`n          "
  $steps = ($g.Steps | ForEach-Object { "<article class=`"grade-card`"><span>$($_.Code)</span><h3>$(E $_.Name)</h3><p>$(E $_.Text)</p></article>" }) -join "`n          "
  $hero = Get-Hero $g.Crumbs $g.Prefix $g.Eyebrow $g.H1 $g.Hero $g.Chips
  $body = @"
$hero
    <div class="area-main">
      <section class="area-intro" aria-labelledby="intro-title">
        <div><p class="section-number">01 / OVERVIEW</p><h2 id="intro-title">$(($g.IntroHeading | ForEach-Object { E $_ }) -join '<br>')</h2></div>
        <div>$intro</div>
      </section>
      <section class="area-section topic-guide" aria-labelledby="topic-title">
        <p class="section-number">02 / CLASS FOCUS</p>
        <h2 id="topic-title">$(($g.CardsHeading | ForEach-Object { E $_ }) -join '<br>')</h2>
        <div class="topic-cards">
          $cards
        </div>
      </section>
      <section class="area-section grade-guide" aria-labelledby="step-title">
        <p class="section-number">03 / PROCESS</p>
        <h2 id="step-title">$(($g.StepsHeading | ForEach-Object { E $_ }) -join '<br>')</h2>
        <div class="grade-cards">
          $steps
        </div>
      </section>
$(Get-Faq '04' $g.Faqs)
$(Get-Related '05' '함께 찾는<br>수학 수업' $g.Links $g.Tags)
$(Get-Cta "$($g.H1) 상담" $g.Prefix)
    </div>
"@
  $jsonLd = Get-JsonLd $g.AreaServed $g.Crumbs $g.Faqs
  $html = Get-Page @{ Title = $g.Title; Description = $g.Description; Url = "$baseUrl/$($g.Dir)/"; Prefix = $g.Prefix; JsonLd = $jsonLd } $body
  Save-Page $g.Dir $html $g.Title $g.Description $g.Priority
}

function Get-TopicLinks($keys, [string]$prefix) {
  @($keys | ForEach-Object { @{ Href = "$prefix$_/"; Text = "서울 $($topics[$_].Name)" } })
}

# 학교급별로 함께 보여줄 주제 페이지
$levelTopics = @{ elementary = @('pre-middle1', 'winter-math', 'visiting'); middle = @('pre-high1', 'winter-math', 'visiting'); high = @('winter-math', 'visiting') }

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
  $links += Get-TopicLinks $levelTopics[$level.Key] '../'
  $links += @{ Href = '../towns/'; Text = '서울 학원가 동네별 수학과외' }
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
    $links += Get-TopicLinks $levelTopics[$level.Key] '../../../'
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
  $hubLinks += $towns | Where-Object { $_.Area -eq $area.Slug } | ForEach-Object { @{ Href = "../../towns/$($_.Slug)/"; Text = "$($_.Name) 수학과외" } }
  $hubLinks += Get-TopicLinks $topics.Keys '../../'
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

# 주제 페이지: /pre-middle1/, /pre-high1/, /visiting/, /winter-math/
foreach ($key in $topics.Keys) {
  $t = $topics[$key]
  $links = Get-TopicLinks $t.Related '../'
  $links += $t.LevelLinks | ForEach-Object { @{ Href = "../$_/"; Text = "서울 $($levels[$_].Label) 수학과외" } }
  $links += @{ Href = '../towns/'; Text = '서울 학원가 동네별 수학과외' }
  New-GuidePage @{
    Dir = $key; Prefix = '../'; Priority = '0.8'; AreaServed = '서울특별시'
    Crumbs = @(
      @{ Name = '서울 수학과외'; Path = ''; Url = "$baseUrl/" },
      @{ Name = "서울 $($t.Name)"; Path = "$key/"; Url = "$baseUrl/$key/" }
    )
    Eyebrow = "SEOUL · $($t.English) MATH"; H1 = "서울 $($t.Name)"
    Title = $t.Title; Description = $t.Description; Hero = $t.Hero; Chips = $t.Chips
    IntroHeading = $t.IntroHeading; Intro = $t.Intro; CardsHeading = $t.CardsHeading; Cards = $t.Cards
    StepsHeading = $t.StepsHeading; Steps = $t.Steps; Faqs = $t.Faqs; Links = $links; Tags = $t.Tags
  }
}

# 학원가 동네 페이지: /towns/{slug}/
$townsCrumb = @{ Name = '서울 학원가 동네별 수학과외'; Path = 'towns/'; Url = "$baseUrl/towns/" }
foreach ($town in $towns) {
  $area = $areaBySlug[$town.Area]
  $dir = "towns/$($town.Slug)"
  $name = $town.Name
  $links = @(@{ Href = "../../areas/$($area.Slug)/"; Text = "$($area.Name) 수학과외" })
  $links += $levels.Values | ForEach-Object { @{ Href = "../../areas/$($area.Slug)/$($_.Key)/"; Text = "$($area.Name) $($_.Label) 수학" } }
  $links += $towns | Where-Object { $_.Slug -ne $town.Slug } | ForEach-Object { @{ Href = "../$($_.Slug)/"; Text = "$($_.Name) 수학과외" } }
  $links += Get-TopicLinks $topics.Keys '../../'
  New-GuidePage @{
    Dir = $dir; Prefix = '../../'; Priority = '0.7'; AreaServed = "서울특별시 $($area.Name) $name"
    Crumbs = @(
      @{ Name = '서울 수학과외'; Path = ''; Url = "$baseUrl/" },
      $townsCrumb,
      @{ Name = "$name 수학과외"; Path = "$dir/"; Url = "$baseUrl/$dir/" }
    )
    Eyebrow = "$($area.Name) $name · LOCAL MATH TUTORING"; H1 = "$name 수학과외"
    Title = "$name 수학과외 | $($area.Name) $name 초등·중등·고등 1:1 수학"
    Description = "$($area.Name) $name 수학과외. $($town.Point) $name 초등·중등·고등 학생의 수학내신과 기초수학, 수능수학을 1:1로 준비합니다. 상담 $phone"
    Hero = $town.Point
    Chips = @("$name 수학", "$name 초등 수학", "$name 중등 수학", "$name 고등 수학", "$name 수학내신")
    IntroHeading = @("$name 학생에게", '필요한 수학 수업'); Intro = @($town.Intro, $town.Focus)
    CardsHeading = @("$name 수학과외,", '학교급별 수업')
    Cards = @(
      @{ Title = "$name 초등 수학"; Text = '연산 정확도와 개념 이해를 함께 확인하고, 서술형과 응용 문제로 생각하는 힘을 기릅니다.' },
      @{ Title = "$name 중등 수학"; Text = '학교별 시험 범위와 교과서를 기준으로 개념, 유형, 서술형까지 내신을 준비합니다.' },
      @{ Title = "$name 고등 수학"; Text = '현재 등급과 목표 전형을 바탕으로 내신과 수능 수학의 시기별 우선순위를 정합니다.' },
      @{ Title = "$name 기초수학"; Text = '막힌 단원이 있으면 이전 학년 개념까지 돌아가 연산과 기본 개념부터 다시 다집니다.' }
    )
    StepsHeading = @("$name 수학과외", '진행 순서')
    Steps = @(
      @{ Code = 'STEP 01'; Name = '전화 상담'; Text = "학생의 학년과 학교, 현재 다니는 학원과 고민을 확인합니다." },
      @{ Code = 'STEP 02'; Name = '진단과 계획'; Text = '최근 시험지와 오답을 분석해 개념 보완, 내신 대비, 선행의 비중을 정합니다.' },
      @{ Code = 'STEP 03'; Name = '수업과 점검'; Text = '학교 일정에 맞춰 수업하고 시험 결과를 바탕으로 다음 계획을 다시 조정합니다.' }
    )
    Faqs = @(
      $town.Faq,
      @{ Q = "$name 수학과외는 몇 학년까지 가능한가요?"; A = '초등학생부터 중1~중3, 고1~고3까지 상담할 수 있습니다. 학년과 목표에 맞춰 수업 내용을 정합니다.' },
      @{ Q = '상담은 어떻게 신청하나요?'; A = "${phone}로 전화 주시면 학생의 학년과 학교, 현재 고민을 듣고 상담해 드립니다." }
    )
    Links = $links
    Tags = @("$name 수학학원", "$name 중등 수학내신", "$name 고등 수학내신", "$name 수학 선행", "$name 수학 개인과외", "$($area.Name) 수학과외")
  }
}

# 동네 허브: /towns/
$townLinks = @($towns | ForEach-Object { @{ Href = "$($_.Slug)/"; Text = "$($_.Name) 수학과외" } })
$townsTitle = '서울 학원가 동네별 수학과외 | 대치동·목동·중계동·반포동·잠실 1:1'
$townsDescription = '서울 학원가 동네별 수학과외. 대치동, 도곡동, 목동, 중계동, 반포동, 잠실동, 여의도동, 마곡동 초등·중등·고등 학생의 수학을 1:1로 진단하고 수업을 설계합니다. 상담 010-2928-3614'
$townFaqs = @(
  @{ Q = '학원가 지역 학생도 1:1 수학과외가 필요한가요?'; A = '학원 수업이 많을수록 스스로 정리할 시간이 부족해 개념의 빈틈이 생기기 쉽습니다. 1:1 수업은 그 빈틈과 학교 내신을 따로 점검하는 데 도움이 됩니다.' },
  @{ Q = '목록에 없는 동네도 상담 가능한가요?'; A = '네. 서울 25개 자치구 전 지역에서 상담할 수 있습니다. 자치구별 안내 페이지에서 가까운 지역 정보를 확인하세요.' }
)
$townsCrumbs = @(@{ Name = '서울 수학과외'; Path = ''; Url = "$baseUrl/" }, $townsCrumb)
$townsHero = Get-Hero $townsCrumbs '../' 'SEOUL · ACADEMY DISTRICT' '서울 학원가 동네별 수학과외' '학원이 많은 동네일수록 학생마다 필요한 수업이 다릅니다. 동네별 학습 환경을 고려해 1:1 수업을 설계합니다.' @('대치동 수학', '목동 수학', '중계동 수학', '반포동 수학', '잠실 수학')
$townsBody = @"
$townsHero
    <div class="area-main">
      <section class="area-intro" aria-labelledby="intro-title">
        <div><p class="section-number">01 / OVERVIEW</p><h2 id="intro-title">동네마다 다른<br>수학 공부 환경</h2></div>
        <div><p>대치동과 목동, 중계동처럼 학원이 모인 지역은 선행 속도가 빠르고 학교 내신 난도도 높은 편입니다. 반면 새로 조성된 주거 지역은 초등·중등 학생이 많아 기초와 공부 습관을 잡는 수업이 더 필요합니다.</p><p>동네별 안내에서 지역 학생들의 학습 환경과 수업 방향을 확인하고, 학생의 학년과 학교에 맞는 상담을 받아보세요.</p></div>
      </section>
$(Get-Related '02' '동네별<br>수학과외 안내' ($townLinks + (Get-TopicLinks $topics.Keys '../')) $null)
$(Get-Faq '03' $townFaqs)
$(Get-Cta '서울 동네별 수학과외 상담' '../')
    </div>
"@
$townsJsonLd = Get-JsonLd '서울특별시' $townsCrumbs $townFaqs
$townsHtml = Get-Page @{ Title = $townsTitle; Description = $townsDescription; Url = "$baseUrl/towns/"; Prefix = '../'; JsonLd = $townsJsonLd } $townsBody
Save-Page 'towns' $townsHtml $townsTitle $townsDescription '0.8'

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
