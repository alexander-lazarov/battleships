<template>
  <section>
    <Join :username="username"/>
  </section>
</template>

<script>
import {Socket} from "phoenix"
import {Join} from "./components/Join.vue"

var socket

export default {
  props: {
    username: null,
    channel: null
  },
  methods: {
    join: function () {
      console.log('join clicked')
    }
  },
  mounted: function () {
    socket = new Socket("/socket", {params: {}})
    socket.connect()

    let channel = socket.channel("battleships:join")

    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }
};
</script>
