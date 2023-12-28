<script setup>
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
        const data = this.axios.get("data/current-month-expenses").then( response => {
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
        stats: data?.amount ? data?.amount + ' €' : '0 €',
        change: data?.increase,
      }"
  />
</template>
