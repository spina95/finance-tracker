<script setup>
import NotesList from '@/views/personal/NotesList.vue'
import api from '@/common/api'

</script>

<script>
export default {

  methods: {
    async createNote() {
      try {
        
        api.notesAPI.post(
          {
            'title': 'New note',
            'text': 'New note'
          }
        ).then( response => {
          this.$router.push("/personal/journal/" + response.data.id)
        })
      } catch (error) {
        console.log(error);
      }
    },
  },

};
</script>

<template>
  <VCol>
    <VRow>
      <VCol cols="11">
        <h1>Journal</h1>
      </VCol>
      <VCol cols="1">
        <v-icon @click="createNote" class="clickable-icon">
          mdi-add
        </v-icon>
      </VCol>
    </VRow>
    <NotesList style="margin-top: 8px;"/>
  </VCol>
</template>
