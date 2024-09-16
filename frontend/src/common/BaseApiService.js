import axios from 'axios';

export default class BaseApiService {
    baseUrl = import.meta.env.VITE_APP_BASE_URL || 'https://finance-tracker-567ntiy4ya-ew.a.run.app';
    resource;

    constructor(resource) {
      if (!resource) throw new Error("Resource is not provided");
      this.resource = resource;
      axios.defaults.baseURL = import.meta.env.VITE_APP_BASE_URL || 'https://finance-tracker-567ntiy4ya-ew.a.run.app';
      axios.defaults.headers = {
        'Content-Type': 'application/json',
    }
    }
  
    getUrl(id) {
      if (id) return `${this.baseUrl}/${this.resource}/${id}/`;
      return `${this.baseUrl}/${this.resource}/`;
    }
  
    handleErrors(err) {
      // Note: here you may want to add your errors handling
      console.log({ message: "Errors is handled here", err });
    }
  }