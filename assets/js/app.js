// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css'
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

    this.cm.on('mousedown', (cm) => {
      this.pushEvent('move_cursor', cm.doc.getCursor())
    })
    this.cm.on('keydown', (cm) => {
      this.pushEvent('move_cursor', cm.doc.getCursor())
    })
  },
  updated() {
    console.log('Transport Updated')
    let prevCursor = this.cm.getCursor()
    this.cm.doc.setValue(this.el.innerText)
    this.cm.setCursor(prevCursor, {origin: 'setSelectionAdjustment'})
  },
}

let liveSocket = new LiveSocket('/live', Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})
liveSocket.connect()
