<script setup>
import VueApexCharts from 'vue3-apexcharts'
import {
  useDisplay,
  useTheme,
} from 'vuetify'
import { hexToRgb } from '@layouts/utils'
import axios from 'axios';
import { toHandlers } from 'vue';

const vuetifyTheme = useTheme()
const display = useDisplay()

const chartOptions = computed(() => {
  const currentTheme = vuetifyTheme.current.value.colors
  const variableTheme = vuetifyTheme.current.value.variables
  const disabledTextColor = `rgba(${ hexToRgb(String(currentTheme['on-surface'])) },${ variableTheme['disabled-opacity'] })`
  const primaryTextColor = `rgba(${ hexToRgb(String(currentTheme['on-surface'])) },${ variableTheme['high-emphasis-opacity'] })`
  const borderColor = `rgba(${ hexToRgb(String(variableTheme['border-color'])) },${ variableTheme['border-opacity'] })`
  
  return {
    bar: {
      chart: {
        height: 350,
        type: 'bar',
        toolbar: {
            show: true
        }
    },
      dataLabels: { enabled: false },
      stroke: {
        show: true,
        width: 1,
        
      },
      legend: {
        offsetX: -10,
        position: 'top',
        fontSize: '14px',
        horizontalAlign: 'left',
        fontFamily: 'Public Sans',
        labels: { colors: currentTheme.secondary },
        itemMargin: {
          vertical: 4,
          horizontal: 10,
        },
        
      },
      states: {
        hover: { filter: { type: 'none' } },
        active: { filter: { type: 'none' } },
      },
      grid: {
        borderColor,
      },
      tooltip: {
        shared: true,
        intersect: false
      },
      plotOptions: {
        bar: {
      dataLabels: {
        orientation: 'vertical',
        position: 'center' // bottom/center/top
      }
    }
      },
      xaxis: {
        axisTicks: { show: false },
        crosshairs: { opacity: 0 },
        axisBorder: { show: false },
        categories: [
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
        ],
        labels: {
          style: {
            fontSize: '14px',
            colors: disabledTextColor,
            fontFamily: 'Public Sans',
          },
        },
      },
      yaxis: {
        labels: {
          style: {
            fontSize: '14px',
            colors: disabledTextColor,
            fontFamily: 'Public Sans',
          },
        },
      },
      responsive: [
        {
          breakpoint: display.thresholds.value.xl,
          options: { plotOptions: { bar: { columnWidth: '43%' } } },
        },
        {
          breakpoint: display.thresholds.value.lg,
          options: { plotOptions: { bar: { columnWidth: '50%' } } },
        },
        {
          breakpoint: display.thresholds.value.md,
          options: { plotOptions: { bar: { columnWidth: '42%' } } },
        },
        {
          breakpoint: display.thresholds.value.sm,
          options: { plotOptions: { bar: { columnWidth: '45%' } } },
        },
      ],
    },
  }
})
</script>

<script>
export default {
  data() {
    return {
      data: [],
    };
  },

  methods: {
    async getData() {
      try {
        var values = []
        const data = axios.get("http://127.0.0.1:8000/api/v1/expenses/months?year=2023").then( response => {
          const expenses = Array.from(response.data,(val,index)=> val.amount );  
          values.push(
            {
              name: 'Expenses',
              data: expenses,
            }
          )
          const data = axios.get("http://127.0.0.1:8000/api/v1/incomes/months?year=2023").then( response => {
          const incomes = Array.from(response.data,(val,index)=> val.amount );  
          values.push(
            {
              name: 'Incomes',
              data: incomes,
            }
          )
          this.data = values
      })  
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
    <VRow no-gutters>
      <VCol
        cols="12"
        sm="12"
        xl="12"
        :class="$vuetify.display.smAndUp ? 'border-e' : 'border-b'"
      >
        <VCardItem class="pb-0">
          <VCardTitle>Total Revenue</VCardTitle>

          
        </VCardItem>

        <!-- bar chart -->
        <VueApexCharts
          :height="405"
          :options="chartOptions.bar"
          :series="this.data"
        />
      </VCol>

      
    </VRow>
  </VCard>
</template>

<style lang="scss">
#bar-chart .apexcharts-series[rel="2"] {
  transform: translateY(-10px);
}
</style>
