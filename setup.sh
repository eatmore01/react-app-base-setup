EXTRA=$1


yarn add --dev eslint \
    eslint-plugin-react \
    @typescript-eslint/eslint-plugin \
    @typescript-eslint/parser \
    prettier \
    eslint-config-prettier \
    eslint-plugin-prettier \
    husky

npx husky init

cat >> tsconfig.json.example << EOF

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
    "strictBindCallApply": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@components/*": ["src/components/*"],
      "@shared/*": ["src/shared/*"],
      "@pages/*": ["src/pages/*"],
      "@app/*": ["src/app/*"],
      "@widgets/*": ["src/widgets/*"],
      "@store/*": ["src/shared/lib/storage/*"],
      "@entities/*": ["src/entities/*"],
      "@features/*": ["src/features/*"]
    }
  },
  "include": ["src", "vite.config.ts"]
}


EOF

cat >> .prettierrc  << EOF
{
  "endOfLine": "auto",
  "printWidth": 100,
  "singleQuote": true,
  "jsxSingleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
EOF

cat >> .prettierignore << EOF
node_modules
#.next
#.dist

EOF


cat >> .eslintrc.cjs << EOF

module.exports = {
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'plugin:import/recommended',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: 'tsconfig.json',
  },
  plugins: ['react', '@typescript-eslint', 'simple-import-sort', 'unused-imports'],
  rules: {
    'import/no-default-export': 'error',
    'import/prefer-default-export': 'off',
    'react/function-component-definition': [
      2,
      {
        namedComponents: 'arrow-function',
        unnamedComponents: 'arrow-function',
      },
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
          ['^.+\\.s?css$'], // вот тут я хз как лучше импорты расположить
        ],
      },
    ],
    'no-unused-vars': 'off',
    '@typescript-eslint/no-unused-vars': [
      'error',
      {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
        caughtErrorsIgnorePattern: '^_',
      },
    ],
    'import/no-extraneous-dependencies': ['off'],
    'unused-imports/no-unused-imports': 'error',
    'unused-imports/no-unused-vars': [
      'warn',
      { vars: 'all', varsIgnorePattern: '^_', args: 'after-used', argsIgnorePattern: '^_' },
    ],
    'react/jsx-props-no-spreading': 'off',
    '@typescript-eslint/no-inferrable-types': [
      'error',
      {
        ignoreParameters: true,
      },
    ],
    'react/require-default-props': 'off',
    'jsx-a11y/anchor-is-valid': 'off',
    'react/prop-types': 'off',
    'consistent-return': 'off',
  },
};

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


cat >> push.sh << EOF

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

docker run -p 8090:8000 -v "/home/jantttez/Documents/projects/vkcopy:/app" -d --name dev --rm app:dev 

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

cat >> index.css << EOF

@tailwind base;
@tailwind components;
@tailwind utilities;

EOF


fi


echo "add     
    "strictBindCallApply": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "allowSyntheticDefaultImports": true,
    "allowImportingTsExtensions": true,
    "noFallthroughCasesInSwitch": true
    
    in ur tsconfig.json file for very scrict mode
"
echo "setup complete press Enter for exit..."

