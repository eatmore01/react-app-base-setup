#!/bin/bash
EXTRA=$1
APP_PATH="$(pwd)"

mkdir src/app
mkdir src/pages
mkdir src/widgets
mkdir src/features
mkdir src/entities
mkdir src/shared

mv src/assets ./src/shared

rm src/App.tsx && rm src/App.css

rm src/index.css
mkdir src/app/styles

cat >> src/app/styles/index.css << EOF 
* {
  margin: 0; 
  padding: 0; 
}  

EOF

cat >> src/app/index.tsx << EOF
export const App = () => {
  return <div>App</div>
};

EOF

cat >> src/main.tsx << EOF
//example main files views with setup alias 

//import React from 'react';
//import ReactDOM from 'react-dom/client';
//import { App } from '@app/index';
//import '@app/styles/index.css';
//
//ReactDOM.createRoot(document.getElementById('root')!).render(
//  <React.StrictMode>
//    <App />
//  </React.StrictMode>
//);
EOF

yarn add --dev eslint \
    eslint-plugin-react \
    @typescript-eslint/eslint-plugin \
    @typescript-eslint/parser \
    prettier \
    eslint-config-prettier \
    eslint-plugin-prettier \
    husky \
    @types/node

npx husky init

cat >> .husky/pre-commit << EOF
#u cant add example command like yarn test, yarn lint, yarn build:prod, etc.

yarn lint

EOF

cat >> example.tsconfig.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "forceConsistentCasingInFileNames": true,


    /* Linting */
    "strict": true,
    "strictFunctionTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    //very strict mode
    "strictBindCallApply": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "allowSyntheticDefaultImports": true,
    "allowImportingTsExtensions": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@app/*": ["src/app/*"],
      "@pages/*": ["src/pages/*"],
      "@widgets/*": ["src/widgets/*"],
      "@features/*": ["src/features/*"],
      "@entities/*": ["src/entities/*"],
      "@shared/*": ["src/shared/*"],
    }
  },
  "include": ["src", "vite.config.ts"]
}
EOF

cat >> example.vite.config.ts << EOF
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@app': path.resolve(__dirname, './src/app'),
      '@pages': path.resolve(__dirname, './src/pages'),
      '@widgets': path.resolve(__dirname, './src/widgets'),
      '@features': path.resolve(__dirname, './src/features'),
      '@entities': path.resolve(__dirname, './src/entities'),
      '@shared': path.resolve(__dirname, './src/shared'),
    },
  },
});


EOF

cat >> .prettierrc  << EOF
{
  "endOfLine": "auto",
  "printWidth": 100,
  "singleQuote": true,
  "jsxSingleQuote": true,
  "tabWidth": 2,
}
EOF

cat >> .prettierignore << EOF
node_modules
#.next
#.dist

EOF

rm .eslintrc.cjs
cat >> .eslint.config.js << EOF

import js from '@eslint/js';
import globals from 'globals';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';
import tseslint from 'typescript-eslint';

export default tseslint.config({
  extends: [js.configs.recommended, ...tseslint.configs.recommended],
  files: ['**/*.{ts,tsx}'],
  ignores: ['dist'],
  languageOptions: {
    ecmaVersion: 2020,
    globals: globals.browser,
  },
  plugins: {
    'react-hooks': reactHooks,
    'react-refresh': reactRefresh,
  },
  rules: {
    ...reactHooks.configs.recommended.rules,
    'react-refresh/only-export-components': ['warn', { allowConstantExport: true }],
    'no-unused-vars': 'off',
    '@typescript-eslint/no-unused-vars': [
      'error',
      {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
        caughtErrorsIgnorePattern: '^_',
      },
    ],
    'unused-imports/no-unused-vars': [
      'warn',
      { vars: 'all', varsIgnorePattern: '^_', args: 'after-used', argsIgnorePattern: '^_' },
    ],
    'simple-import-sort/exports': 'error',
    'simple-import-sort/imports': [
      'error',
      {
        groups: [
          ['^react.*', '^[a-zA-Z].*'],
          ['^@(.*|$)'],
          ['^..(?!/?$)', '^../?$'],
          ['^./(?=.*/)(?!/?$)', '^.(?!/?$)', '^./?$'],
          ['^.+.json$'],
          ['^.+.s?css$'],
        ],
      },
    ],
  },
});

