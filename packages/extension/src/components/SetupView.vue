<script setup lang="ts">
import { useForm } from "@tanstack/vue-form";
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import Message from "primevue/message";
import { computed, reactive } from "vue";
import { useServerSetup } from "@/composables/server";
import { useConfigQuery } from "@/composables/queries/config";

const config = useConfigQuery();
const setup = useServerSetup();

const url = computed(() => config.data.value?.serverUrl ?? "");

const defaultValues = reactive({
  url,
});

const form = useForm({
  defaultValues,
  async onSubmit({ value }) {
    setup.mutate(value.url);
  },
});

const validUrl = (url: string) => {
  try {
    const parsed = new URL(url);
    return parsed.protocol === "http:" || parsed.protocol === "https:";
  } catch {
    return false;
  }
};
</script>

<template>
  <p v-if="config.isLoading.value">Loading..</p>

  <form
    v-else
    class="flex justify-center flex-col gap-4"
    @submit.prevent.stop="form.handleSubmit"
  >
    <form.Field
      name="url"
      :validators="{
        onChange: ({ value }) =>
          validUrl(value)
            ? null
            : 'Invalid URL. Please enter a valid http(s) URL.',
      }"
    >
      <template #default="{ field }">
        <div class="flex flex-col gap-2">
          <label for="url">Server URL</label>
          <InputText
            id="url"
            :value="field.state.value"
            :name="field.name"
            type="url"
            placeholder="https://your-server.worker.dev"
            :disabled="setup.isPending.value"
            @blur="field.handleBlur"
            @input="
              (e) => field.handleChange((e.target as HTMLInputElement).value)
            "
          />
          <Message size="small" severity="secondary" variant="simple">
            Enter your haudoi server url. You can find that in server frontpage.
          </Message>

          <Message v-if="!field.state.meta.isValid" severity="error">
            {{ field.state.meta.errors.join(", ") }}
          </Message>
        </div>
      </template>
    </form.Field>

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
