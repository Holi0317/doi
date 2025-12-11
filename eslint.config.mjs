// @ts-check

import { defineConfig } from "eslint/config";
import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import eslintConfigPrettier from "eslint-config-prettier";
import stylistic from "@stylistic/eslint-plugin";
import importX from "eslint-plugin-import-x";

export default defineConfig(
  {
    name: "Files and globbing",
    files: ["**/*.{js,mjs,cjs,jsx,ts,mts,cts,tsx}"],
  },
  {
    name: "Global ignores",
    ignores: [
      "dist/",
      "node_modules/",
      ".wrangler/",
      "worker-configuration.d.ts",
    ],
  },
  {
    name: "Language options",
    languageOptions: {
      ecmaVersion: "latest",
      globals: {
        ...globals.worker,
      },
    },
  },

  js.configs.recommended,
  tseslint.configs.recommended,

  // Inline TypeScript configuration for eslint-plugin-import-x
  // This replaces importX.flatConfigs.typescript to avoid requiring
  // eslint-import-resolver-typescript package
  {
    name: "import-x/typescript",
    plugins: {
      "import-x": importX,
    },
    settings: {
      "import-x/extensions": [
        ".ts",
        ".tsx",
        ".cts",
        ".mts",
        ".js",
        ".jsx",
        ".cjs",
        ".mjs",
      ],
      "import-x/external-module-folders": [
        "node_modules",
        "node_modules/@types",
      ],
      "import-x/parsers": {
        "@typescript-eslint/parser": [".ts", ".tsx", ".cts", ".mts"],
      },
    },
    rules: {
      "import-x/named": "off",
    },
  },

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
      "import-x/no-duplicates": "error",
      "@typescript-eslint/consistent-type-imports": "error",
      "@typescript-eslint/no-import-type-side-effects": "error",
      "import-x/no-nodejs-modules": "warn",
      "import-x/order": [
        "error",
        {
          groups: [
            ["builtin", "external", "parent", "sibling", "index", "type"],
          ],
        },
      ],
    },
  },
);
