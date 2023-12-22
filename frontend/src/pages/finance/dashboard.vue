<script setup>
import AnalyticsCongratulations from '@/views/dashboard/AnalyticsCongratulations.vue'
import AnalyticsFinanceTabs from '@/views/dashboard/AnalyticsFinanceTab.vue'
import AnalyticsOrderStatistics from '@/views/dashboard/AnalyticsOrderStatistics.vue'
import AnalyticsProfitReport from '@/views/dashboard/AnalyticsProfitReport.vue'
import AnalyticsTotalRevenue from '@/views/dashboard/AnalyticsTotalRevenue.vue'
import AnalyticsTransactions from '@/views/dashboard/AnalyticsTransactions.vue'
import ExpensesCategoriesTotals from '@/views/dashboard/ExpensesCategoriesTotals.vue'
import LastTransactions from '@/views/dashboard/LastTransactions.vue'
import AnalyticsMonthly from '@/views/dashboard/AnalyticsMonthly.vue'
import CurrentMonthExpenses from '@/views/dashboard/CurrentMonthExpenses.vue'
import CurrentMonthIncomes from '@/views/dashboard/CurrentMonthIncomes.vue'
// 👉 Images
import chart from '@images/cards/chart-success.png'
import card from '@images/cards/credit-card-primary.png'
import paypal from '@images/cards/paypal-error.png'
import wallet from '@images/cards/wallet-info.png'
</script>

<template>
  <VRow>
    <VCol
      cols="12"
      md="9"
      xs="12"
    >
      <AnalyticsMonthly />
    </VCol>

    <VCol
      cols="12"
      sm="3"
      xs="12"
    >
      
        <!-- 👉 Profit -->
        <VCol
          cols="12"
          md="12"
          class="text-center"
        >
          CURRENT MONTH
        </VCol>

        <VCol
          cols="12"
          md="12"
        >
          <CurrentMonthExpenses/>
        </VCol>

        <!-- 👉 Sales -->
        <VCol
          cols="12"
          md="12"
        >
        <CurrentMonthIncomes/>
        </VCol>
      
    </VCol>

    <VCol
      cols="12"
      md="6"
      sm="6"
      order="3"
    >
      <LastTransactions />
    </VCol>

    <VCol
      cols="12"
      md="6"
      sm="6"
      order="3"
    >
      <ExpensesCategoriesTotals />
    </VCol>
  </VRow>
</template>
