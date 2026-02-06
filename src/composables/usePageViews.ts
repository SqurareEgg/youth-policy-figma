import { supabase } from '../lib/supabase'

// 세션 ID 생성 및 관리
const SESSION_KEY = 'youth_session_id'

// 브라우저 세션 ID 가져오기 또는 생성
function getOrCreateSessionId(): string {
  let sessionId = sessionStorage.getItem(SESSION_KEY)

  if (!sessionId) {
    // UUID v4 생성
    sessionId = crypto.randomUUID()
    sessionStorage.setItem(SESSION_KEY, sessionId)
  }

  return sessionId
}

export function usePageViews() {
  // 페이지뷰 기록
  const trackPageView = async (pagePath: string) => {
    try {
      const sessionId = getOrCreateSessionId()

      // 브라우저 정보 수집
      const userAgent = navigator.userAgent
      const referrer = document.referrer || null

      // Supabase에 페이지뷰 기록
      const { error } = await supabase
        .from('page_views')
        .insert({
          session_id: sessionId,
          page_path: pagePath,
          referrer: referrer,
          user_agent: userAgent
        })

      if (error) {
        console.error('페이지뷰 기록 에러:', error)
        return { success: false, error: error.message }
      }

      return { success: true }
    } catch (error: any) {
      console.error('페이지뷰 추적 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 전체 통계 조회
  const getTotalStats = async () => {
    try {
      const { data, error } = await supabase
        .from('page_views')
        .select('session_id, created_at')

      if (error) throw error

      // 전체 방문 수
      const totalViews = data?.length || 0

      // 고유 방문자 수
      const uniqueVisitors = new Set(data?.map(view => view.session_id)).size

      return {
        success: true,
        stats: {
          totalViews,
          uniqueVisitors
        }
      }
    } catch (error: any) {
      console.error('통계 조회 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 페이지별 통계 조회
  const getPageStats = async () => {
    try {
      const { data, error } = await supabase
        .from('page_views')
        .select('page_path, session_id')

      if (error) throw error

      // 페이지별 그룹화
      const pageStats = data?.reduce((acc, view) => {
        if (!acc[view.page_path]) {
          acc[view.page_path] = {
            path: view.page_path,
            totalViews: 0,
            uniqueVisitors: new Set()
          }
        }
        acc[view.page_path].totalViews++
        acc[view.page_path].uniqueVisitors.add(view.session_id)
        return acc
      }, {} as Record<string, any>)

      // Set을 숫자로 변환
      const formattedStats = Object.values(pageStats || {}).map(stat => ({
        path: stat.path,
        totalViews: stat.totalViews,
        uniqueVisitors: stat.uniqueVisitors.size
      }))

      return {
        success: true,
        stats: formattedStats
      }
    } catch (error: any) {
      console.error('페이지별 통계 조회 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  // 일별 통계 조회 (최근 30일)
  const getDailyStats = async (days: number = 30) => {
    try {
      const startDate = new Date()
      startDate.setDate(startDate.getDate() - days)

      const { data, error } = await supabase
        .from('page_views')
        .select('created_at, session_id')
        .gte('created_at', startDate.toISOString())
        .order('created_at', { ascending: true })

      if (error) throw error

      // 일별 그룹화
      const dailyStats = data?.reduce((acc, view) => {
        const date = new Date(view.created_at).toLocaleDateString('ko-KR')
        if (!acc[date]) {
          acc[date] = {
            date,
            totalViews: 0,
            uniqueVisitors: new Set()
          }
        }
        acc[date].totalViews++
        acc[date].uniqueVisitors.add(view.session_id)
        return acc
      }, {} as Record<string, any>)

      // Set을 숫자로 변환
      const formattedStats = Object.values(dailyStats || {}).map(stat => ({
        date: stat.date,
        totalViews: stat.totalViews,
        uniqueVisitors: stat.uniqueVisitors.size
      }))

      return {
        success: true,
        stats: formattedStats
      }
    } catch (error: any) {
      console.error('일별 통계 조회 에러:', error.message)
      return { success: false, error: error.message }
    }
  }

  return {
    trackPageView,
    getTotalStats,
    getPageStats,
    getDailyStats
  }
}
