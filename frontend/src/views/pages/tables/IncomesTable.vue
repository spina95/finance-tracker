<script>
import { computed, nextTick, ref, watch } from 'vue'
import api from '@/common/api'

export default {
  components: {
    },
  data() {
    return {
        editedItem: ref({
            name: '',
            amount: 0,
            type: '',
            payment: '',
            date: '',
        }),
        dialog: ref(false),
        editedIndex: ref(-1),
        data: [],
        headers: [
          {
            key: 'amount',
            title: 'Amount',
            align: 'start',
            sortable: true,
          },
          {
            key: 'name',
            title: 'Name',
            align: 'start',
            sortable: true,
          },
          {
            key: 'category',
            title: 'Type',
            align: 'start',
            sortable: false,
          },
          {
            key: 'paymentType',
            title: 'Payment',
            align: 'start',
            sortable: false,
          },
          {
            key: 'date',
            title: 'Date',
            align: 'start',
            sortable: true,
          }
        ],
        itemsPerPage: 25,
        totalItems: 30,
        categoriesTotals: [],
        loading: true
    }
  },
    

  methods: {
    loadItems (val)  {
      this.data = []
      var sortBy = null
      if (val.sortBy[0]){
        if (val.sortBy[0].order == 'desc') {
          sortBy = "-" + val.sortBy[0].key
        } else {
          sortBy = val.sortBy[0].key
        }        
      }
      api.incomesAPI.query({
        'page': (val.page),
        'size': val.itemsPerPage,
        'ordering': sortBy,
      }).then(response => {
        this.data = response.data.results
        this.totalItems = response.data.count
        this.loading = false
      })
        .catch(error => console.log(error))
      
      },

      close () {
      dialog.value = false
        nextTick(() => {
          editedItem.value = Object.assign({}, defaultItem.value)
          editedIndex.value = -1
        })
      },
      save () {
        this.postData(this.editedItem)
        this.close()
      },
      handlePageChange: function(e) {
        console.log('::'+no);
        console.log('handlePageChange')
        this.updateTableData();
      }, 
  },
  watch: {
    dialog: function(val){
      val || close()
    }
  }
}
</script>

<template>
  <div>
    <v-data-table-server
      fixed-header
      height="700px"
      v-model:items-per-page="itemsPerPage"
      :headers="headers"
      :items-length="totalItems"
      :items="data"
      :loading="!data.length"
      :search="search"
      item-value="name"
      hide-default-footer
      @update:options="loadItems"
      class="elevation-1"
      style="border-radius: 8px;"
    >
  
    <template v-slot:header.calories="{ header }">
  <v-text-field label="search calories" @click.stop />
</template>
    <template v-slot:item.amount="{ value }">
        <div style="font-weight: bold;">{{ value }} €</div>
    </template>
    <template v-slot:item.category="{ value }">
      <VAvatar
          rounded
          variant="tonal"
          :color="value.color"
          class="me-3"
        >
        <VIcon :icon="value.icon" />
      </VAvatar>
    </template>
    <template v-slot:item.paymentType="{ value }">
      <VAvatar
          rounded
          variant="tonal"
          :color="value.color"
          class="me-3"
        >
        <VIcon :icon="value.icon" />
      </VAvatar>
    </template>
  </v-data-table-server>
  </div>
  
</template>

<style scoped>

</style>