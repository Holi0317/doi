// @ts-check

import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import eslintConfigPrettier from "eslint-config-prettier";
import stylistic from "@stylistic/eslint-plugin";

export default tseslint.config(
  {
    ignores: ["dist/", "node_modules/", ".wrangler/"],
  },

  {
    files: ["**/*.{js,mjs,cjs,ts,mts,cts}"],
    languageOptions: {
      globals: {
        ...globals.worker,
      },
    },
  },
  js.configs.recommended,
  tseslint.configs.recommended,

  eslintConfigPrettier,

  {
    name: "Styling rules",
    plugins: {
      "@stylistic": stylistic,
    },
    rules: {
      curly: ["error", "all"],
      "@stylistic/spaced-comment": ["error", "always", { markers: ["/"] }],
      "@typescript-eslint/array-type": ["error", { default: "array-simple" }],
    },
  },

  {
    name: "Strict rules",
    rules: {
      eqeqeq: ["error", "smart"],
      "@typescript-eslint/ban-ts-comment": [
        "error",
        {
          "ts-expect-error": "allow-with-description",
          "ts-ignore": false,
          "ts-nocheck": false,
          "ts-check": false,
          minimumDescriptionLength: 3,
        },
      ],
      "@typescript-eslint/no-unused-vars": [
        "error",
        { argsIgnorePattern: "^_.+", ignoreRestSiblings: true },
      ],
    },
  },
);
