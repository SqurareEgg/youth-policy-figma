/**
 * Vue Router 설정
 */

import { route } from 'quasar/wrappers'
import { createRouter, createMemoryHistory, createWebHistory, createWebHashHistory } from 'vue-router'
import routes from './routes'
import { supabase } from '../lib/supabase'
import { usePageViews } from '../composables/usePageViews'

export default route(function (/* { store, ssrContext } */) {
  const createHistory = process.env.SERVER
    ? createMemoryHistory
    : (process.env.VUE_ROUTER_MODE === 'history' ? createWebHistory : createWebHashHistory)

  const Router = createRouter({
    scrollBehavior: () => ({ left: 0, top: 0 }),
    routes,

    // Leave this as is and make changes in quasar.conf.js instead!
    history: createHistory(process.env.VUE_ROUTER_BASE)
  })

  // 인증 필요한 페이지 보호
  Router.beforeEach(async (to, from, next) => {
    // requiresAuth 메타 필드가 있는 라우트 체크
    if (to.meta.requiresAuth) {
      const { data: { session } } = await supabase.auth.getSession()

      if (!session) {
        // 로그인하지 않았으면 로그인 페이지로 리다이렉트
        console.log('🔒 [Router] 인증 필요 - 로그인 페이지로 이동')
        next({
          name: 'login',
          query: { redirect: to.fullPath } // 로그인 후 돌아올 경로 저장
        })
      } else {
        // 로그인 되어 있으면 진행
        next()
      }
    } else {
      // 인증 불필요한 페이지는 그냥 진행
      next()
    }
  })

  // 페이지뷰 추적 (페이지 이동 후 실행)
  Router.afterEach((to, from) => {
    const { trackPageView } = usePageViews()

    // 페이지뷰 기록
    trackPageView(to.path).catch(err => {
      console.error('📊 [Router] 페이지뷰 기록 실패:', err)
    })
  })

  console.log('🔧 [Router] 라우터 초기화 완료')

  return Router
})
