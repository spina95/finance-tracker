import axios from 'axios';

export default class BaseApiService {
    baseUrl = "http://127.0.0.1:8000/api/v1";
    resource;

    constructor(resource) {
      if (!resource) throw new Error("Resource is not provided");
      this.resource = resource;
      axios.defaults.baseURL = "http://127.0.0.1:8000/api/v1";
      axios.defaults.headers = {
        'Content-Type': 'application/json',
    }
    }
  
    getUrl(id = "") {
      return `${this.baseUrl}/${this.resource}/${id}`;
    }
  
    handleErrors(err) {
      // Note: here you may want to add your errors handling
      console.log({ message: "Errors is handled here", err });
    }
  }