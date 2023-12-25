<script setup>
import NewProductForm from '@/views/pages/form-layouts/NewProductForm.vue';
import ProductDetails from '@/views/pages/form-layouts/ProductDetails.vue';
import ProductHistory from '@/views/charts/ProductHistory.vue'
import axios from 'axios';

</script>


<script>
export default {
  data() {
    return {
      product: null,
    };
  },

  methods: {
    async getData() {
      try {
        const id = this.$route.params.id
        const data = axios.get("http://127.0.0.1:8000/api/v1/investments/products/" + id).then( response => {
          this.product = response.data
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
  <VCard class="pa-8" :title="product ? product.name : ''">
    <ProductDetails :productId="this.$route.params.id"/>
    <ProductHistory :productId="this.$route.params.id"/>
</VCard>
</template>
