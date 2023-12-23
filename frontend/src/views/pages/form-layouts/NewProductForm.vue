<script setup>
import axios from 'axios';

</script>

<script>
export default {
  data() {
    return {
        name: null,
        ticker: null,
        category: null,
        link: null,
        categories: [],
    };
  },

  methods: {
    async getData() {
      try {
        const data = axios.get("http://127.0.0.1:8000/api/v1/investments/products-categories").then( response => {
          this.categories = response.data.results
      })
        
      } catch (error) {
        console.log(error);
      }
    },

    async submit() {
        const data = {
            "name": this.name,
            "ticker": this.ticker,
            "link": this.link,
            "category": this.category
        }
        try {
        axios.post("http://127.0.0.1:8000/api/v1/investments/products/", data).then( response => {
          console.log(response)
        })
            
        } catch (error) {
            console.log(error);
        }
    }
  },

  created() {
    this.getData();
  },
};
</script>

<template>
  <VForm @submit.prevent="submit">
    <VRow>
      <VCol cols="6">
        <VTextField
          v-model="name"
          label="Name"
          placeholder="VWCE"
          required
        />
      </VCol>

      <VCol cols="6">
        <VTextField
          v-model="ticker"
          label="Ticker"
          placeholder="vwce"
          required
        />
      </VCol>

      <VCol cols="6">
        <v-select
        v-model="category"
        :items="categories"
        item-title="name"
        :rules="[v => !!v || 'Item is required']"
        label="Category"
        v-bind="{'return-object':true}"
        required
        ></v-select>
      </VCol>

      <VCol cols="6">
        <VTextField
          v-model="link"
          label="Link"
          type="link"
          placeholder="https://www.justetf.com/..."
        />
      </VCol>

      <VCol
        cols="12"
        class="d-flex gap-4"
      >
        <VBtn type="submit">
          Submit
        </VBtn>

        <VBtn
          type="reset"
          color="secondary"
          variant="tonal"
        >
          Reset
        </VBtn>
      </VCol>
    </VRow>
  </VForm>
</template>
