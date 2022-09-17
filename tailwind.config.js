const colors = require("tailwindcss/colors");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./lib/homelab_mon_web/templates/**/*.html.{eex,heex}",
    "./lib/homelab_mon_web/views/**/*.ex",
    "./lib/homelab_mon_web/lives/**/*.html.heex",
    "./lib/homelab_mon_web/lives/**/*_live.ex",
  ],
  theme: {
    colors: {
      transparent: "transparent",
      current: "currentColor",
      black: colors.black,
      white: colors.white,
      gray: colors.gray,
      blue: colors.blue,
      emerald: colors.emerald,
      indigo: colors.indigo,
      red: colors.red,
      yellow: colors.yellow,
    },
    extend: {},
  },
  plugins: [],
};
