import { ref, computed, onMounted } from 'vue'
import { supabase } from '../lib/supabase'
import type { User, Session } from '@supabase/supabase-js'
import type { Database } from '../types/supabase'

type Profile = Database['public']['Tables']['profiles']['Row']

const user = ref<User | null>(null)
const session = ref<Session | null>(null)
const profile = ref<Profile | null>(null)
const loading = ref(true)

export function useAuth() {
  const isAuthenticated = computed(() => !!user.value)

  // 로그인
  const signIn = async (email: string, password: string) => {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })

      if (error) throw error

      user.value = data.user
      session.value = data.session

      // 프로필 가져오기
      await fetchProfile()

      return { success: true, user: data.user }
    } catch (error: any) {
      console.error('로그인 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 이메일 인증번호 발송
  const sendOtp = async (email: string) => {
    try {
      const { error } = await supabase.auth.signInWithOtp({
        email,
        options: {
          shouldCreateUser: true,
          emailRedirectTo: window.location.origin
        }
      })

      if (error) throw error

      return { success: true }
    } catch (error: any) {
      console.error('인증번호 발송 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 이메일 인증번호 확인
  const verifyOtp = async (email: string, token: string) => {
    try {
      const { data, error } = await supabase.auth.verifyOtp({
        email,
        token,
        type: 'email'
      })

      if (error) throw error
      if (!data.user) throw new Error('인증 실패')

      user.value = data.user
      session.value = data.session

      return { success: true, user: data.user }
    } catch (error: any) {
      console.error('인증번호 확인 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 회원가입 (기존 비밀번호 방식 - 레거시)
  const signUp = async (
    email: string,
    password: string,
    name: string,
    birthDate: string,
    phone: string,
    agreements: {
      terms: boolean
      privacy: boolean
      marketing: boolean
    }
  ) => {
    try {
      // 1. Auth 사용자 생성
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password
      })

      if (authError) throw authError
      if (!authData.user) throw new Error('사용자 생성 실패')

      // 2. 프로필 업데이트 (트리거로 이미 생성됨)
      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          name,
          birth_date: birthDate,
          phone,
          terms_agreed: agreements.terms,
          privacy_agreed: agreements.privacy,
          marketing_agreed: agreements.marketing
        })
        .eq('id', authData.user.id)

      if (profileError) throw profileError

      user.value = authData.user
      session.value = authData.session

      await fetchProfile()

      return { success: true, user: authData.user }
    } catch (error: any) {
      console.error('회원가입 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 인증번호 확인 후 프로필 정보 업데이트
  const completeSignup = async (
    name: string,
    birthDate: string,
    phone: string,
    agreements: {
      terms: boolean
      privacy: boolean
      marketing: boolean
    }
  ) => {
    if (!user.value) {
      return { success: false, error: '인증이 필요합니다' }
    }

    try {
      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          name,
          birth_date: birthDate,
          phone,
          terms_agreed: agreements.terms,
          privacy_agreed: agreements.privacy,
          marketing_agreed: agreements.marketing
        })
        .eq('id', user.value.id)

      if (profileError) throw profileError

      await fetchProfile()

      return { success: true }
    } catch (error: any) {
      console.error('프로필 업데이트 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 로그아웃
  const signOut = async () => {
    try {
      const { error } = await supabase.auth.signOut()
      if (error) throw error

      user.value = null
      session.value = null
      profile.value = null

      return { success: true }
    } catch (error: any) {
      console.error('로그아웃 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 프로필 가져오기
  const fetchProfile = async () => {
    if (!user.value) {
      profile.value = null
      return
    }

    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.value.id)
        .single()

      if (error) throw error

      profile.value = data
    } catch (error: any) {
      console.error('프로필 가져오기 에러:', error.message)
    }
  }

  // 프로필 업데이트
  const updateProfile = async (updates: Partial<Profile>) => {
    if (!user.value) {
      return { success: false, error: '로그인이 필요합니다' }
    }

    try {
      const { data, error } = await supabase
        .from('profiles')
        .update(updates)
        .eq('id', user.value.id)
        .select()
        .single()

      if (error) throw error

      profile.value = data

      return { success: true, profile: data }
    } catch (error: any) {
      console.error('프로필 업데이트 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 세션 초기화
  const initializeAuth = async () => {
    loading.value = true

    try {
      // 현재 세션 가져오기
      const { data: { session: currentSession } } = await supabase.auth.getSession()

      if (currentSession) {
        session.value = currentSession
        user.value = currentSession.user
        await fetchProfile()
      }

      // 인증 상태 변경 리스너
      supabase.auth.onAuthStateChange(async (_event, newSession) => {
        session.value = newSession
        user.value = newSession?.user ?? null

        if (newSession?.user) {
          await fetchProfile()
        } else {
          profile.value = null
        }
      })
    } catch (error: any) {
      console.error('인증 초기화 에러:', error.message)
    } finally {
      loading.value = false
    }
  }

  // 컴포넌트 마운트 시 자동 초기화
  onMounted(() => {
    if (!user.value && !loading.value) {
      initializeAuth()
    }
  })

  return {
    user,
    session,
    profile,
    loading,
    isAuthenticated,
    signIn,
    signUp,
    signOut,
    fetchProfile,
    updateProfile,
    initializeAuth,
    // 이메일 인증번호 관련
    sendOtp,
    verifyOtp,
    completeSignup
  }
}
