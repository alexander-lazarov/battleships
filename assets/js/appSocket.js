import {Socket} from "phoenix"

var socket = null;

let rejoin = function (tries) {
  return null;
}

export function appSocket() {
  if (socket === null) {
    socket = new Socket("/socket", {params: {}, rejoinAfterMs: rejoin})
  }

  return socket
}

export default {
  appSocket
}
