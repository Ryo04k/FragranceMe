module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        custom: [
          "Noto Sans JP",
          "ヒラギノ角ゴ Pro W3",
          "Hiragino Kaku Gothic Pro",
          "メイリオ",
          "Meiryo",
          "ＭＳ Ｐゴシック",
          "sans-serif",
        ],
      },
      fontWeight: {
        "custom-weight": 400,
      },
      letterSpacing: {
        custom: "0.02em",
      },
      lineHeight: {
        custom: 1.734,
      },
      colors: {
        customColor: "#333",
        main: "#e57777",
        background: "#fafafa",
      },
      screens: {
        hoverable: { raw: '(hover: hover) and (pointer: fine)' },
      },
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    darkTheme: false, // ダークモードをONにする場合は削除
    themes: [
      {
        mytheme: {
          "primary": "#e57777",
          "neutral": "#3d4451",
          // 他の色を追加する場合はここに記述
        },
      },
      // 他のテーマを追加する場合はここに記述
    ],
  },
};
