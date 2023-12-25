<script setup>
import axios from 'axios';
import card from '@images/cards/credit-card-primary.png'
</script>

<script>
export default {
  data() {
    return {
      data: {}
    };
  },

  methods: {
    async getData() {
      try {
        const data = axios.get("http://127.0.0.1:8000/api/v1/data/current-month-incomes").then( response => {
          this.data = response.data
      })
        
      } catch (error) {
        console.log(error);
      }
    },
  },

  created() {
    this.getData();
  },
};
</script>

<template>
  <CardStatisticsVertical
      v-bind="{
        title: 'Incomes',
        image: card,
        stats: this.data.amount ? this.data.amount + ' €' : '0 €',
        change: this.data.increase,
      }"
  />
</template>
