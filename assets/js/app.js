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

let Hooks = {}
Hooks.ShowSnippetTransport = {
  mounted() {
    this.cm = CodeMirror(document.getElementById('textarea'), {
      lineNumbers: true,
      mode: 'javascript',
      theme: 'duotone-dark',
      autoFocus: true,
      foldGutter: true,
      autofocus: true,
      value: this.el.innerText,
      readOnly: true,
    })
  },
}
Hooks.SnippetTransport = {
  mounted() {
    this.cm = CodeMirror(document.getElementById('textarea'), {
      lineNumbers: true,
      mode: 'javascript',
      theme: 'duotone-dark',
      autoFocus: true,
      foldGutter: true,
      autofocus: true,
      value: this.el.innerText,
    })

    this.cm.on('change', (editor, {origin}) => {
      if (origin !== 'setValue') {
        // TODO: Debounce input
        this.pushEvent('change_value', editor.getValue())
      }
    })
  },
  updated() {
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
