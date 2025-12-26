<script setup lang="ts">
import { ref, watch } from "vue";
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import Message from "primevue/message";
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
  <form
    class="flex justify-center flex-col gap-4"
    @submit.prevent="setup.mutate(input)"
  >
    <div class="flex flex-col gap-2">
      <label for="url">Server URL</label>
      <InputText
        id="url"
        v-model="input"
        name="url"
        type="url"
        placeholder="https://your-server.worker.dev"
        :disabled="setup.isPending.value"
      />
      <Message size="small" severity="secondary" variant="simple">
        Enter your haudoi server url. You can find that in server frontpage.
      </Message>
    </div>

    <Button label="Connect" type="submit" :loading="setup.isPending.value" />

    <Message
      v-if="setup.isPending.value"
      severity="info"
      icon="pi pi-info-circle"
    >
      Press "allow" in the permission prompt to continue.
    </Message>

    <Message
      v-if="setup.error.value"
      severity="error"
      icon="pi pi-times-circle"
    >
      {{ setup.error.value.message }}
    </Message>
  </form>
</template>
