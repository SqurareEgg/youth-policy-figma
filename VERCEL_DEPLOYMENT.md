# Vercel 배포 및 환경 변수 설정 가이드

## 현재 배포 URL
- **Production**: https://youth-policy-figma.vercel.app

---

## 1단계: Vercel 환경 변수 설정

### Vercel Dashboard 접속

1. https://vercel.com 접속
2. 로그인 (GitHub 계정)
3. **youth-policy-figma** 프로젝트 선택

### 환경 변수 추가

1. 프로젝트 페이지에서 **Settings** 클릭
2. 왼쪽 메뉴에서 **Environment Variables** 클릭
3. 다음 환경 변수 추가:

#### VITE_SUPABASE_URL

```
Name: VITE_SUPABASE_URL
Value: https://kgfrjqjrhdqvrzcuqtaw.supabase.co
```

- **Environment**: Production, Preview, Development 모두 체크
- **Add** 버튼 클릭

#### VITE_SUPABASE_ANON_KEY

```
Name: VITE_SUPABASE_ANON_KEY
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnZnJqcWpyaGRxdnJ6Y3VxdGF3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzNDQwMjIsImV4cCI6MjA4NDkyMDAyMn0.hUxPZaJ1qBkhO85JpQ2cTeSJWx_hBJfxuUszMuX9nj0
```

- **Environment**: Production, Preview, Development 모두 체크
- **Add** 버튼 클릭

### 환경 변수 확인

설정 후 다음과 같이 표시되어야 합니다:

| Name | Value | Environment |
|------|-------|-------------|
| VITE_SUPABASE_URL | https://kgfr... | Production, Preview, Development |
| VITE_SUPABASE_ANON_KEY | eyJhbGci... | Production, Preview, Development |

---

## 2단계: 재배포

환경 변수를 추가한 후 재배포해야 합니다.

### 자동 재배포 (GitHub Push)

GitHub에 푸시하면 자동으로 재배포됩니다:

```bash
git push origin main
```

Vercel이 자동으로 감지하고 배포를 시작합니다.

### 수동 재배포

Vercel Dashboard에서 수동으로 재배포:

1. 프로젝트 페이지에서 **Deployments** 탭 클릭
2. 최신 배포 옆의 **...** (더보기) 클릭
3. **Redeploy** 클릭
4. **Redeploy** 버튼 다시 클릭하여 확인

---

## 3단계: 배포 상태 확인

### 배포 진행 상황 확인

1. **Deployments** 탭에서 진행 상황 확인
2. 배포가 완료되면 "Ready" 상태로 변경
3. 배포 로그 확인 (오류가 있는 경우)

### 배포 성공 확인

배포가 완료되면:
- ✅ Status: **Ready**
- ✅ Duration: 약 1-2분
- ✅ URL: https://youth-policy-figma.vercel.app

---

## 4단계: 배포된 사이트 테스트

### 1. 메인 페이지 확인

https://youth-policy-figma.vercel.app 접속

**확인 사항**:
- ✅ 5개 카테고리 카드 표시
- ✅ 헤더, 푸터 정상 표시
- ✅ 사이드바 정상 작동

### 2. 회원가입 테스트

https://youth-policy-figma.vercel.app/signup 접속

**확인 사항**:
1. 이메일 입력 후 "인증번호 발송" 클릭
2. ✅ 이메일로 6자리 인증번호 수신 확인
3. 인증번호 입력 후 "인증 확인" 클릭
4. ✅ 추가 정보 입력 폼 표시
5. 정보 입력 후 "회원가입 완료" 클릭
6. ✅ 메인 페이지로 리다이렉트

⚠️ **주의**: 이메일이 스팸 메일함으로 갈 수 있습니다!

### 3. 로그인 테스트

https://youth-policy-figma.vercel.app/login 접속

**확인 사항**:
1. 방금 가입한 이메일과 비밀번호 입력
   - ⚠️ 이메일 인증 방식은 비밀번호가 없으므로, 이메일 인증번호로 로그인해야 합니다
2. ✅ 로그인 성공 후 메인 페이지로 이동

### 4. 카테고리 페이지 테스트

https://youth-policy-figma.vercel.app/category/job 접속

**확인 사항**:
- ✅ 정책 목록 표시 (2개)
- ✅ Q&A 표시 (5개)
- ✅ 학습영상 표시 (3개)
- ✅ OX퀴즈 표시 (2개)
- ✅ 이수율 표시 (로그인 시)

---

## 5단계: Supabase 데이터베이스 설정

배포된 사이트가 작동하려면 Supabase에 데이터가 있어야 합니다.

### Supabase Dashboard 확인

1. https://supabase.com 접속
2. 프로젝트 선택 (kgfrjqjrhdqvrzcuqtaw)
3. **SQL Editor** 클릭

### 스키마 실행 (처음 1회만)

`supabase-schema.sql` 파일 내용을 복사하여 실행:

