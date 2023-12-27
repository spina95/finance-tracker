<script setup>

</script>

<script>
export default {
  props: {
    productId: null,
  },
  data() {
    return {
      data: [],
      dates: [],
      product: null
    };
  },

  methods: {
    async getData() {
      try {
        this.axios.get("/investments/products/" + this.productId).then( response => {
          this.product = response.data
        })
        const data = this.get("/investments/products/" + this.productId + "/info").then( response => {
          const values = [
            {"City": response.data.info.city},
            {"State": response.data.info.state},
            {"Country": response.data.info.country},
            {"Sector": response.data.info.sector},
            {"State": response.data.info.state},
            {"State": response.data.info.state},
          ]
      
          this.data = values
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
  <VCol>
    <VRow>
      <div v-if="this.product" class="ml-4">
      <div>Ticker: {{this.product.ticker}}</div>
      <div v-if="this.product.link" class="ml-4">
        <a v-bind:href="this.product.link" target="_blank" rel="noreferrer">
          <v-icon icon="mdi-link"></v-icon>
        </a>
      </div>

      <VRow>
      <div v-for="item in this.data" >
        <VCol cols="12"><b>{{Object.keys(item)[0]}}:</b> {{item[ Object.keys(item)[0] ]}}</VCol>
     </div>
      </VRow>
      </div>
    </VRow>
  </VCol>
</template>
