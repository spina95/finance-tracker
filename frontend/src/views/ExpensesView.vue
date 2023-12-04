<script>
import axios from 'axios';
import { computed, nextTick, ref, watch } from 'vue'

import api from '@/common/api_service/api'

export default {
  components: {
    },
  data() {
    return {
        sortBy: "date",
        order: "asc",
        page: 0,
        itemsPerPage: 10,
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
            key: 'type',
            title: 'Type',
            align: 'start',
            sortable: true,
          },
          {
            key: 'payment',
            title: 'Payment',
            align: 'start',
            sortable: true,
          },
          {
            key: 'date',
            title: 'Date',
            align: 'start',
            sortable: true,
          }
        ],
        itemsPerPage: 10,
        totalItems: 30,
        categories: [],
        priceRange: ref([0, 2000])
    }
  },
    
  mounted() {
    this.loadCategories()
  },

  methods: {
      loadItems (val)  {
        if (val && val.sortBy && val.sortBy[0]){
          this.sortBy = val.sortBy[0].key
          this.order = val.sortBy[0].order
        }
        if (val && val.page && val.itemsPerPage){
          this.page = val.page
          this.itemsPerPage = val.itemsPerPage
        }

        api.expensesAPI.query({
          'order': 'name',
          'page': (this.page - 1) * this.itemsPerPage,
          'limit': this.itemsPerPage,
          'sort-by': this.sortBy,
          'order': this.order,
          'min-price': this.priceRange[0],
          'max-price': this.priceRange[1]
        }).then(response => {
          this.data = response.data.data
          this.totalItems = response.data.total_count
        })
          .catch(error => console.log(error))
      },
          
      loadCategories() {
        api.categoriesAPI.query({}).then(response => {
          this.categories = response.data.data
      })
        .catch(error => console.log(error))
      },

      postData(data){
        data.amount = parseFloat(data.amount)
        api.expensesAPI.post(data).catch(error => console.log(error))
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

      getColor (category) {
        const color = this.categories[category].color
        if (color)
          return color
        return 'green'

      },

      formatDate(date) {
        return new Date(date).toDateString()
      }
  },
  
  watch: {
    dialog: function(val){
      val || close()
    },

    priceRange: function(range) {
      this.loadItems()
    }
  }
}
</script>

<template>
  <v-row>
    <div style="width: 75%;">
      <v-data-table-server
        v-model:items-per-page="itemsPerPage"
        :headers="headers"
        :items-length="totalItems"
        :items="data"
        :loading="loading"
        :search="search"
        item-value="name"
        hide-default-footer
        @update:options="loadItems"
        class="elevation-1"
        style="border-radius: 8px;"
      >
      <template v-slot:top>
        <v-toolbar flat color="red">
          <v-toolbar-title>Expenses</v-toolbar-title>
          <v-divider
            class="mx-4"
            inset
            vertical
          ></v-divider>
          <v-spacer></v-spacer>
          <v-dialog
            v-model="dialog"
            max-width="500px"
          >
            <template v-slot:activator="{ props }">
              <v-btn
                color="primary"
                dark
                class="mb-2"
                v-bind="props"
              >
                New Expense
              </v-btn>
            </template>
            <v-card>
              <v-card-title>
                <span class="text-h5">{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="6"
                      md="4"
                    >
                      <v-text-field
                        v-model="editedItem.name"
                        label="Name"
                      ></v-text-field>
                    </v-col>
                    <v-col
                      cols="12"
                      sm="6"
                      md="4"
                    >
                      <v-text-field
                        v-model="editedItem.amount"
                        label="Amount"
                        type="number"
                        min="0"
                        ref="input"
                
                      ></v-text-field>
                    </v-col>
                    <v-col
                      cols="12"
                      sm="6"
                      md="4"
                    >
                      <v-text-field
                        v-model="editedItem.type"
                        label="Type"
                      ></v-text-field>
                    </v-col>
                    <v-col
                      cols="12"
                      sm="6"
                      md="4"
                    >
                      <v-text-field
                        v-model="editedItem.payment"
                        label="Payment"
                      ></v-text-field>
                    </v-col>
                    <v-col
                      cols="12"
                      sm="6"
                      md="4"
                    >
                      <v-text-field
                        v-model="editedItem.date"
                        label="Date"
                        type="datetime-local"
                      ></v-text-field>
                    </v-col>
                    <v-col
                      cols="12"
                      sm="6"
                      md="4"
                    >
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>

              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                  color="blue-darken-1"
                  variant="text"
                  @click="close"
                >
                  Cancel
                </v-btn>
                <v-btn
                  color="blue-darken-1"
                  variant="text"
                  @click="save"
                >
                  Save
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-toolbar>
      </template>
      <template v-slot:item.payment="{ value }">
        <v-chip :color="getColor(value)">
          {{ value }}
        </v-chip>
      </template>
      <template v-slot:item.date="{ value }">
          {{ formatDate(value) }}
      </template>
    </v-data-table-server>
  </div>
  <div style="width: 25%;">
    <v-col>
      <h2>Filters</h2>
      <v-range-slider
        v-model="priceRange"
        :max="2000"
        :min="0"
        :step="1"
        hide-details
        class="align-center"
      >
      <template v-slot:prepend>
      <v-text-field
        v-model="priceRange[0]"
        hide-details
        single-line
        type="number"
        variant="outlined"
        density="compact"
        style="width: 70px"
      ></v-text-field>
    </template>
    <template v-slot:append>
      <v-text-field
        v-model="priceRange[1]"
        hide-details
        single-line
        type="number"
        variant="outlined"
        style="width: 70px"
        density="compact"
      ></v-text-field>
    </template>
  </v-range-slider>
    </v-col>
  </div>
  </v-row>
</template>