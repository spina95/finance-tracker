<script setup>
import VueApexCharts from 'vue3-apexcharts'
import {
  useDisplay,
  useTheme,
} from 'vuetify'
import { hexToRgb } from '@layouts/utils'
import { toHandlers } from 'vue';
import api from '@/common/api'

const vuetifyTheme = useTheme()
const display = useDisplay()


</script>

<script>
export default {
  data() {
    return {
      notes: [],
    };
  },

  methods: {
    async getData() {
      try {
        var values = []
        
        api.notesAPI.query(
          {
            'year': this.currentYearTab,
          }
        ).then( response => {
          this.notes = response.data.results
        })
      } catch (error) {
        console.log(error);
      }
    },

    goToDetail(noteId) {
      this.$router.push("/personal/journal/" + noteId)
  }
  },

  created() {
    this.getData();
  },
  watch: {
    cashCheck: function(val){
      this.getData()
    }
  }
};
</script>

<template>
    <VRow>
      <VCol
        v-for="note in this.notes"
        :key="note.id"
        cols="12"
        sm="3"
        md="3"
      >

        <VCard @click="goToDetail(note.id)" class="rounded-card d-flex align-center justify-center" :height="200" :width="200">
            <VCol class="d-flex align-center justify-center">
              <VRow align-content="center"><h1>{{ new Date(note.created_at).toLocaleDateString('en-US', { day: 'numeric' })  }}</h1></VRow>
              <VRow class="mt-16"><h3>{{ new Date(note.created_at).toLocaleDateString('en-US', { month: 'long', year: 'numeric' })  }}</h3></VRow>
            </VCol>
        </VCard>
      </VCol>      
    </VRow>
</template>

<style lang="scss">
.rounded-card{
  border-radius:20px;
}
</style>
