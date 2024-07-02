module.exports = {
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react-hooks/recommended",
    "plugin:import/recommended",
    "airbnb",
    "airbnb-typescript",
    "prettier",
    "plugin:react/jsx-runtime",
    "plugin:effector/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "project": "tsconfig.json"
  },
  "plugins": [
    "effector",
    "react",
    "@typescript-eslint",
    'simple-import-sort',
    'unused-imports'
  ],
  "rules": {
    'import/no-default-export': 'error',
    "import/prefer-default-export": "off",
    "react/function-component-definition": [
      2,
      {
        "namedComponents": "arrow-function",
        "unnamedComponents": "arrow-function"
      }
    ],
    'simple-import-sort/exports': 'error',
    'simple-import-sort/imports': [
      'error',
      {
        groups: [
          ['^react.*', '^[a-zA-Z].*'],
          ['^@(.*|$)'],
          ['^\\.\\.(?!/?$)', '^\\.\\./?$'],
          ['^\\./(?=.*/)(?!/?$)', '^\\.(?!/?$)', '^\\./?$'],
          ['^.+\\.json$'],
          ['^.+\\.s?css$'],
        ],
      },
    ],
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": [
      "error",
      {
        "argsIgnorePattern": "^_",
        "varsIgnorePattern": "^_",
        "caughtErrorsIgnorePattern": "^_"
      }
    ],
    "import/no-extraneous-dependencies": ["off"],
    'no-restricted-syntax': [
      'error',
      {
        selector:
          "ImportDeclaration[source.value='patronum'] ImportSpecifier[imported.name='debug']",
        message: "Don't use debug method",
      },
      {
        selector:
          "ImportDeclaration[source.value='effector-logger'] ImportSpecifier[imported.name='attachLogger']",
        message: "Don't use attachLogger",
      },
    ],
    "unused-imports/no-unused-imports": "error",
    "unused-imports/no-unused-vars": [
      "warn",
      { "vars": "all", "varsIgnorePattern": "^_", "args": "after-used", "argsIgnorePattern": "^_" }
    ],
    "react/jsx-props-no-spreading": "off",
    "@typescript-eslint/no-inferrable-types": ['error', {
      ignoreParameters: true
    }],
    "react/require-default-props": 'off',
    "jsx-a11y/anchor-is-valid": 'off',
    "react/prop-types": "off",
    "consistent-return": "off",
  }
}