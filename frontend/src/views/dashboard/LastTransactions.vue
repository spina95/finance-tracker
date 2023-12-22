<script setup>
import chartInfo from '@images/cards/chart-info.png'
import creditCardSuccess from '@images/cards/credit-card-success.png'
import creditCardWarning from '@images/cards/credit-card-warning.png'
import paypalError from '@images/cards/paypal-error.png'
import walletPrimary from '@images/cards/wallet-primary.png'
import axios from 'axios';
</script>

<script>
export default {
  data() {
    return {
      expenses: [],
    };
  },

  methods: {
    async getData() {
      try {
        const data = axios.get("http://127.0.0.1:8000/api/v1/data/expenses/?size=8&page=1&ordering=-date").then( response => {
          this.expenses = response.data.results
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
  <VCard title="Last Expenses">
    <template #append>
    </template>

    <VCardText>
      <VList class="card-list">
        <VListItem
          v-for="item in expenses"
          :key="item.id"
        >
          <template #prepend>
            <VAvatar
              rounded
              variant="tonal"
              :color="item.paymentType.color"
              class="me-3"
            >
            <VIcon :icon="item.paymentType.icon" />
          </VAvatar>

          <VAvatar
              rounded
              variant="tonal"
              :color="item.category.color"
              class="me-3"
            >
            
              <VIcon :icon="item.category.icon" slot="activator">
              </VIcon>
          </VAvatar>
          </template>
          
          <VListItemTitle>
            {{ item.name }}
          </VListItemTitle>
          <VListItemSubtitle class="text-disabled mb-1">
            {{ item.date }}
          </VListItemSubtitle>
          

          <template #append>
            <VListItemAction>
              <span class="me-1">-{{ item.amount }}</span>
              <span class="text-disabled">EUR</span>
            </VListItemAction>
          </template>
        </VListItem>
      </VList>
    </VCardText>
  </VCard>
</template>

<style lang="scss" scoped>
  .card-list {
    --v-card-list-gap: 1.6rem;
  }
</style>
