import ModelApiService from './ModelApiService'

export default class NotesApiService extends ModelApiService {
    constructor() {
      super("personal/notes");
    }
  }