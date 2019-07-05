<template>
  <div>
    <input v-model="username" :disabled="isLoading">
    <input type="submit" @click="join" value="join" :disabled="isLoading">
  </div>
</template>

<script>
import {appSocket} from '../appSocket.js'

var channel

export default {
  data: function() {
    return {
      username: '',
      isLoading: false
    }
  },
  methods: {
    join: function () {

      this.isLoading = true

      channel = appSocket().channel("userlist:join", {username: this.username})

      channel.join()
        .receive("ok", resp => { this.$emit('connected') })
        .receive("error", resp => { this.isLoading = false })
    }
  },
  mounted: function () {
  }
}
</script>
