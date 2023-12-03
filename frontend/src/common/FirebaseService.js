import ApiService from "./ApiService";

export const FirebaseService = {
    async getExpenses() {
      return ApiService.get("/expenses", null);
    },
    async postExpense(data) {
      return ApiService.post("/expenses/", data);
    },
};
