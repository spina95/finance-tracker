<script setup>
import {
  useDisplay,
  useTheme,
} from 'vuetify'

import api from '@/common/api'

</script>

<script>
export default {
  data() {
    return {
      note: null,
      inputText: '',
      inputTitle: ''
    };
  },

  methods: {
    async getData() {
      try {
        const id = this.$route.params.id
        api.notesAPI.getById(id).then( response => {
          this.note = response.data
          this.inputText = response.data.text
          this.inputTitle = response.data.title
        })
      } catch (error) {
        console.log(error);
      }
    },

    async saveNote() {
      try {
        const id = this.$route.params.id
        this.note.text = this.inputText
        this.note.title = this.inputTitle
        api.notesAPI.put(id, this.note).then( response => {
          this.note = response.data
        })
      } catch (error) {
        console.log(error);
      }
    },

    async deleteNote() {
      try {
        const id = this.$route.params.id
        api.notesAPI.delete(id).then( response => {
          this.$router.push("/personal/journal")
        })
      } catch (error) {
        console.log(error);
      }
    },
  },

  created() {
    this.getData();
  },
  watch: {
    
  }
};
</script>

<template>
  <VCol>
    <VRow class="mb-8">
      <VCol cols="10">
        <v-text-field
          v-model="inputTitle"
          variant="plain"
          class="h2-textfield"
        ></v-text-field>
        <span>Last edited {{ new Date(this.note?.last_updated_at).toLocaleDateString('en-US', { weekday: 'short', day: 'numeric', month: 'long', year: 'numeric', hour: 'numeric', minute: 'numeric' })  }}</span>
      </VCol>
      <VCol cols="1" class="d-flex align-center justify-center">
        <v-icon @click="saveNote" class="clickable-icon">
          mdi-content-save
        </v-icon>
      </VCol>
      <VCol cols="1" class="d-flex align-center justify-center">
        <v-icon @click="deleteNote" class="clickable-icon">
          mdi-delete
        </v-icon>
      </VCol>
    </VRow>

    <v-textarea
      v-model="inputText"
      variant="plain"
      auto-grow
    ></v-textarea>
  </VCol>
</template>

<style lang="scss">
.clickable-icon {
  cursor: pointer;
}

.h2-textfield input {
  font-size: 2rem !important; /* Font size similar to h2 */
  font-weight: 800 !important; /* Font weight similar to h2 */
}


</style>
