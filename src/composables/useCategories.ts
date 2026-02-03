import { ref } from 'vue'
import { supabase } from '../lib/supabase'
import type { Database } from '../types/supabase'

type Category = Database['public']['Tables']['categories']['Row']

export function useCategories() {
  const categories = ref<Category[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const fetchCategories = async () => {
    loading.value = true
    error.value = null

    try {
      const { data, error: fetchError } = await supabase
        .from('categories')
        .select('*')
        .order('display_order', { ascending: true })

      if (fetchError) throw fetchError

      categories.value = data || []
    } catch (err: any) {
      error.value = err.message
      console.error('카테고리 가져오기 에러:', err.message)
    } finally {
      loading.value = false
    }
  }

  const getCategoryBySlug = async (slug: string) => {
    try {
      const { data, error: fetchError } = await supabase
        .from('categories')
        .select('*')
        .eq('slug', slug)
        .single()

      if (fetchError) {
        // AbortError는 조용히 처리
        if (fetchError.name === 'AbortError' || fetchError.message?.includes('aborted')) {
          console.log('⚠️ [Categories] 카테고리 가져오기 중단됨')
          return null
        }
        throw fetchError
      }

      return data
    } catch (err: any) {
      if (err.name !== 'AbortError' && !err.message?.includes('aborted')) {
        console.error('카테고리 가져오기 에러:', err.message)
      }
      return null
    }
  }

  const getCategoryById = async (id: number) => {
    try {
      const { data, error: fetchError } = await supabase
        .from('categories')
        .select('*')
        .eq('id', id)
        .single()

      if (fetchError) throw fetchError

      return data
    } catch (err: any) {
      console.error('카테고리 가져오기 에러:', err.message)
      return null
    }
  }

  return {
    categories,
    loading,
    error,
    fetchCategories,
    getCategoryBySlug,
    getCategoryById
  }
}
