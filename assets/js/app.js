// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html'
import {Socket} from 'phoenix'
import {LiveSocket} from 'phoenix_live_view'

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

let cm = CodeMirror(document.getElementById('textarea'), {
  lineNumbers: true,
  mode: 'javascript',
  theme: 'duotone-dark',
  autoFocus: true,
  foldGutter: true,
  autofocus: true,
})

// TODO: Debounce
// TODO: Problems with cursor lagging behind

let Hooks = {}
Hooks.SnippetTransport = {
  updated() {
    console.log('UPDATE EVENT')
    let prevCursor = cm.getCursor()
    cm.doc.setValue(this.el.innerText)
    cm.setCursor(prevCursor)
  },
}
Hooks.CodeMirrorTextArea = {
  updated() {
    console.log('Editor has been updated')
  },
  mounted() {
    console.log('Editor has been mounted')
    this.initEditor()
  },
  initEditor() {
    cm.doc.setValue(this.el.dataset.initial)
    cm.on('change', (editor, {origin}) => {
      // Make sure the input value is coming from the user input
      if (origin !== 'setValue') {
        console.log('CHANGE EVENT')
        this.pushEvent('change_value', editor.getValue())
      }
    })
  },
}

let liveSocket = new LiveSocket('/live', Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

window.copyLink = () => {
  var dummy = document.createElement('input')
  var text = window.location.href

  document.body.appendChild(dummy)
  dummy.value = text
  dummy.select()
  document.execCommand('copy')
  document.body.removeChild(dummy)

  document.querySelector('#copy-link-text').textContent = 'Copied!'
}
