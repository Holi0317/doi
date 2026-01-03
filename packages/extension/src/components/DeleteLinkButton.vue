<script setup lang="ts">
import Button from "primevue/button";
import { useDeleteMutation } from "@/composables/queries/server";

const props = defineProps<{
  id: number;
}>();

const mutation = useDeleteMutation();

const click = () => {
  mutation.mutate(props.id);
};
</script>

<template>
  <template v-if="mutation.isError.value">
    <Button
      label="Delete link"
      icon="pi pi-exclamation-circle"
      severity="warn"
      :disabled="true"
    />

    <p>Error deleting link. {{ mutation.failureReason.value }}</p>

    <Button label="Retry" icon="pi pi-refresh" severity="info" @click="click" />
  </template>

  <Button
    v-else-if="mutation.isSuccess.value"
    label="Link deleted"
    icon="pi pi-check"
    severity="success"
    :disabled="true"
  />

  <Button
    v-else
    label="Delete link"
    icon="pi pi-trash"
    severity="danger"
    :loading="mutation.isPending.value"
    @click="click"
  />
</template>