#depricated config
# module.exports = {
#   extends: [
#     'eslint:recommended',
#     'plugin:react/recommended',
#     'plugin:@typescript-eslint/recommended',
#     'plugin:react-hooks/recommended',
#     'plugin:import/recommended',
#     'prettier',
#   ],
#   parser: '@typescript-eslint/parser',
#   parserOptions: {
#     ecmaVersion: 'latest',
#     sourceType: 'module',
#     project: 'tsconfig.json',
#   },
#   plugins: ['react', '@typescript-eslint', 'simple-import-sort', 'unused-imports'],
#   rules: {
#     'import/no-default-export': 'error',
#     'import/prefer-default-export': 'off',
#     'react/function-component-definition': [
#       2,
#       {
#         namedComponents: 'arrow-function',
#         unnamedComponents: 'arrow-function',
#       },
#     ],
#     'simple-import-sort/exports': 'error',
#     'simple-import-sort/imports': [
#       'error',
#       {
#         groups: [
#           ['^react.*', '^[a-zA-Z].*'],
#           ['^@(.*|$)'],
#           ['^\\.\\.(?!/?$)', '^\\.\\./?$'],
#           ['^\\./(?=.*/)(?!/?$)', '^\\.(?!/?$)', '^\\./?$'],
#           ['^.+\\.json$'],
#           ['^.+\\.s?css$'], // вот тут я хз как лучше импорты расположить
#         ],
#       },
#     ],
#     'no-unused-vars': 'off',
#     '@typescript-eslint/no-unused-vars': [
#       'error',
#       {
#         argsIgnorePattern: '^_',
#         varsIgnorePattern: '^_',
#         caughtErrorsIgnorePattern: '^_',
#       },
#     ],
#     'import/no-extraneous-dependencies': ['off'],
#     'unused-imports/no-unused-imports': 'error',
#     'unused-imports/no-unused-vars': [
#       'warn',
#       { vars: 'all', varsIgnorePattern: '^_', args: 'after-used', argsIgnorePattern: '^_' },
#     ],
#     'react/jsx-props-no-spreading': 'off',
#     '@typescript-eslint/no-inferrable-types': [
#       'error',
#       {
#         ignoreParameters: true,
#       },
#     ],
#     'react/require-default-props': 'off',
#     'jsx-a11y/anchor-is-valid': 'off',
#     'react/prop-types': 'off',
#     'consistent-return': 'off',
#   },
# };
EOF

cat >> .eslintignore << EOF 
/.git
/.vscode
node_modules
vite.config.ts
postcss.config.ts
tailwind.config.ts
dist
build
*.d.ts
EOF




cat >> DockerFile.dev << EOF
FROM node:20.15.0-bullseye

RUN npm install -g npm@latest --force && npm install --global yarn --force

WORKDIR /app

COPY . /app

RUN yarn

EXPOSE 8000

VOLUME [ "/app" ]

CMD [ "yarn", "dev", "--host", "0.0.0.0", "--port", "8000" ]

EOF


cat >> push.sh << "EOF"
#!/bin/bash

#first message after sh push.sh this is ur commit message
MESSAGE="$1" 
DATE=$(date)

if [ -z "$MESSAGE" ]; then 
  echo "starting push to remote repo with auto message..."
  git add .
  git commit -m "$DATE"
  git push origin main 
  echo "Pushing complete success"
else
  echo "starting push to remote repo with custom message..."
  git add .
  git commit -m "$MESSAGE"
  git push origin main 
  echo "Pushing complete success"
fi
EOF

cat >> dev.sh << EOF
#!/bin/bash

docker build -t app:dev . -f Dockerfile.dev

docker run -p 8090:8000 -v "$APP_PATH:/app" -d --name dev --rm app:dev 

echo "open browser on 0.0.0.0:8090"

sleep 36000

docker rm dev --force 

docker rmi app:dev --force 

docker image prune 

EOF


touch .env.local

touch .env.example


if  [ "$EXTRA" = 'jest' ]; then

yarn add jest \
   @types/jest \
   babel-jest \
   @babel/preset-env \
   @babel/preset-react \
   @babel/preset-typescript \
   @testing-library/react \
   jsdom


cat >> babel.config.js << EOF
module.exports = {
  presets: [
    ['@babel/preset-env', { targets: { node: 'current' } }],
    '@babel/preset-typescript',
    [
      '@babel/preset-react',
      {
        runtime: 'automatic',
      },
    ],
  ],
};

EOF

cat >> jest.config.js << EOF
module.exports = {
  preset: 'babel-jest',
  // testEnvironment: 'jest-environment-jsdom',
  testEnvironment: 'jsdom',
  transform: {
    '^.+\.(js|jsx|ts|tsx)$': 'babel-jest',
  },
  rootDir: 'src',
  setupFilesAfterEnv: ['<rootDir>/tests/setup-tests.ts'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
};

EOF

mkdir src/tests
  

cat >> src/tests/setup-test.ts << EOF
import '@testing-library/jest-dom/extend-expect';
EOF

fi


if  [ "$EXTRA" = 'tailwind' ]; then


yarn add --dev tailwindcss postcss autoprefixer
npx tailwindcss init -p

rm tailwind.config.js

cat >> tailwind.config.js << EOF
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}


EOF
rm src/app/styles/index.css

cat >> src/app/styles/index.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  margin: 0;
  padding: 0;
}

EOF

fi


echo "Before push using push.sh scripts uncomment two string if scripts file"

echo "Setup complete press Enter for exit..."
