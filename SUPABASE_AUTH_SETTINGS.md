# Supabase 인증 설정 (이메일 확인 비활성화)

## ⚠️ 중요: 이메일 확인 비활성화 설정

회원가입 시 이메일 인증을 사용하지 않으므로 Supabase에서 이메일 확인을 비활성화해야 합니다.

---

## 1단계: Supabase Dashboard 접속

1. https://supabase.com 접속
2. 프로젝트 선택: **kgfrjqjrhdqvrzcuqtaw**

---

## 2단계: Email 확인 비활성화

### Authentication 설정

1. 왼쪽 메뉴에서 **Authentication** 클릭
2. **Providers** 탭 클릭
3. **Email** 섹션 찾기

### 설정 변경

다음과 같이 설정하세요:

| 설정 항목 | 값 |
|----------|-----|
| Enable Email provider | ✅ **ON** (활성화) |
| Confirm email | ❌ **OFF** (비활성화) ⬅️ 중요! |

**"Confirm email"을 OFF로 설정하는 방법**:

1. Email 섹션에서 **"Confirm email"** 토글 찾기
2. 토글을 클릭하여 **OFF** (회색)로 변경
3. 자동 저장됨

---

## 3단계: 설정 확인

### 올바른 설정 (현재 사용 중)

```
✅ Enable Email provider: ON
❌ Confirm email: OFF
❌ Enable Email OTP: OFF (사용하지 않음)
```

이렇게 설정하면:
- ✅ 이메일/비밀번호로 즉시 회원가입 가능
- ✅ 이메일 확인 없이 바로 로그인 가능
- ✅ 별도의 인증번호 발송 없음

### 잘못된 설정 (변경 필요)

```
✅ Enable Email provider: ON
✅ Confirm email: ON  ⬅️ 이것을 OFF로 변경해야 함!
```

이 상태에서는:
- ❌ 회원가입 후 이메일 확인 링크 클릭 필요
- ❌ 이메일 확인 전까지 로그인 불가
- ❌ 개발 중 불편함

---

## 4단계: 테스트

### 회원가입 테스트

1. http://localhost:9003/signup 또는 https://youth-policy-figma.vercel.app/signup 접속
2. 폼 작성:
   - 이메일: test@example.com
   - 비밀번호: password123
   - 이름: 테스터
   - 생년월일: 2000-01-01
   - 학교: 대전보건대학교
   - 학번: 20240001
   - 약관 동의 체크
3. "회원가입" 버튼 클릭
4. ✅ 즉시 회원가입 완료
5. ✅ 로그인 페이지로 자동 이동
6. ❌ 이메일 확인 불필요

### 로그인 테스트

1. http://localhost:9003/login 또는 https://youth-policy-figma.vercel.app/login 접속
2. 방금 가입한 이메일/비밀번호 입력
3. ✅ 즉시 로그인 성공

---

## 문제 해결

### Q1. 회원가입 후 "Email not confirmed" 에러

**원인**: Supabase에서 "Confirm email"이 ON으로 설정되어 있음

**해결**:
1. Supabase Dashboard > Authentication > Providers
2. Email 섹션의 "Confirm email" 토글을 **OFF**로 변경
3. 이미 가입한 사용자의 경우:
   - Table Editor > auth.users 테이블
   - 해당 사용자의 `email_confirmed_at` 컬럼을 현재 시각으로 수동 설정
   - 또는 새로 회원가입

### Q2. 회원가입은 되는데 로그인이 안 돼요

**원인**: 비밀번호가 너무 짧거나 이메일 형식이 잘못됨

**해결**:
- 비밀번호 최소 6자 이상
- 유효한 이메일 형식 사용

### Q3. 프로덕션에서 이메일 확인을 사용하고 싶어요

**프로덕션 배포 시 권장 설정**:

1. **개발 환경** (현재):
   ```
   Confirm email: OFF
   → 빠른 테스트 및 개발
   ```

2. **프로덕션 환경** (배포 후):
   ```
   Confirm email: ON
   → 보안 강화 및 실제 이메일 확인
   ```

프로덕션에서 이메일 확인을 사용하려면:
1. Confirm email을 ON으로 변경
2. 커스텀 SMTP 설정 (SendGrid, AWS SES)
3. 이메일 템플릿 커스터마이징
4. 회원가입 페이지를 다시 이메일 인증 방식으로 변경

---

## 현재 회원가입 플로우

```
1. 사용자가 회원가입 폼 작성
   ↓
2. 이메일/비밀번호/이름/생년월일/학교/학번 입력
   ↓
3. "회원가입" 버튼 클릭
   ↓
4. Supabase Auth에 사용자 생성
   ↓
5. 트리거로 profiles 테이블에 자동 생성
   ↓
6. 프로필 정보 업데이트 (이름, 생년월일, 학교, 학번 저장)
   ↓
7. ✅ 회원가입 완료 (이메일 확인 불필요)
   ↓
8. 로그인 페이지로 리다이렉트
   ↓
9. 이메일/비밀번호로 즉시 로그인 가능
```

---

## 체크리스트

### Supabase 설정
- [ ] Supabase Dashboard > Authentication > Providers 접속
- [ ] Email 섹션의 "Confirm email" 토글 확인
- [ ] "Confirm email"을 **OFF**로 변경
- [ ] 설정 자동 저장 확인

### 테스트
- [ ] 회원가입 테스트 (이메일 확인 없이 즉시 완료)
- [ ] 로그인 테스트 (즉시 로그인 가능)
- [ ] 프로필 정보 저장 확인 (Table Editor > profiles)

---

## 참고

이메일 확인 없이 회원가입을 허용하면:

**장점**:
- ✅ 빠른 회원가입 및 테스트
- ✅ 개발 중 편의성
- ✅ 이메일 발송 제한 걱정 없음

**단점**:
- ⚠️ 잘못된 이메일 주소로 가입 가능
- ⚠️ 스팸 계정 생성 가능
- ⚠️ 이메일 소유권 확인 불가

프로덕션 배포 시에는 이메일 확인을 활성화하는 것을 권장합니다.
