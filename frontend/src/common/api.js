import ExpensesApiService from './ExpensesApiService'
import IncomesApiService from './IncomesApiService';
import ProductsApiService from './ProductsApiService'

export default {
    expensesAPI: new ExpensesApiService(),
    incomesAPI: new IncomesApiService(),
    productsAPI: new ProductsApiService(),
  };