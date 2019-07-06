<template>
  <section>
    Game {{ gameId }}
    <input type="button" value="Leave" @click="sendLeave" />
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
      channel = appSocket().channel(`game:${this.gameId}`)
      channel.on("gameEnd", resp => { this.leaveGame() })

      channel.join()
    },
    leaveGame: function () {
      this.$emit('gameEnded')

      channel.leave()
    },
    sendLeave: function () {
      channel.push("leave", {game_id: this.gameId})
    }
  },
  mounted: function() {
   this.initGame();
  }
}
</script>
