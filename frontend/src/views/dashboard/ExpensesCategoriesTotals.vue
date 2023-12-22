<script setup>
import VueApexCharts from 'vue3-apexcharts'
import { useTheme } from 'vuetify'
import { hexToRgb } from '@layouts/utils'
import axios from 'axios';

const vuetifyTheme = useTheme()

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
              fontSize: '17px',
              color: primaryTextColor,
              fontFamily: 'Public Sans',
              formatter: (val) => {return val + "€";}

            },
            total: {
              show: false,
              label: 'Weekly',
              fontSize: '14px',
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
      labels: [],
      series: [],
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
          this.series = []
          this.labels = []
          var colors = []
          for (var i in response.data.categories) {
              this.series.push(response.data.categories[i].total_price)
              this.labels.push(response.data.categories[i].category__name)
              colors.push(response.data.categories[i].category__color)

          } 
          this.$refs.realtimeChart.updateOptions({ labels: this.labels, });
          this.$refs.realtimeChart.updateOptions({ colors: colors, });
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
    <VCardTitle class="mt-4">Expenses Categories</VCardTitle>
    <VCardItem class="justify-center text-center">
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
        class="v-tabs-pill mt-4"
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
            ref="realtimeChart" 
            type="donut"
            :height="125"
            width="105"
            :options="chartOptions"
            :series="series"
            :labels="labels"
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
