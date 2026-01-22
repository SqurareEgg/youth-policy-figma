# 배포 가이드 (Deployment Guide)

> GitHub 레포지토리 생성 및 Vercel 배포 가이드

**작성일**: 2026-01-22

---

## 목차

1. [GitHub 레포지토리 생성](#github-레포지토리-생성)
2. [로컬 코드 Push](#로컬-코드-push)
3. [Vercel 배포](#vercel-배포)
4. [배포 후 확인 사항](#배포-후-확인-사항)

---

## GitHub 레포지토리 생성

### 1. GitHub 접속

1. https://github.com 접속
2. 로그인

### 2. 새 레포지토리 생성

1. 우측 상단 `+` 버튼 클릭
2. `New repository` 선택

### 3. 레포지토리 설정

**Repository name**: `youth-policy-figma` (또는 원하는 이름)

**Description**: `청년있슈 - 청년 정책 통합 플랫폼 (Figma 프로토타입)`

**Public / Private**:
- ✅ **Public** (공개)
- ⬜ Private (비공개)

**Initialize this repository**:
- ⬜ Add a README file (이미 있음)
- ⬜ Add .gitignore (이미 있음)
- ⬜ Choose a license (선택사항)

### 4. Create repository 클릭

---

## 로컬 코드 Push

### 1. 원격 저장소 연결

GitHub에서 레포지토리를 만든 후, 다음 명령어를 실행합니다:

```bash
cd C:\WebWork\YouthV2-Figma

# 원격 저장소 추가 (YOUR_USERNAME을 실제 GitHub 사용자명으로 변경)
git remote add origin https://github.com/YOUR_USERNAME/youth-policy-figma.git

# 원격 저장소 확인
git remote -v
```

**출력 예시**:
```
origin  https://github.com/YOUR_USERNAME/youth-policy-figma.git (fetch)
origin  https://github.com/YOUR_USERNAME/youth-policy-figma.git (push)
```

### 2. 코드 Push

```bash
# 메인 브랜치로 push
git push -u origin master
```

또는 브랜치명이 `main`이면:

```bash
git branch -M main
git push -u origin main
```

### 3. GitHub에서 확인

1. https://github.com/YOUR_USERNAME/youth-policy-figma 접속
2. 파일들이 업로드되었는지 확인:
   - src/
   - public/
   - README.md
   - package.json
   - 등등...

---

## Vercel 배포

### 1. Vercel 가입/로그인

1. https://vercel.com 접속
2. **Sign Up** (가입) 또는 **Log In** (로그인)
3. GitHub 계정으로 연동

### 2. 새 프로젝트 Import

1. Vercel 대시보드에서 **Add New...** → **Project** 클릭
2. **Import Git Repository** 섹션에서 `youth-policy-figma` 검색
3. **Import** 클릭

### 3. 프로젝트 설정

**Project Name**: `youth-policy-figma` (자동 입력됨)

**Framework Preset**: `Other` 선택 (Quasar는 자동 감지되지 않을 수 있음)

**Build and Output Settings**:

```
Build Command: npm run build
Output Directory: dist/spa
Install Command: npm install
```

**Environment Variables**: (현재 없음)

### 4. Deploy 클릭

- 빌드 시작
- 약 2~3분 소요
- 완료 후 배포 URL 생성

### 5. 배포 URL 확인

배포 완료 후:
- **Production URL**: `https://youth-policy-figma.vercel.app`
- 또는 커스텀 도메인 설정 가능

---

## 배포 후 확인 사항

### 1. 기본 기능 테스트

- [ ] 메인 페이지 로딩
- [ ] 헤더 네비게이션 작동
- [ ] 5개 카테고리 카드 표시
- [ ] 히어로 슬라이드 자동 재생
- [ ] 사이드바 표시 (데스크톱)

### 2. 페이지 이동 테스트

- [ ] 일자리 카테고리 페이지 이동
- [ ] 주거 카테고리 페이지 이동
- [ ] 교육 카테고리 페이지 이동
- [ ] 금융･복지･문화 카테고리 페이지 이동
- [ ] 참여 카테고리 페이지 이동
- [ ] 로그인 페이지 이동
- [ ] 회원가입 페이지 이동
- [ ] 준비중 페이지 이동

### 3. 반응형 테스트

**모바일 (< 768px)**:
- [ ] 햄버거 메뉴 표시
- [ ] 카드 1열 레이아웃
- [ ] 사이드바 숨김

**태블릿 (768px ~ 1024px)**:
- [ ] 카드 2열 레이아웃
- [ ] 사이드바 숨김

**데스크톱 (≥ 1024px)**:
- [ ] 카드 3열 레이아웃
- [ ] 사이드바 표시

### 4. 이미지 로딩 테스트

- [ ] 히어로 슬라이드 이미지 (3개)
- [ ] 정책 썸네일 이미지 (카테고리별 3개)
- [ ] 영상 썸네일 이미지 (카테고리별 3개)

### 5. 성능 확인

**Lighthouse 점수 확인**:

1. 브라우저에서 F12 → Lighthouse 탭
2. **Analyze page load** 클릭
3. 점수 확인:
   - Performance: 90+ 목표
   - Accessibility: 90+ 목표
   - Best Practices: 90+ 목표
   - SEO: 90+ 목표

---

## 추가 설정

### 커스텀 도메인 연결

1. Vercel 프로젝트 설정 → **Domains** 탭
2. **Add Domain** 클릭
3. 도메인 입력 (예: `youth-policy.com`)
4. DNS 레코드 설정:
   ```
   Type: A
   Name: @
   Value: 76.76.21.21
   ```
5. Vercel에서 SSL 인증서 자동 발급

### 환경 변수 설정 (향후)

1. Vercel 프로젝트 설정 → **Environment Variables** 탭
2. **Add** 클릭
3. 키-값 추가:
   ```
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```
4. **Save** 클릭
5. 재배포 (Redeploy)

---

## 자동 배포 설정

Vercel은 GitHub와 연동되어 있으므로:

### 자동 배포 트리거

1. **메인 브랜치 Push**:
   ```bash
   git push origin main
   ```
   → 자동으로 프로덕션 배포

2. **다른 브랜치 Push**:
   ```bash
   git push origin feature/new-feature
   ```
   → 자동으로 프리뷰 배포

3. **Pull Request 생성**:
   → 자동으로 프리뷰 URL 생성

### 배포 중단

특정 커밋의 배포를 중단하려면:

1. Vercel 대시보드 → **Deployments** 탭
2. 해당 배포 클릭
3. **•••** 메뉴 → **Cancel Deployment**

---

## 트러블슈팅

### 빌드 실패: "Command not found: quasar"

**원인**: Quasar CLI가 글로벌로 설치되지 않음

**해결**: Build Command를 `npm run build`로 변경

---

### 배포 후 빈 화면

**원인**: Output Directory 설정 오류

**해결**: Output Directory를 `dist/spa`로 정확히 설정

---

### 이미지가 안 보임

**원인**: 이미지 경로 오류

**해결**:
1. 이미지 경로 확인: `/src/assets/images/...`
2. 빌드 후 `dist/spa/assets/` 폴더에 이미지가 있는지 확인

---

### 404 에러 (새로고침 시)

**원인**: SPA 라우팅 설정 필요

**해결**:
Vercel은 자동으로 SPA 라우팅을 처리하지만, 문제가 있다면 `vercel.json` 추가:

```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

---

## 명령어 요약

```bash
# 1. GitHub 원격 저장소 연결
cd C:\WebWork\YouthV2-Figma
git remote add origin https://github.com/YOUR_USERNAME/youth-policy-figma.git

# 2. 코드 Push
git push -u origin master

# 3. 이후 변경사항 Push
git add .
git commit -m "Update: 변경 내용"
git push

# 4. 브랜치 작업 (선택사항)
git checkout -b feature/new-feature
git push -u origin feature/new-feature
```

---

## 다음 단계

배포 완료 후:

1. **README.md 업데이트**:
   - 배포 URL 추가
   - 배포 뱃지 추가

2. **환경 변수 설정** (Supabase 연동 시)

3. **도메인 연결** (선택사항)

4. **모니터링 설정**:
   - Vercel Analytics 활성화
   - 에러 추적 (Sentry 등)

---

## 참고 자료

- [Vercel 공식 문서](https://vercel.com/docs)
- [GitHub 가이드](https://docs.github.com/en/get-started)
- [Quasar 배포 가이드](https://quasar.dev/quasar-cli-vite/developing-spa/deploying)

---

**배포를 축하합니다!** 🎉

프로젝트 URL: `https://youth-policy-figma.vercel.app` (배포 후 확인)

**마지막 업데이트**: 2026-01-22
