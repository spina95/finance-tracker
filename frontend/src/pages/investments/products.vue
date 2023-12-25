<script setup>
import ProcutsTable from '@/views/pages/tables/ProductsTable.vue'
</script>

<template>
  <VRow>
    <VCol cols="12">
      <VCard>
        <VCardTitle class="ma-4">
          <v-col cols="auto">
          <v-row>
            <div>
              Products
            </div>
            <v-spacer/>
            <router-link
              to="/new-product"
              custom
              v-slot="{ navigate }"
            >
              <v-btn 
                density="compact" 
                icon="mdi-plus" 
                @click="navigate"
                role="link"></v-btn>
           </router-link>
          </v-row>
        </v-col>
        </VCardTitle>
        <ProcutsTable />
      </VCard>
    </VCol>
  </VRow>
</template>
