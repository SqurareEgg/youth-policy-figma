<template>
  <router-view />
</template>

<script setup lang="ts">
// Supabase 인증 비활성화 - 필요시 주석 해제
// import { onMounted } from 'vue'
// import { useAuth } from './composables/useAuth'

// const { initializeAuth } = useAuth()

// onMounted(async () => {
//   console.log('🚀 [App] 애플리케이션 마운트 완료')
//   await initializeAuth()
//   console.log('✅ [App] 세션 초기화 완료')
// })
</script>
