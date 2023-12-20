import { createVuetify } from 'vuetify'
import defaults from './defaults'
import { icons } from './icons'
import theme from './theme'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { VBtn } from 'vuetify/components/VBtn'


// Styles
import '@core/scss/template/libs/vuetify/index.scss'
import 'vuetify/styles'

export default createVuetify({
  components: {
    ...components,
  },
  directives: directives,
  aliases: {
    IconBtn: VBtn,
  },
  defaults: defaults,
  icons: icons,
  theme: theme,
})
