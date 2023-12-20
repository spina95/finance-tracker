<script setup>
import axios from 'axios';
import wallet from '@images/cards/wallet-info.png'
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
        const data = axios.get("http://127.0.0.1:8000/api/v1/expenses/current-month").then( response => {
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
        title: 'Expenses',
        image: wallet,
        stats: this.data.amount ? this.data.amount + ' €' : '0 €',
        change: this.data.increase,
      }"
  />
</template>
