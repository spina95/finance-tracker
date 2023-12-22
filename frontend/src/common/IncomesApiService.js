import ModelApiService from './ModelApiService'

export default class IncomesApiService extends ModelApiService {
    constructor() {
      super("data/incomes");
    }
  }