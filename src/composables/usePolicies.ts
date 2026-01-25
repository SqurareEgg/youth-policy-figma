import { ref } from 'vue'
import { supabase } from '../lib/supabase'
import type { Database } from '../types/supabase'

type PolicyFullView = Database['public']['Views']['policy_full_view']['Row']

export function usePolicies() {
  const policies = ref<PolicyFullView[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  // 카테고리별 정책 가져오기 (상세 정보 포함)
  const fetchPoliciesByCategory = async (categorySlug: string) => {
    loading.value = true
    error.value = null

    try {
      const { data, error: fetchError } = await supabase
        .from('policy_full_view')
        .select('*')
        .eq('category_slug', categorySlug)

      if (fetchError) throw fetchError

      policies.value = data || []
      return data
    } catch (err: any) {
      error.value = err.message
      console.error('정책 가져오기 에러:', err.message)
      return []
    } finally {
      loading.value = false
    }
  }

  // 정책 ID로 가져오기
  const getPolicyById = async (policyId: number) => {
    try {
      const { data, error: fetchError } = await supabase
        .from('policy_full_view')
        .select('*')
        .eq('id', policyId)
        .single()

      if (fetchError) throw fetchError

      return data
    } catch (err: any) {
      console.error('정책 가져오기 에러:', err.message)
      return null
    }
  }

  // 북마크 추가
  const addBookmark = async (userId: string, policyId: number) => {
    try {
      const { error: insertError } = await supabase
        .from('user_bookmarks')
        .insert({
          user_id: userId,
          policy_id: policyId
        })

      if (insertError) throw insertError

      return { success: true }
    } catch (err: any) {
      console.error('북마크 추가 에러:', err.message)
      return { success: false, error: err.message }
    }
  }

  // 북마크 삭제
  const removeBookmark = async (userId: string, policyId: number) => {
    try {
      const { error: deleteError } = await supabase
        .from('user_bookmarks')
        .delete()
        .eq('user_id', userId)
        .eq('policy_id', policyId)

      if (deleteError) throw deleteError

      return { success: true }
    } catch (err: any) {
      console.error('북마크 삭제 에러:', err.message)
      return { success: false, error: err.message }
    }
  }

  // 사용자 북마크 목록 가져오기
  const fetchUserBookmarks = async (userId: string) => {
    try {
      const { data, error: fetchError } = await supabase
        .from('user_bookmarks')
        .select(`
          *,
          policies:policy_id (
            id,
            title,
            icon,
            image_url,
            categories:category_id (name)
          )
        `)
        .eq('user_id', userId)

      if (fetchError) throw fetchError

      return data
    } catch (err: any) {
      console.error('북마크 목록 가져오기 에러:', err.message)
      return []
    }
  }

  return {
    policies,
    loading,
    error,
    fetchPoliciesByCategory,
    getPolicyById,
    addBookmark,
    removeBookmark,
    fetchUserBookmarks
  }
}
