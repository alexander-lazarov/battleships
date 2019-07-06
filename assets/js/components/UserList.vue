<template>
  <section>
    <h2>Users</h2>
    <div v-if="loading">Loading...</div>
    <ul v-else>
      <li v-for="user in users">
        <a href="#" @click="challengeUser(user.id)">
          {{ user.name }}
        </a>
      </li>
    </ul>
    <div v-if="error">{{ error }}</div>
  </section>
</template>

<script>
import {appSocket} from '../appSocket.js'

var channel
var privateChannel

export default {
  data: function () {
    return {
      loading: true,
      users: [],
      error: null
    }
  },
  methods: {
    refresh: function () {
      channel.push("getusers", {})
    },
    challengeUser(userName) {
      this.error = null

      channel.push("challenge", {user: userName})
    }
  },
  mounted: function() {
    channel = appSocket().channel("userlist:get")

    channel.join()
      .receive("error", resp => { console.log("Error loading users:", resp) })
      .receive("ok", function(resp) {
        privateChannel = appSocket().channel(`userlist:${resp.id}`)

        privateChannel
          .on("gameStart", resp => {
            this.error = null

            this.$emit("gameStarted", resp.game_id)
          })

        privateChannel.join()

        this.refresh()
      }.bind(this))

    channel
      .on("list", resp => {
        this.users = resp.users
        this.loading = false
      })

    channel
      .on("gameError", resp => {
        this.error = resp.error
      })
  }
}
</script>
