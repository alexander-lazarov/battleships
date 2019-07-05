<template>
  <section>
    Game {{ gameId }}
  </section>
</template>

<script>
import {appSocket} from '../appSocket.js'

var channel
var privateChannel

export default {
  props: ['gameId'],
  data: function () {
    return {};
  },
  methods: {
  },
  mounted: function() {
  }
}
</script>
