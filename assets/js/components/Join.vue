<template>
  <input :value="username">
  <input type="submit" @click="join" value="join">
</template>

<script>
export default {
  props: ['username', 'userlistChannel']
}
</script>
