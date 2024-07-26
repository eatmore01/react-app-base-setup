
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
cat >> index.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  margin: 0;
  padding: 0;
}

EOF
