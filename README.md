# 서울 수학과외

`edupoint.kr`에 배포하는 서울 지역 1:1 수학과외 정적 웹사이트입니다.

## 페이지 생성

```powershell
.\generate-location-pages.ps1
```

다음 파일을 생성합니다. 홈(`index.html`)은 직접 수정합니다.

- `elementary/`, `middle/`, `high/`: 서울 초등·중등·고등 수학과외
- `areas/{구}/`: 자치구 수학과외 허브
- `areas/{구}/elementary|middle|high/`: 자치구별 초등·중등·고등 수학
- `pre-middle1/`, `pre-high1/`, `visiting/`, `winter-math/`, `suneung-math/`, `exam-prep/`, `advanced-math/`, `basic-math/`: 예비중1·예비고1·방문과외·겨울방학·수능·내신대비·선행·기초수학 주제 페이지
- `towns/`, `towns/{동}/`: 대치동·목동·중계동·개포동·광장동 등 학원가 동네 페이지
- `sitemap.xml`, `rss.xml`: 네이버 서치어드바이저 제출용

GitHub Pages는 저장소 루트의 `CNAME`을 사용해 맞춤 도메인을 연결합니다.
