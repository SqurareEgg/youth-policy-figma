<template>
  <footer style="background-color: #F9FAFB; border-top: 1px solid #E5E7EB; padding: 2rem 0;">
    <div class="container mx-auto px-4 sm:px-6">
      <div style="display: flex; flex-direction: column; gap: 1rem; align-items: center; text-align: center;">
        <!-- 링크 영역 -->
        <div style="display: flex; flex-wrap: wrap; gap: 0.75rem; justify-content: center;">
          <a
            v-for="(link, index) in links"
            :key="link.name"
            href="#"
            style="font-size: 0.875rem; color: #6B7280; text-decoration: none;"
            class="footer-link"
          >
            {{ link.name }}
            <span v-if="index < links.length - 1" style="margin-left: 0.75rem; color: #D1D5DB;">|</span>
          </a>
        </div>

        <!-- 저작권 표시 -->
        <p style="font-size: 0.875rem; color: #9CA3AF; margin: 0;">
          © 2026 청년있슈. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
const links = [
  { name: '이용약관' },
  { name: '개인정보처리방침' }
]
</script>

<style scoped>
.footer-link:hover {
  color: #374151;
}
</style>
