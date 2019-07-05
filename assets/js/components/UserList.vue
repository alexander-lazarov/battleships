<template>
  <section>
    <h2>Users</h2>
    <div v-if="loading">Loading...</div>
    <ul v-else>
      <li v-for="user in users">{{ user }}</li>
    </ul>
  </section>
</template>

<script>
import {appSocket} from '../appSocket.js'

var channel

export default {
  data: function () {
    return {
      loading: true,
      users: []
    }
  },
  methods: {
    refresh: function () {
      channel.push("getusers", {})
    }
  },
  mounted: function() {
    channel = appSocket().channel("userlist:get")

    channel.join()
      .receive("ok", resp => { this.refresh() })
      .receive("error", resp => { console.log("Error loading users:", resp) })

    channel
      .on("list", resp => {
        this.users = resp.users
        this.loading = false
      })
  }
}
</script>
