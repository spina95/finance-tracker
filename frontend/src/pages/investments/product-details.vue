<script setup>
import NewProductForm from '@/views/pages/form-layouts/NewProductForm.vue';
import ProductDetails from '@/views/pages/form-layouts/ProductDetails.vue';
import ProductHistory from '@/views/charts/ProductHistory.vue'

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
        const data = this.axios.get("/investments/products/" + id).then( response => {
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
