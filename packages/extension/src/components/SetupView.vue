<script setup lang="ts">
import { ref, watch } from "vue";
import { useServerSetup, useServerLogin } from "@/composables/server";

const input = ref("");
const setup = useServerSetup();
const { login } = useServerLogin();

watch(setup.data, (res) => {
  if (res == null) {
    return;
  }

  if (res.authenticated) {
    return;
  }

  // User is not authenticated. Opening login page.
  login();
});
</script>

<template>
  <form class="setup-form" @submit.prevent="setup.mutate(input)">
    <div class="form-group">
      <label>
        Server URL

        <input
          v-model="input"
          type="url"
          placeholder="https://your-server.worker.dev"
          :disabled="setup.isPending.value"
        />
      </label>
    </div>
    <button class="primary" type="submit" :disabled="setup.isPending.value">
      Connect
    </button>

    <p v-if="setup.error.value" class="error-message">
      {{ setup.error.value.message }}
    </p>
  </form>
</template>
