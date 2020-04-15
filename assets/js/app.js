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

// TODO: Debounce

let Hooks = {}
Hooks.SnippetTransport = {
  mounted() {
    this.cm = CodeMirror(document.getElementById('textarea'), {
      lineNumbers: true,
      mode: 'javascript',
      theme: 'duotone-dark',
      autoFocus: true,
      foldGutter: true,
      autofocus: true,
      initial: this.el.innerText,
    })

    this.cm.on('change', (editor, {origin}) => {
      // Make sure the input value is coming from the user input
      if (origin !== 'setValue') {
        console.log('CHANGE EVENT')
        this.pushEvent('change_value', editor.getValue())
      }
    })

    // TODO: This also executes when the cursor is set using setCursor
    // TODO: This creates an infinite loop because the the server is setting the
    // data-cursors field which sets the cursor again
    // this.cm.doc.on('cursorActivity', (doc) => {
    //   console.log(doc.getCursor())
    //   this.pushEvent('cursor_move', doc.getCursor())
    // })
  },
  updated() {
    console.log('Transport Updated')
    let prevCursor = this.cm.getCursor()
    this.cm.doc.setValue(this.el.innerText)
    this.cm.setCursor(prevCursor)
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
