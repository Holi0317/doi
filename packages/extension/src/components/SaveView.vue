<script setup lang="ts">
import { computed, watch } from "vue";
import { useCurrentTab } from "@/composables/queries/tab";
import { useSaveMutation } from "@/composables/queries/server";

const tabQuery = useCurrentTab();
const mutation = useSaveMutation();

const validUrl = computed(() => {
  const tab = tabQuery.data.value;
  if (tab == null) {
    return false;
  }

  try {
    const url = new URL(tab.url || "");
    return url.protocol === "http:" || url.protocol === "https:";
  } catch {
    return false;
  }
});

watch(
  [validUrl],
  () => {
    if (validUrl.value) {
      const tab = tabQuery.data.value;
      mutation.mutate({
        url: tab!.url!,
        title: tab!.title,
      });
    }
  },
  { immediate: true },
);

const retry = () => {
  const tab = tabQuery.data.value;
  if (tab == null) {
    return;
  }

  if (!validUrl.value) {
    return;
  }

  mutation.mutate({
    url: tab.url!,
    title: tab.title,
  });
};

/*
Handle following cases:

- Server not configured: Button to redirect to setup page. (Normally user won't see this page as they will be redirected to setup page automatically)
- currentTab is not available
- currentTab is invalid (non-http URL)
- Save the link automatically
- Server not authenticated / not reachable / error (via link saving response). Show retry and redirect to setup options
- Success message, delete button for saved link (mistake save)
*/
</script>

<template>
  <div v-if="tabQuery.isLoading.value">Loading...</div>

  <div v-else-if="mutation.error.value != null">
    <p>Error saving link: {{ mutation.error.value.message }}</p>
    <p>Maybe the server is not reachable or you are not authenticated.</p>

    <button class="primary" @click="retry">Retry</button>
    <router-link to="/setup">
      <button class="secondary">Setup Server</button>
    </router-link>
  </div>

  <div v-else-if="mutation.isPending.value">Saving link...</div>

  <div v-else-if="mutation.isSuccess.value">
    <p>Link saved successfully!</p>

    <!-- TODO: Link to server, and delete saved link -->
  </div>

  <div v-else>
    <p>Cannot save this URL: {{ tabQuery.data.value?.url }}</p>
  </div>
</template>
