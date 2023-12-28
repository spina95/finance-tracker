<script setup>
import VueApexCharts from 'vue3-apexcharts'
import {
  useDisplay,
  useTheme,
} from 'vuetify'
import { hexToRgb } from '@layouts/utils'
import { toHandlers } from 'vue';

const vuetifyTheme = useTheme()
const display = useDisplay()

const chartOptions = computed(() => {
  vuetifyTheme.current.theme
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
        intersect: false,
        theme: 'dark'
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
      chartData: [],
      cashCheck: false,
      yearsTabs: [
        "2021",
        "2022",
        "2023",
        "2024",
        "2025"
      ],
      currentYearTab: "2023"
    };
  },

  methods: {
    async getData() {
      try {
        var values = []
        const data = this.axios.get("/data/expenses/months",
        { params: {
            'year': this.currentYearTab,
            'cash': this.cashCheck,
        }}).then( response => {
          const expenses = Array.from(response.data,(val,index)=> val.amount );  
          values.push(
            {
              name: 'Expenses',
              data: expenses,
            }
          )
          const data = this.axios.get("data/incomes/months",
          { params: {
            'year': this.currentYearTab,
            'cash': this.cashCheck,
          }}).then( response => {
          const incomes = Array.from(response.data,(val,index)=> val.amount );  
          values.push(
            {
              name: 'Incomes',
              data: incomes,
            }
          )
          this.chartData = values
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
  watch: {
    cashCheck: function(val){
      this.getData()
    }
  }
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
        <VCardItem>
          <VCardTitle>Total Revenue</VCardTitle>

            <div class="justify-center w-100 align-middle">
              <v-row align="center" justify="center">
                <VTabs
                v-model="currentYearTab"
                @click="getData()"
                align-tabs="center"
                class="v-tabs-pill"
              >
                <v-tab
                  v-for="tab in this.yearsTabs"
                  v-if="this.yearsTabs"
                  :key="tab"
                  :value="tab"
                  
                >
                  {{ tab }}
                </v-tab>
              </VTabs>

              <v-spacer/>

              <v-col cols="auto">
                <v-btn 
                  density="default" 
                  icon="mdi-cash"
                  v-bind:color="cashCheck === true ? 'success' : 'grey-300'"
                  @click="cashCheck = !cashCheck"
                  >
                  
                </v-btn>
              </v-col>
              </v-row>
            </div>     
        </VCardItem>

        <!-- bar chart -->
        <div
        v-if="this.chartData">
        <VueApexCharts
        :height="405"
        :options="chartOptions.bar"
        :series="this.chartData"
        
        class="ma-4"
      />
        </div>
        
      </VCol>

      
    </VRow>
  </VCard>
</template>

<style lang="scss">

</style>
