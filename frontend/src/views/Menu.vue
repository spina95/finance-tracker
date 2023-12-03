<template>
  <v-layout class="rounded rounded-md"> 
    <v-navigation-drawer>
      <v-list>
        <v-list-item title="Navigation drawer"></v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar title="Expenses" :elevation="1" color="green"></v-app-bar>

    <v-main class="d-flex" style="min-height: 300px; align-items: start;">
      <v-container style="width: 100%;">
       <ExpensesView />
    </v-container>
    </v-main>

  </v-layout>
</template>
  
<script setup>
    import { ref } from 'vue'
  
    const cards = ['Today', 'Yesterday']
    const links = [
      ['mdi-inbox-arrow-down', 'Inbox'],
      ['mdi-send', 'Send'],
      ['mdi-delete', 'Trash'],
      ['mdi-alert-octagon', 'Spam'],
    ]
  
    const drawer = ref(null)
  </script>
  
  <script>
    import ExpensesView from './ExpensesView.vue';
    export default {
      components: {
        ExpensesView
      },
      data: () => ({
        cards: ['Today', 'Yesterday'],
        drawer: null,
        links: [
          ['mdi-inbox-arrow-down', 'Inbox'],
          ['mdi-send', 'Send'],
          ['mdi-delete', 'Trash'],
          ['mdi-alert-octagon', 'Spam'],
        ],
      }),
    }
</script>