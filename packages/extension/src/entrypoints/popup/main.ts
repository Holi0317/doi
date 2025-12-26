import { createApp } from "vue";
import { VueQueryPlugin } from "@tanstack/vue-query";
import PrimeVue from "primevue/config";
import Aura from "@primeuix/themes/aura";
import App from "../../components/App.vue";
import { router } from "../../router";
import "./style.css";

const app = createApp(App);

app.use(VueQueryPlugin);
app.use(PrimeVue, {
  theme: {
    preset: Aura,
  },
});
app.use(router);

app.mount("#app");
