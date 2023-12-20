import ExpensesApiService from './ExpensesApiService'
import IncomesApiService from './IncomesApiService';

export default {
    expensesAPI: new ExpensesApiService(),
    incomesAPI: new IncomesApiService(),
  };