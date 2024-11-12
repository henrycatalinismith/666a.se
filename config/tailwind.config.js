const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './*.md',
    './public/*.html',
    './app/builders/**/*.rb',
    './app/components/**/*.erb',
    './app/controllers/**/*.rb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/views/**/*.html.erb',
  ],
  theme: {
    screens: {
      'xs': '475px',
      'sm': '640px',
      'md': '768px',
      'lg': '1024px',
    },

    extend: {

      fontFamily: {
        sans: ['Nunito', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
