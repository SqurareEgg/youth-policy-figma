<template>
  <footer style="background-color: #F3F4F6; border-top: 1px solid #E5E7EB; padding: 2rem 0;">
    <div class="container">
      <!-- 상단 섹션 -->
      <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1.5rem;">
        <!-- 링크 영역 -->
        <div style="display: flex; flex-wrap: wrap; gap: 1rem;">
          <a
            v-for="link in links"
            :key="link.name"
            href="#"
            style="font-size: 0.75rem; color: #4B5563; text-decoration: none; cursor: pointer;"
            @mouseover="(e) => (e.target.style.color = '#111827')"
            @mouseout="(e) => (e.target.style.color = '#4B5563')"
          >
            {{ link.name }}
          </a>
        </div>

        <!-- 우측 액션 버튼 영역 -->
        <div style="display: flex; gap: 0.75rem;">
          <q-select
            v-model="selectedLanguage"
            :options="languageOptions"
            outlined
            dense
            style="font-size: 0.75rem; min-width: 100px; background-color: white;"
          />
          <q-btn
            outline
            no-caps
            label="고객센터"
            style="font-size: 0.75rem; background-color: white;"
          />
        </div>
      </div>

      <!-- 저작권 표시 -->
      <div style="padding-top: 1rem; border-top: 1px solid #E5E7EB;">
        <p style="font-size: 0.75rem; color: #6B7280;">
          © 2026 청년있슈. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const selectedLanguage = ref('한국어')

const languageOptions = ['한국어', 'English']

const links = [
  { name: '이용약관' },
  { name: '개인정보처리방침' },
  { name: '사업자정보' },
  { name: '공지사항' }
]
</script>
