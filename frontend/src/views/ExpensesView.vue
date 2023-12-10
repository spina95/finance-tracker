<script>
import axios from 'axios';
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
            sortable: true,
          },
          {
            key: 'paymentType',
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
        itemsPerPage: 25,
        totalItems: 30
    }
  },
    

  methods: {
    loadItems (val)  {
      var sortBy = "date"
      var order = "asc"
      if (val.sortBy[0]){
        sortBy = val.sortBy[0].key
        order = val.sortBy[0].order
      }
      api.expensesAPI.query({
        'order': 'name',
        'page': (val.page),
        'size': val.itemsPerPage,
        'sort-by': sortBy,
        'order': order
      }).then(response => {
        this.data = response.data.results
        this.totalItems = response.data.total_count
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
      <v-toolbar flat>
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
    <template v-slot:item.amount="{ value }">
        <div style="font-weight: bold;">{{ value }} €</div>
    </template>
    <template v-slot:item.category="{ value }">
      <v-chip :color="value.color">
        {{ value.name }}
      </v-chip>
    </template>
    <template v-slot:item.paymentType="{ value }">
      <v-chip :color="value.color">
        {{ value.name }}
      </v-chip>
    </template>
  </v-data-table-server>
  </div>
  
</template>