1. **New query** 클릭
2. `supabase-schema.sql` 전체 내용 복사 붙여넣기
3. **Run** 버튼 클릭
4. ✅ "Success" 메시지 확인

### 시드 데이터 실행 (처음 1회만)

`supabase-seed-data.sql` 파일 내용을 복사하여 실행:

1. **New query** 클릭
2. `supabase-seed-data.sql` 전체 내용 복사 붙여넣기
3. **Run** 버튼 클릭
4. ✅ "Success" 메시지 확인

### 데이터 확인

**Table Editor**에서 확인:

1. **Table Editor** 클릭
2. 다음 테이블에 데이터가 있는지 확인:
   - ✅ `categories` - 5개
   - ✅ `policies` - 6개
   - ✅ `videos` - 15개
   - ✅ `quizzes` - 6개
   - ✅ `qna` - 10개

---

## 6단계: 이메일 인증 설정

### Supabase 이메일 설정 확인

1. **Authentication** > **Providers** 클릭
2. **Email** 섹션 확인:
   - ✅ Enable Email provider: ON
   - ✅ Enable Email OTP: ON
   - ⚠️ Confirm email: OFF (개발 시)

### 이메일 템플릿 확인

1. **Authentication** > **Email Templates** 클릭
2. **Magic Link** 템플릿 확인
3. 필요 시 커스터마이징

### SMTP 설정 (선택사항)

프로덕션에서는 커스텀 SMTP를 권장합니다:
- **SendGrid** (무료: 일 100개)
- **AWS SES** (무료: 월 62,000개)

자세한 내용은 `SUPABASE_EMAIL_SETUP.md` 참고

---

## 문제 해결

### Q1. 배포 실패: "Missing environment variables"

**원인**: 환경 변수가 설정되지 않음

**해결**:
1. Vercel Dashboard > Settings > Environment Variables
2. `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` 추가
3. 재배포

### Q2. 배포 성공했지만 데이터가 안 보임

**원인**: Supabase 데이터베이스에 데이터가 없음

**해결**:
1. Supabase Dashboard > SQL Editor
2. `supabase-schema.sql` 실행
3. `supabase-seed-data.sql` 실행
4. Table Editor에서 데이터 확인

### Q3. 회원가입 시 이메일이 안 와요

**원인**: Supabase 이메일 설정 문제 또는 Rate Limit

**해결**:
1. 스팸 메일함 확인
2. Supabase Dashboard > Authentication > Email 설정 확인
3. Rate Limit 확인 (시간당 3-4개)
4. `SUPABASE_EMAIL_SETUP.md` 참고

### Q4. 로그인이 안 돼요

**원인**: 이메일 인증 방식으로 가입한 경우 비밀번호가 없음

**해결**:
- 이메일 인증번호 방식으로 로그인
- 또는 회원가입 시 비밀번호 설정 (기능 추가 필요)

### Q5. 카테고리 페이지가 비어있어요

**원인**: 카테고리 slug가 잘못되었거나 데이터가 없음

**해결**:
1. URL 확인: `/category/job` (올바른 형식)
2. Supabase Table Editor에서 `categories` 확인
3. `categories.slug` 값 확인 (job, housing, education 등)

---

## 배포 완료 체크리스트

### Vercel 설정
- [ ] 환경 변수 `VITE_SUPABASE_URL` 추가
- [ ] 환경 변수 `VITE_SUPABASE_ANON_KEY` 추가
- [ ] 재배포 완료
- [ ] 배포 상태 "Ready" 확인

### Supabase 설정
- [ ] `supabase-schema.sql` 실행
- [ ] `supabase-seed-data.sql` 실행
- [ ] Table Editor에서 데이터 확인
- [ ] Email OTP 활성화 확인

### 기능 테스트
- [ ] 메인 페이지 5개 카테고리 표시
- [ ] 회원가입 (이메일 인증번호 방식)
- [ ] 이메일 수신 확인
- [ ] 로그인
- [ ] 카테고리 페이지 데이터 표시

---

## 다음 단계

배포가 완료되면:
1. ✅ **실제 사용자 테스트**
2. 추가 기능 구현:
   - 영상 재생 페이지
   - 퀴즈 페이지
   - 정책 상세 페이지
   - 커뮤니티 (청년정책카페)
   - 마이페이지
3. 이메일 SMTP 설정 (SendGrid 또는 AWS SES)
4. 도메인 연결 (선택사항)

---

## 참고 문서

- [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md) - Supabase 통합 완료 가이드
- [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) - Supabase 프로젝트 설정
- [SUPABASE_EMAIL_SETUP.md](./SUPABASE_EMAIL_SETUP.md) - 이메일 인증 설정
- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) - 데이터베이스 스키마
- [COMPLETION_RATE_GUIDE.md](./COMPLETION_RATE_GUIDE.md) - 이수율 계산 가이드
