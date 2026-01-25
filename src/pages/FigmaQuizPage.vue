<template>
  <div style="min-height: 100vh; background-color: white;">
    <FigmaHeader />

    <div style="min-height: 100vh; background-color: #F9FAFB;">
      <!-- Back Button & Header -->
      <div style="background-color: white; border-bottom: 1px solid #E5E7EB;">
        <div class="container" style="padding: 1.5rem 1rem;">
          <q-btn
            flat
            icon="arrow_back"
            label="뒤로 가기"
            @click="handleBack"
            style="color: #4B5563; margin-bottom: 1rem;"
            no-caps
          />

          <div v-if="quiz">
            <h1 style="font-size: 1.875rem; font-weight: 700; margin-bottom: 0.5rem;">{{ quiz.title }}</h1>
            <p style="color: #4B5563;">{{ quiz.description }}</p>
          </div>
        </div>
      </div>

      <div class="container" style="padding: 2rem 1rem; max-width: 800px; margin: 0 auto;">
        <!-- 로딩 중 -->
        <div v-if="loading" style="text-align: center; padding: 3rem;">
          <q-spinner size="50px" color="orange" />
          <p style="margin-top: 1rem; color: #4B5563;">퀴즈를 불러오는 중...</p>
        </div>

        <!-- 결과 화면 -->
        <div v-else-if="showResult" style="text-align: center;">
          <q-card style="padding: 2rem;">
            <q-icon
              :name="result.score >= 60 ? 'emoji_events' : 'replay'"
              :color="result.score >= 60 ? 'orange' : 'grey'"
              size="80px"
              style="margin-bottom: 1rem;"
            />
            <h2 style="font-size: 2rem; font-weight: 700; margin-bottom: 1rem;">
              {{ result.score }}점
            </h2>
            <p style="font-size: 1.125rem; color: #4B5563; margin-bottom: 0.5rem;">
              {{ result.correctCount }} / {{ result.totalQuestions }} 정답
            </p>
            <p style="font-size: 1rem; color: #4B5563; margin-bottom: 2rem;">
              {{ result.score >= 60 ? '🎉 합격입니다!' : '😢 불합격입니다. 다시 도전해보세요!' }}
            </p>

            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
              <q-btn
                label="다시 풀기"
                color="orange"
                unelevated
                no-caps
                @click="resetQuiz"
                style="font-size: 1rem; padding: 0.75rem;"
              />
              <q-btn
                label="목록으로 돌아가기"
                outline
                color="grey"
                no-caps
                @click="handleBack"
                style="font-size: 1rem; padding: 0.75rem;"
              />
            </div>
          </q-card>
        </div>

        <!-- 퀴즈 문제 -->
        <div v-else-if="questions.length > 0">
          <div style="margin-bottom: 2rem;">
            <q-linear-progress
              :value="(currentQuestionIndex + 1) / questions.length"
              color="orange"
              size="8px"
            />
            <p style="text-align: center; margin-top: 0.5rem; font-size: 0.875rem; color: #4B5563;">
              {{ currentQuestionIndex + 1 }} / {{ questions.length }}
            </p>
          </div>

          <q-card style="padding: 2rem; margin-bottom: 2rem;">
            <div style="margin-bottom: 2rem;">
              <div style="display: inline-block; background-color: #F97316; color: white; padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 600; margin-bottom: 1rem;">
                문제 {{ currentQuestionIndex + 1 }}
              </div>
              <h2 style="font-size: 1.25rem; font-weight: 700; line-height: 1.6;">
                {{ currentQuestion.question }}
              </h2>
            </div>

            <div style="display: flex; flex-direction: column; gap: 1rem;">
              <q-card
                v-for="(option, index) in currentQuestion.options"
                :key="index"
                clickable
                @click="selectAnswer(index + 1)"
                :style="{
                  padding: '1rem',
                  cursor: 'pointer',
                  border: userAnswers[currentQuestion.id] === index + 1 ? '2px solid #F97316' : '1px solid #E5E7EB',
                  backgroundColor: userAnswers[currentQuestion.id] === index + 1 ? '#FFF7ED' : 'white'
                }"
              >
                <div style="display: flex; align-items: center; gap: 1rem;">
                  <div
                    :style="{
                      width: '32px',
                      height: '32px',
                      borderRadius: '50%',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontWeight: '600',
                      backgroundColor: userAnswers[currentQuestion.id] === index + 1 ? '#F97316' : '#F3F4F6',
                      color: userAnswers[currentQuestion.id] === index + 1 ? 'white' : '#4B5563'
                    }"
                  >
                    {{ index + 1 }}
                  </div>
                  <span style="flex: 1; font-size: 1rem;">{{ option }}</span>
                </div>
              </q-card>
            </div>
          </q-card>

          <div style="display: flex; gap: 1rem;">
            <q-btn
              v-if="currentQuestionIndex > 0"
              label="이전"
              outline
              color="grey"
              no-caps
              @click="previousQuestion"
              style="flex: 1; padding: 0.75rem; font-size: 1rem;"
            />
            <q-btn
              v-if="currentQuestionIndex < questions.length - 1"
              label="다음"
              color="orange"
              unelevated
              no-caps
              @click="nextQuestion"
              :disable="!userAnswers[currentQuestion.id]"
              style="flex: 1; padding: 0.75rem; font-size: 1rem;"
            />
            <q-btn
              v-else
              label="제출하기"
              color="orange"
              unelevated
              no-caps
              @click="submitQuizAnswers"
              :disable="!isAllAnswered"
              :loading="submitting"
              style="flex: 1; padding: 0.75rem; font-size: 1rem;"
            />
          </div>

          <div v-if="currentQuestionIndex === questions.length - 1 && !isAllAnswered" style="margin-top: 1rem; text-align: center;">
            <p style="color: #EF4444; font-size: 0.875rem;">
              모든 문제에 답해주세요. ({{ answeredCount }} / {{ questions.length }})
            </p>
          </div>
        </div>

        <!-- 퀴즈가 없을 때 -->
        <div v-else style="text-align: center; padding: 3rem;">
          <q-icon name="quiz" size="80px" color="grey" style="opacity: 0.5;" />
          <p style="margin-top: 1rem; color: #4B5563; font-size: 1.125rem;">퀴즈를 찾을 수 없습니다.</p>
        </div>
      </div>
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
import { useAuth } from '../composables/useAuth'
import { useLearning } from '../composables/useLearning'
import { supabase } from '../lib/supabase'

