export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          email: string
          name: string | null
          birth_date: string | null
          phone: string | null
          terms_agreed: boolean
          privacy_agreed: boolean
          marketing_agreed: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          name?: string | null
          birth_date?: string | null
          phone?: string | null
          terms_agreed?: boolean
          privacy_agreed?: boolean
          marketing_agreed?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          name?: string | null
          birth_date?: string | null
          phone?: string | null
          terms_agreed?: boolean
          privacy_agreed?: boolean
          marketing_agreed?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      categories: {
        Row: {
          id: number
          name: string
          slug: string
          icon: string
          description: string | null
          display_order: number
          created_at: string
        }
        Insert: {
          id?: number
          name: string
          slug: string
          icon: string
          description?: string | null
          display_order?: number
          created_at?: string
        }
        Update: {
          id?: number
          name?: string
          slug?: string
          icon?: string
          description?: string | null
          display_order?: number
          created_at?: string
        }
      }
      policies: {
        Row: {
          id: number
          category_id: number
          title: string
          icon: string
          image_url: string | null
          intro: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          category_id: number
          title: string
          icon: string
          image_url?: string | null
          intro?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          category_id?: number
          title?: string
          icon?: string
          image_url?: string | null
          intro?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      policy_details: {
        Row: {
          id: number
          policy_id: number
          title: string
          description: string
          display_order: number
          created_at: string
        }
        Insert: {
          id?: number
          policy_id: number
          title: string
          description: string
          display_order?: number
          created_at?: string
        }
        Update: {
          id?: number
          policy_id?: number
          title?: string
          description?: string
          display_order?: number
          created_at?: string
        }
      }
      videos: {
        Row: {
          id: number
          category_id: number
          title: string
          duration: string
          thumbnail_url: string | null
          video_url: string | null
          description: string | null
          display_order: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          category_id: number
          title: string
          duration: string
          thumbnail_url?: string | null
          video_url?: string | null
          description?: string | null
          display_order?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          category_id?: number
          title?: string
          duration?: string
          thumbnail_url?: string | null
          video_url?: string | null
          description?: string | null
          display_order?: number
          created_at?: string
          updated_at?: string
        }
      }
      user_video_progress: {
        Row: {
          id: number
          user_id: string
          video_id: number
          completed: boolean
          last_position: number
          completed_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          user_id: string
          video_id: number
          completed?: boolean
          last_position?: number
          completed_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          user_id?: string
          video_id?: number
          completed?: boolean
          last_position?: number
          completed_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      quizzes: {
        Row: {
          id: number
          category_id: number
          title: string
          description: string | null
          display_order: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          category_id: number
          title: string
          description?: string | null
          display_order?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          category_id?: number
          title?: string
          description?: string | null
          display_order?: number
          created_at?: string
          updated_at?: string
        }
      }
      quiz_questions: {
        Row: {
          id: number
          quiz_id: number
          question: string
          options: Json
          correct_answer: number
          explanation: string | null
          display_order: number
          created_at: string
        }
        Insert: {
          id?: number
          quiz_id: number
          question: string
          options: Json
          correct_answer: number
          explanation?: string | null
          display_order?: number
          created_at?: string
        }
        Update: {
          id?: number
          quiz_id?: number
          question?: string
          options?: Json
          correct_answer?: number
          explanation?: string | null
          display_order?: number
          created_at?: string
        }
      }
      user_quiz_results: {
        Row: {
          id: number
          user_id: string
          quiz_id: number
          score: number
          total_questions: number
          correct_answers: number
          answers: Json | null
          completed_at: string
          created_at: string
        }
        Insert: {
          id?: number
          user_id: string
          quiz_id: number
          score: number
          total_questions: number
          correct_answers: number
          answers?: Json | null
          completed_at?: string
          created_at?: string
        }
        Update: {
          id?: number
          user_id?: string
          quiz_id?: number
          score?: number
          total_questions?: number
          correct_answers?: number
          answers?: Json | null
          completed_at?: string
          created_at?: string
        }
      }
      qna: {
        Row: {
          id: number
          category_id: number
          question: string
          answer: string
          display_order: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          category_id: number
          question: string
          answer: string
          display_order?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          category_id?: number
          question?: string
          answer?: string
          display_order?: number
          created_at?: string
          updated_at?: string
        }
      }
      user_bookmarks: {
        Row: {
          id: number
          user_id: string
          policy_id: number
          created_at: string
        }
        Insert: {
          id?: number
          user_id: string
          policy_id: number
          created_at?: string
        }
        Update: {
          id?: number
          user_id?: string
          policy_id?: number
          created_at?: string
        }
      }
      community_posts: {
        Row: {
          id: number
          user_id: string
          category_id: number | null
          title: string
          content: string
          views: number
          likes: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          user_id: string
          category_id?: number | null
          title: string
          content: string
          views?: number
          likes?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          user_id?: string
          category_id?: number | null
          title?: string
          content?: string
          views?: number
          likes?: number
          created_at?: string
          updated_at?: string
        }
      }
      comments: {
        Row: {
          id: number
          post_id: number
          user_id: string
          content: string
          likes: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          post_id: number
          user_id: string
          content: string
          likes?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          post_id?: number
          user_id?: string
          content?: string
          likes?: number
          created_at?: string
          updated_at?: string
        }
      }
      post_likes: {
        Row: {
          id: number
          post_id: number
          user_id: string
          created_at: string
        }
        Insert: {
          id?: number
          post_id: number
          user_id: string
          created_at?: string
        }
        Update: {
          id?: number
          post_id?: number
          user_id?: string
          created_at?: string
        }
      }
      comment_likes: {
        Row: {
          id: number
          comment_id: number
          user_id: string
          created_at: string
        }
        Insert: {
          id?: number
          comment_id: number
          user_id: string
          created_at?: string
        }
        Update: {
          id?: number
          comment_id?: number
          user_id?: string
          created_at?: string
        }
      }
    }
    Views: {
      policy_full_view: {
        Row: {
          id: number
          title: string
          icon: string
          image_url: string | null
          intro: string | null
          category_name: string
          category_slug: string
          details: Json
        }
      }
      user_learning_progress: {
        Row: {
          user_id: string
          category_id: number
          category_name: string
          total_videos: number
          completed_videos: number
          total_quizzes: number
          completed_quizzes: number
          total_items: number
          completed_items: number
          completion_percentage: number
        }
      }
      community_posts_with_user: {
        Row: {
          id: number
          title: string
          content: string
          views: number
          likes: number
          created_at: string
          updated_at: string
          author_name: string | null
          author_email: string
          category_name: string | null
          comment_count: number
        }
      }
    }
    Functions: {}
  }
}
