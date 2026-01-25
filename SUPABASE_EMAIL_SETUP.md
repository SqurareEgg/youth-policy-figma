# Supabase 이메일 인증 설정 가이드

## 개요

회원가입 시 이메일 인증번호(OTP) 방식을 사용하려면 Supabase에서 이메일 설정을 확인해야 합니다.

---

## 1단계: Supabase Dashboard 접속

1. https://supabase.com 접속
2. 프로젝트 선택 (youth-policy 또는 해당 프로젝트)

---

## 2단계: 이메일 인증 확인

### Authentication 설정

1. 왼쪽 메뉴에서 **Authentication** 클릭
2. **Providers** 탭 클릭
3. **Email** 섹션 확인

### 기본 설정 (Free 플랜)

Supabase Free 플랜에서는 기본적으로 다음과 같이 설정되어 있습니다:

- **Enable Email provider**: ✅ ON (활성화됨)
- **Enable Email OTP**: ✅ ON (활성화됨)
- **Confirm email**: ⚠️ OFF (이메일 확인 비활성화)

### 권장 설정

**개발 환경 (현재)**
- **Confirm email**: OFF
  - 개발 시 빠른 테스트를 위해 비활성화
  - 인증번호만으로 회원가입 완료

**프로덕션 환경 (배포 시)**
- **Confirm email**: ON
  - 실제 이메일 확인 필요
  - 더 안전한 회원가입 프로세스

---

## 3단계: 이메일 템플릿 확인

### Email Templates 설정

1. **Authentication** > **Email Templates** 클릭
2. 다음 템플릿 확인:
   - **Magic Link** - 이메일 인증번호 템플릿
   - **Confirm signup** - 회원가입 확인 이메일

### Magic Link 템플릿 (OTP 발송)

기본 템플릿에는 6자리 인증번호가 포함됩니다:

```
Your verification code is: {{ .Token }}
```

원하는 경우 템플릿을 커스터마이징할 수 있습니다.

---

## 4단계: SMTP 설정 (선택사항)

### 기본 설정 (Supabase 이메일 서버)

Free 플랜에서는 Supabase의 기본 이메일 서버를 사용합니다:
- 발신자: noreply@mail.app.supabase.io
- 시간당 발송 제한: 3-4개 (개발 테스트용)

⚠️ **주의**: 기본 이메일 서버는 스팸 메일함으로 분류될 수 있습니다.

### 커스텀 SMTP 설정 (프로덕션 권장)

실제 서비스에서는 커스텀 SMTP를 설정하는 것을 권장합니다:

1. **Project Settings** > **Auth** 클릭
2. **SMTP Settings** 섹션
3. 이메일 서비스 선택:
   - **SendGrid** (무료 플랜: 일 100개)
   - **AWS SES** (무료 플랜: 월 62,000개)
   - **Gmail** (간단하지만 제한적)

#### Gmail SMTP 설정 예시

```
SMTP Host: smtp.gmail.com
SMTP Port: 587
SMTP User: your-email@gmail.com
SMTP Password: your-app-password
Sender Email: your-email@gmail.com
Sender Name: 청년있슈
```

⚠️ Gmail의 경우 "앱 비밀번호"를 생성해야 합니다:
1. Google 계정 설정
2. 보안 > 2단계 인증 활성화
3. 앱 비밀번호 생성

---

## 5단계: 이메일 발송 테스트

### 개발 환경에서 테스트

