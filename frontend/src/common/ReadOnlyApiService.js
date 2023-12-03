import BaseApiService from './BaseApiService'

export default class ReadOnlyApiService extends BaseApiService {
    constructor(resource) {
      super(resource);
    }
    async fetch(config = {}) {
      try {
        const response = await fetch(this.getUrl(), config);
        return await response.json();
      } catch (err) {
        this.handleErrors(err);
      }
    }
    async get(id) {
      try {
        if (!id) throw Error("Id is not provided");
        const response = await fetch(this.getUrl(id));
        return await response.json();
      } catch (err) {
        this.handleErrors(err);
      }
    }
  }