<script setup lang="ts">
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
  <div></div>
</template>
