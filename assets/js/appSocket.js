import {Socket} from "phoenix"

var socket = null;

export function appSocket() {
  if (socket === null) {
    socket = new Socket("/socket", {params: {}})
  }

  return socket
}

export default {
  appSocket
}