1. 회원가입 페이지 접속 (http://localhost:9003/signup)
2. 이메일 입력 (본인 이메일 권장)
3. "인증번호 발송" 클릭
4. 이메일 확인 (스팸 메일함도 확인!)
5. 6자리 인증번호 입력
6. 회원가입 완료

### 테스트 이메일 주소

Supabase는 다음 테스트 이메일을 자동으로 차단합니다:
- ❌ temp-mail.org
- ❌ 10minutemail.com
- ❌ guerrillamail.com

실제 이메일 주소를 사용하세요.

---

## 6단계: 문제 해결

### Q1. 이메일이 오지 않아요

**확인 사항**:
1. 스팸 메일함 확인
2. Supabase Dashboard > Authentication > Users에서 사용자 생성 확인
3. Supabase Dashboard > Logs에서 이메일 발송 로그 확인

**해결 방법**:
- 다른 이메일 주소로 재시도
- SMTP 설정 확인
- Rate Limit 확인 (시간당 3-4개 제한)

### Q2. "Email rate limit exceeded" 에러

**원인**: Supabase Free 플랜의 시간당 발송 제한 초과

**해결 방법**:
- 1시간 대기 후 재시도
- 또는 커스텀 SMTP 설정 (SendGrid, AWS SES)

### Q3. 인증번호가 틀렸다고 나와요

**확인 사항**:
1. 인증번호 6자리 정확히 입력 (공백 없이)
2. 최근 발송된 이메일의 인증번호인지 확인
3. 인증번호 유효 시간 확인 (기본 60분)

**해결 방법**:
- "이메일 변경" 클릭 후 다시 인증번호 발송

### Q4. 회원가입 후 자동 로그인이 안 돼요

**원인**: `verifyOtp` 성공 후 세션이 생성되지만 프로필 정보가 없음

**해결 방법**:
- 이미 구현됨: `completeSignup` 함수에서 프로필 정보 업데이트
- 회원가입 완료 후 자동 로그인 상태

---

## 7단계: 배포 시 권장 설정

### Supabase 설정

1. **Confirm email**: ON
2. **커스텀 SMTP** 설정 (SendGrid 또는 AWS SES)
3. **Rate limiting** 확인
4. **이메일 템플릿** 커스터마이징

### 이메일 템플릿 예시

```html
<h2>청년있슈 회원가입 인증</h2>
<p>안녕하세요!</p>
<p>아래 인증번호를 입력하여 회원가입을 완료해주세요.</p>
<h1 style="color: #F97316; font-size: 32px; letter-spacing: 8px;">
  {{ .Token }}
</h1>
<p>이 인증번호는 60분 동안 유효합니다.</p>
<p>본인이 요청하지 않았다면 이 이메일을 무시해주세요.</p>
```

---

## 8단계: 보안 강화

### Rate Limiting

Supabase는 기본적으로 다음과 같은 Rate Limit을 적용합니다:
- **이메일 발송**: 시간당 3-4개 (Free 플랜)
- **인증 시도**: 분당 5회

### IP 차단

악의적인 사용자를 차단하려면:
1. **Authentication** > **Rate Limits**
2. Custom rate limits 설정

### 이메일 도메인 화이트리스트

특정 도메인만 허용하려면:
1. Supabase Functions 사용
2. Edge Function에서 이메일 도메인 검증

---

## 체크리스트

### 개발 환경
- [ ] Supabase 이메일 인증 활성화 확인
- [ ] 테스트 이메일로 인증번호 발송 테스트
- [ ] 인증번호 입력 및 회원가입 완료 테스트
- [ ] 프로필 정보 저장 확인

### 프로덕션 환경
- [ ] 커스텀 SMTP 설정 (SendGrid/AWS SES)
- [ ] 이메일 템플릿 커스터마이징
- [ ] Confirm email ON으로 변경
- [ ] Rate limiting 설정
- [ ] 발신자 도메인 인증 (SPF, DKIM)

---

## 다음 단계

이메일 설정이 완료되면:
1. 로컬에서 테스트
2. GitHub에 푸시
3. Vercel에 환경 변수 설정
4. 배포 후 실제 이메일로 테스트

---

## 참고 자료

- [Supabase Email OTP 공식 문서](https://supabase.com/docs/guides/auth/auth-email-otp)
- [Supabase SMTP 설정](https://supabase.com/docs/guides/auth/auth-smtp)
- [SendGrid 무료 플랜](https://sendgrid.com/pricing/)
- [AWS SES 요금](https://aws.amazon.com/ses/pricing/)
