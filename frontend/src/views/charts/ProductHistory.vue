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
          options: {
            chart: {
          id: 'area-datetime',
          type: 'area',
          height: 350,
          zoom: {
            autoScaleYaxis: true
          }
        },
        annotations: {
          yaxis: [],
          xaxis: []
        },
        dataLabels: {
          enabled: false
        },
        markers: {
          size: 0,
          style: 'hollow',
        },
        xaxis: {
          type: 'datetime',
          tickAmount: 6,
          labels: {
            style: {
              fontSize: '14px',
              colors: disabledTextColor,
              fontFamily: 'Public Sans',
            },
          },
        },
        yaxis: {
          type: 'datetime',
          tickAmount: 6,
          labels: {
            formatter: function(val) {
              return val.toFixed(2);
            },
            style: {
              fontSize: '14px',
              colors: disabledTextColor,
              fontFamily: 'Public Sans',
            },
          },
        },
        tooltip: {
          x: {
            format: 'dd MMM yyyy'
          }
        },
        fill: {
          type: 'gradient',
          gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.7,
            opacityTo: 0.9,
            stops: [0, 100]
          }
        },
        
            
}}})
</script>

<script>
export default {
  props: {
    productId: null,
    product: null,
  },
  data() {
    return {
      data: [],
      dates: []  
    };
  },

  methods: {
    async getData() {
     

      try {
        const data = this.axios.get("/investments/products/" + this.productId + "/history").then( response => {
          const values = [{
              name: "Desktops",
              data: response.data.history.Open
          }]
          this.data = values
          this.dates = response.data.dates
          this.$refs.realtimeChart.updateOptions({ 
            xaxis: {
              categories: this.dates
            } 
        });
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
    <VRow no-gutters>
      <VCol
        cols="12"
        sm="12"
        xl="12"
        :class="$vuetify.display.smAndUp ? 'border-e' : 'border-b'"
      >
       

        <!-- bar chart -->
        <VueApexCharts
          ref="realtimeChart" 
          :height="405"
          :options="chartOptions.options"
          :series="this.data"
          class="ma-4"
        />
      </VCol>
      
    </VRow>
</template>

<style lang="scss">

</style>
