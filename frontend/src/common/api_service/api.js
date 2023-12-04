import ExpensesApiService from './services/ExpensesApiService'
import CategoriesApiService from './services/CategoriesApiService';

export default {
    expensesAPI: new ExpensesApiService(),
    categoriesAPI: new CategoriesApiService()
  };