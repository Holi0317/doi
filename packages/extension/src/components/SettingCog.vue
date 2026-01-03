<script setup lang="ts">
import Button from "primevue/button";
</script>

<template>
  <div class="flex justify-end">
    <Button
      as="RouterLink"
      to="/setup"
      icon="pi pi-cog"
      variant="text"
      severity="secondary"
      aria-label="Settings"
    >
    </Button>
  </div>
</template>
