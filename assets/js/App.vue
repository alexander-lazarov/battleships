<template>
  <section>
    <Join @connected="connected" v-if="!isConnected"/>
    <Userlist
      v-if="isConnected && !inGame"
      @gameStarted="gameStarted"
      />
    <Game
      v-if="isConnected && inGame"
      :game-id="gameId"
      @gameEnded="gameEnded"
      />
  </section>
</template>

<script>
import {appSocket} from './appSocket.js'
import Join from "./components/Join.vue"
import Userlist from "./components/Userlist.vue"
import Game from "./components/Game.vue"

export default {
  data: function () {
    return {
      isConnected: false,
      inGame: false,
      gameId: null
    };
  },
  mounted: function () {
    appSocket().connect()
  },
  methods: {
    connected: function () {
      this.isConnected = true
    },
    gameStarted: function (gameId) {
      this.inGame = true
      this.gameId = gameId
    },
    gameEnded: function () {
      this.inGame = false
      this.gameId = null
    }
  },
  components: {
    Join,
    Userlist,
    Game
  }
};
</script>
