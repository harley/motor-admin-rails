<template>
  <component
    :is="linkParams.is"
    :href="linkParams.href"
    :target="linkParams.target"
    rel="nofollow"
    :class="format.link_text ? 'ivu-btn ivu-btn-primary ivu-btn-ghost' : 'text-break-all'"
    @click.stop
  >
    {{ format.link_text || truncatedValue }}
  </component>
</template>

<script>
import Truncate from '../mixins/truncate'

export default {
  name: 'TextCell',
  mixins: [Truncate],
  props: {
    value: {
      type: [String],
      required: false,
      default: ''
    },
    format: {
      type: Object,
      required: false,
      default: () => ({})
    }
  },
  computed: {
    linkParams () {
      const params = {}

      if (this.value.match(/^(https?:|\/rails)/)) {
        params.target = '_blank'
        params.is = 'a'
        params.href = this.value
      } else {
        const resolvedRoute = this.$router.resolve({ path: this.value }, this.$route)

        if (resolvedRoute?.name) {
          params.is = 'RouterLink'
          params.to = resolvedRoute
        } else {
          params.is = 'a'
          params.href = this.value
        }
      }

      return params
    }
  },
  methods: {
    copyToClipboard () {
      const url = this.value[0] === '/' ? document.location.origin + this.value : this.value

      return navigator.clipboard.writeText(url)
    }
  }
}
</script>

<style lang="scss">
</style>
