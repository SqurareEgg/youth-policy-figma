<template>
  <div class="min-h-screen bg-white">
    <FigmaHeader />
    <FigmaHeroSection />

    <!-- Main Content with Sidebar -->
    <div class="container" style="display: flex; gap: 2rem; padding: 2rem 1rem;">
      <!-- Main Content -->
      <div style="flex: 1;">
        <FigmaServiceCards />
      </div>

      <!-- Sidebar -->
      <FigmaSidebar />
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaHeroSection from '../components/figma/FigmaHeroSection.vue'
import FigmaServiceCards from '../components/figma/FigmaServiceCards.vue'
import FigmaSidebar from '../components/figma/FigmaSidebar.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
</script>
