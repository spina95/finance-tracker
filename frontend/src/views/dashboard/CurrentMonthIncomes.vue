<script setup>
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
        const data = this.axios.get("data/current-month-incomes").then( response => {
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
        stats: data?.amount ? data?.amount + ' €' : '0 €',
        change: data?.increase,
      }"
  />
</template>
