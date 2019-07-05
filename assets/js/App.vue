<template>
  <section>
    <Join @connected="connected" v-if="!isConnected"/>
  </section>
</template>

<script>
import {appSocket} from './appSocket.js'
import Join from "./components/Join.vue"

export default {
  data: function () {
    return {
      isConnected: false
    };
  },
  mounted: function () {
    appSocket().connect()
  },
  methods: {
    connected: function () {
      this.isConnected = true
    }
  },
  components: {
    Join
  }
};
</script>