const route = useRoute()
const router = useRouter()
const $q = useQuasar()

const { user } = useAuth()
const { fetchQuizQuestions, submitQuiz } = useLearning()

const quizId = computed(() => parseInt(route.params.quizId as string))
const categorySlug = computed(() => route.params.category as string)

const quiz = ref<any>(null)
const questions = ref<any[]>([])
const loading = ref(true)
const submitting = ref(false)

const currentQuestionIndex = ref(0)
const userAnswers = ref<Record<number, number>>({})

const showResult = ref(false)
const result = ref<any>(null)

const currentQuestion = computed(() => questions.value[currentQuestionIndex.value])

const answeredCount = computed(() => Object.keys(userAnswers.value).length)

const isAllAnswered = computed(() => {
  return questions.value.every(q => userAnswers.value[q.id] !== undefined)
})

// 퀴즈 데이터 로드
const loadQuiz = async () => {
  loading.value = true

  try {
    // 퀴즈 기본 정보 가져오기
    const { data: quizData, error: quizError } = await supabase
      .from('quizzes')
      .select('*')
      .eq('id', quizId.value)
      .single()

    if (quizError) throw quizError
    if (!quizData) {
      throw new Error('퀴즈를 찾을 수 없습니다.')
    }

    quiz.value = quizData

    // 퀴즈 문제 가져오기
    const questionsData = await fetchQuizQuestions(quizId.value)
    questions.value = questionsData
  } catch (error: any) {
    console.error('퀴즈 로딩 에러:', error)
    $q.notify({
      type: 'negative',
      message: error.message || '퀴즈를 불러오는 중 오류가 발생했습니다.',
      position: 'top'
    })
    router.back()
  } finally {
    loading.value = false
  }
}

// 정답 선택
const selectAnswer = (answerIndex: number) => {
  userAnswers.value[currentQuestion.value.id] = answerIndex
}

// 다음 문제
const nextQuestion = () => {
  if (currentQuestionIndex.value < questions.value.length - 1) {
    currentQuestionIndex.value++
  }
}

// 이전 문제
const previousQuestion = () => {
  if (currentQuestionIndex.value > 0) {
    currentQuestionIndex.value--
  }
}

// 퀴즈 제출
const submitQuizAnswers = async () => {
  if (!user.value) {
    $q.notify({
      type: 'warning',
      message: '로그인이 필요합니다.',
      position: 'top'
    })
    router.push({ name: 'login' })
    return
  }

  if (!isAllAnswered.value) {
    $q.notify({
      type: 'warning',
      message: '모든 문제에 답해주세요.',
      position: 'top'
    })
    return
  }

  submitting.value = true

  try {
    const submitResult = await submitQuiz(
      user.value.id,
      quizId.value,
      userAnswers.value
    )

    if (submitResult.success) {
      result.value = {
        score: submitResult.score,
        correctCount: submitResult.correctCount,
        totalQuestions: submitResult.totalQuestions
      }
      showResult.value = true

      $q.notify({
        type: 'positive',
        message: '퀴즈가 제출되었습니다!',
        position: 'top'
      })
    } else {
      throw new Error(submitResult.error || '퀴즈 제출에 실패했습니다.')
    }
  } catch (error: any) {
    console.error('퀴즈 제출 에러:', error)
    $q.notify({
      type: 'negative',
      message: error.message || '퀴즈 제출 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    submitting.value = false
  }
}

// 퀴즈 다시 풀기
const resetQuiz = () => {
  currentQuestionIndex.value = 0
  userAnswers.value = {}
  showResult.value = false
  result.value = null
}

// 뒤로 가기
const handleBack = () => {
  if (categorySlug.value) {
    router.push({ name: 'category', params: { category: categorySlug.value } })
  } else {
    router.back()
  }
}

onMounted(() => {
  loadQuiz()
})
</script>

<style scoped>
.container {
  max-width: 1280px;
  margin: 0 auto;
}
</style>
