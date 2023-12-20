<script setup>
import VueApexCharts from 'vue3-apexcharts'
import { useTheme } from 'vuetify'
import { hexToRgb } from '@layouts/utils'
import axios from 'axios';

const vuetifyTheme = useTheme()

const series = [
  45,
  80,
  20,
  40,
]

const chartOptions = computed(() => {
  const currentTheme = vuetifyTheme.current.value.colors
  const variableTheme = vuetifyTheme.current.value.variables
  const disabledTextColor = `rgba(${ hexToRgb(String(currentTheme['on-surface'])) },${ variableTheme['disabled-opacity'] })`
  const primaryTextColor = `rgba(${ hexToRgb(String(currentTheme['on-surface'])) },${ variableTheme['high-emphasis-opacity'] })`
  
  return {
    chart: {
      sparkline: { enabled: true },
      animations: { enabled: false },
    },
    stroke: {
      width: 6,
      colors: [currentTheme.surface],
    },
    legend: { show: false },
    tooltip: { enabled: false },
    dataLabels: { enabled: false },
    labels: [
      'Fashion',
      'Electronic',
      'Sports',
      'Decor',
    ],
    colors: [
      currentTheme.success,
      currentTheme.primary,
      currentTheme.secondary,
      currentTheme.info,
    ],
    grid: {
      padding: {
        top: -7,
        bottom: 5,
      },
    },
    states: {
      hover: { filter: { type: 'none' } },
      active: { filter: { type: 'none' } },
    },
    plotOptions: {
      pie: {
        expandOnClick: false,
        donut: {
          size: '75%',
          labels: {
            show: true,
            name: {
              offsetY: 17,
              fontSize: '14px',
              color: disabledTextColor,
              fontFamily: 'Public Sans',
            },
            value: {
              offsetY: -17,
              fontSize: '24px',
              color: primaryTextColor,
              fontFamily: 'Public Sans',
            },
            total: {
              show: true,
              label: 'Weekly',
              fontSize: '14px',
              formatter: () => '38%',
              color: disabledTextColor,
              fontFamily: 'Public Sans',
            },
          },
        },
      },
    },
  }
})

</script>

<script>
export default {
  data() {
    return {
      expenses: [],
      currentYearTab: "2023",
      currentMonthTab: null,
      yearsTabs: [
        "2021",
        "2022",
        "2023",
        "2024",
        "2025"
      ],
      monthsTabs: [
        'All',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ]
    };
  },

  methods: {
    async getData() {
      try {
        const data = axios.get("http://127.0.0.1:8000/api/v1/expenses/categories-total",
        { params: {
            'year': this.currentYearTab,
            'month': this.currentMonthTab != 'All' ? this.currentMonthTab : null,
        }
        }).then( response => {
          this.expenses = response.data
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
  <VCard>
    <VCardItem class="justify-center text-center">
      <VListItemTitle class="pb-4">YEAR</VListItemTitle>
      <VTabs
        v-model="currentYearTab"
        @click="getData()"
        class="v-tabs-pill "
      >
        <v-tab
          v-for="tab in this.yearsTabs"
          :key="tab"
          :value="tab"
        >
          {{ tab }}
        </v-tab>
      </VTabs>
      <VTabs
        v-model="currentMonthTab"
        @click="getData()"
        class="v-tabs-pill"
        >
        <v-tab
          v-for="tab in this.monthsTabs"
          mandatory=False
          :key="tab"
          :value="tab"
        >
        {{ tab }}
      </v-tab>
      </VTabs>
    </VCardItem>

    <VCardText>
      <div class="d-flex align-center justify-space-between mb-3">
        <div class="flex-grow-1">
          <h4 class="text-h4 mb-1">
           {{ expenses.total ? expenses.total : 0 }} €
          </h4>
          <span>Total Expenses</span>
        </div>

        <div>
          <VueApexCharts
            type="donut"
            :height="125"
            width="105"
            :options="chartOptions"
            :series="series"
          />
        </div>
      </div>

      <VList class="card-list mt-7">
        <VListItem
          v-for="order in expenses.categories"
          :key="order.category__name"
        >
          <template #prepend>
            <VAvatar
              rounded
              variant="tonal"
              :color="order.category__color"
            >
              <VIcon :icon="order.category__icon" />
            </VAvatar>
          </template>

          <VListItemTitle class="mb-1">
            {{ order.category__name }}
          </VListItemTitle>
          <VListItemSubtitle class="text-disabled">
            {{ order.subtitle }}
          </VListItemSubtitle>

          <template #append>
            <span class="me-1">{{ order.total_price }}</span>
            <span class="text-disabled">EUR</span>
          </template>
        </VListItem>
      </VList>
    </VCardText>
  </VCard>
</template>

<style lang="scss" scoped>
.card-list {
  --v-card-list-gap: 21px;
}
</style>
