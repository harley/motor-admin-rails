<template>
  <div>
    <VForm
      ref="form"
      :rules="rules"
      label-position="top"
      :model="dataScope"
    >
      <FormItem
        :label="i18n['name']"
        prop="display_name"
      >
        <VInput v-model="dataScope.display_name" />
      </FormItem>
      <Filters
        v-model:filters="dataScope.preferences.filter"
        :model="resource"
      />
    </VForm>
    <div class="d-flex justify-content-between">
      <div>
        <VButton
          v-if="withRemove"
          type="error"
          ghost
          class="me-2"
          @click="$emit('remove')"
        >
          {{ i18n['remove'] }}
        </VButton>
        <VButton
          @click="$emit('cancel')"
        >
          {{ i18n['cancel'] }}
        </VButton>
      </div>
      <VButton
        type="primary"
        :loading="isLoading"
        @click="submit"
      >
        {{ i18n['save'] }}
      </VButton>
    </div>
  </div>
</template>

<script>
import Filters from 'data_resources/components/filters'
import { fieldRequiredMessage } from 'utils/scripts/i18n'

export default {
  name: 'ResourceScopeForm',
  components: {
    Filters
  },
  props: {
    scope: {
      type: Object,
      required: true
    },
    resource: {
      type: Object,
      required: true
    },
    withRemove: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  emits: ['cancel', 'submit', 'remove'],
  data () {
    return {
      isLoading: false,
      dataScope: {}
    }
  },
  computed: {
    rules () {
      const rules = {
        display_name: [{
          required: true,
          message: fieldRequiredMessage('name')
        }]
      }

      return rules
    }
  },
  created () {
    this.dataScope = { ...this.scope }
  },
  methods: {
    submit () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          if (this.dataScope.preferences.filter) {
            this.dataScope.preferences.filter = this.dataScope.preferences.filter.filter((f) => {
              return f === 'OR' || !!Object.keys(f)[0]
            })
          }

          this.$emit('submit', this.dataScope)
        }
      })
    }
  }
}
</script>
