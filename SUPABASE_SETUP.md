# Supabase 설정 가이드

## 1단계: Supabase 프로젝트 생성

### 1. Supabase 계정 생성 및 프로젝트 생성

1. https://supabase.com 접속
2. "Start your project" 클릭
3. GitHub 계정으로 로그인
4. "New project" 클릭
5. 프로젝트 정보 입력:
   - **Name**: `youth-policy` (또는 원하는 이름)
   - **Database Password**: 강력한 비밀번호 생성 (잘 보관하세요!)
   - **Region**: `Northeast Asia (Seoul)` 선택 (한국 사용자용)
   - **Pricing Plan**: Free 선택

6. "Create new project" 클릭 후 약 2분 대기

---

## 2단계: 데이터베이스 스키마 생성

### SQL Editor에서 스키마 실행

1. 왼쪽 메뉴에서 **SQL Editor** 클릭
2. "New query" 클릭
3. `supabase-schema.sql` 파일 내용 전체 복사 붙여넣기
4. **Run** 버튼 클릭 (또는 Ctrl+Enter)
5. ✅ "Success. No rows returned" 메시지 확인

### 초기 데이터 입력

1. SQL Editor에서 "New query" 클릭
2. `supabase-seed-data.sql` 파일 내용 전체 복사 붙여넣기
3. **Run** 버튼 클릭
4. ✅ "Success" 메시지 확인

---

## 3단계: API 키 확인

1. 왼쪽 메뉴에서 **Settings** (톱니바퀴 아이콘) 클릭
2. **API** 메뉴 클릭
3. 다음 두 값을 복사해두세요:

   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

⚠️ **주의**: `service_role` 키는 절대 프론트엔드에 사용하지 마세요! (보안 위험)

---

## 4단계: 인증 설정 (선택사항)

### 이메일 인증 활성화

1. 왼쪽 메뉴에서 **Authentication** 클릭
2. **Providers** 탭 클릭
3. **Email** provider가 활성화되어 있는지 확인
4. **Settings** 탭에서 다음 설정:
   - **Enable email confirmations**: OFF (개발 시 편의를 위해)
   - 배포 시에는 ON으로 변경 권장

---

## 5단계: 데이터 확인

### Table Editor에서 데이터 확인

1. 왼쪽 메뉴에서 **Table Editor** 클릭
2. 다음 테이블들이 생성되었는지 확인:
   - `categories` (5개 카테고리)
   - `policies` (6개 정책)
   - `policy_details`
   - `videos`
   - `quizzes`
   - `qna`
   - `profiles` (비어있음, 회원가입 시 자동 생성)

3. `categories` 테이블 클릭하여 5개 카테고리 확인:
   - 일자리
   - 주거
   - 교육
   - 금융･복지･문화
   - 참여

---

## 6단계: Row Level Security 확인

### RLS 정책 확인

1. 왼쪽 메뉴에서 **Authentication** > **Policies** 클릭
2. 각 테이블별로 RLS 정책이 활성화되어 있는지 확인
3. `profiles` 테이블의 정책 예시:
   - "Users can view own profile"
   - "Users can update own profile"

---

## 완료 체크리스트

- [ ] Supabase 프로젝트 생성 완료
- [ ] `supabase-schema.sql` 실행 완료
- [ ] `supabase-seed-data.sql` 실행 완료
- [ ] Project URL 복사
- [ ] anon public key 복사
- [ ] Table Editor에서 5개 카테고리 확인
- [ ] Table Editor에서 6개 정책 확인

---

## 다음 단계

환경 변수 설정을 위해 복사한 값들을 `.env` 파일에 입력하세요:

```env
VITE_SUPABASE_URL=your-project-url
VITE_SUPABASE_ANON_KEY=your-anon-key
```

---

## 문제 해결

### Q: SQL 실행 시 에러가 발생해요
**A**: 에러 메시지를 확인하고, 이미 테이블이 존재하는 경우 Table Editor에서 삭제 후 재시도하세요.

### Q: RLS 정책이 안 보여요
**A**: SQL이 정상 실행되었다면 정책이 자동으로 생성됩니다. Authentication > Policies에서 확인하세요.

### Q: 테이블은 생성되었는데 데이터가 없어요
**A**: `supabase-seed-data.sql`을 실행했는지 확인하세요.
