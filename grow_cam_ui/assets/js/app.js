// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import bulmaCalendar from '../node_modules/bulma-calendar/dist/js/bulma-calendar.min.js';

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")



let hooks = {}

hooks.ScheduleForm = {
    mounted() {
        var calendars = bulmaCalendar.attach('[type="date"]', {dateFormat: "YYYY-MM-DD"});
    }
}

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())


// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

document.addEventListener('DOMContentLoaded', (event) => {
        var element = document.getElementById('navbar-menu');
        var trigger = document.getElementById('navbar-burger'); // or whatever triggers the toggle
        trigger.addEventListener('click', function(e) {
            e.preventDefault();
            element.classList.toggle('is-active'); // or whatever your active class is
        })
  })

