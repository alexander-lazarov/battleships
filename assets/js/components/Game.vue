<template>
  <section>
    Game {{ gameId }}
  </section>
</template>

<script>
import {appSocket} from '../appSocket.js'

var channel

export default {
  props: ['gameId'],
  data: function () {
    return {};
  },
  watch: {
    gameId: function () {
      this.initGame();
    }
  },
  methods: {
    initGame: function() {
      console.log('init game')
      channel = appSocket().channel(`game:${this.gameId}`)
      channel.on("leave", resp => { this.leaveGame() })

      channel.join()
    },
    leaveGame: function () {
      console.log('leave game')
      channel.leave()
    }
  },
  mounted: function() {
   this.initGame();
  }
}
</script>
