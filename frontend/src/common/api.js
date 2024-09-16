import ExpensesApiService from './ExpensesApiService'
import IncomesApiService from './IncomesApiService';
import ProductsApiService from './ProductsApiService'
import NotesApiService from './NotesApiService';

export default {
    expensesAPI: new ExpensesApiService(),
    incomesAPI: new IncomesApiService(),
    productsAPI: new ProductsApiService(),
    notesAPI: new NotesApiService()
  };