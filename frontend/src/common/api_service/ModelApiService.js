import axios from 'axios';
import ReadOnlyApiService from './ReadOnlyApiService'

export default class ModelApiService extends ReadOnlyApiService {
    constructor(resource) {
      super(resource);
    }

    async query(params) {
        return axios.get(this.getUrl(), {params: params}).catch(error => {
            throw new Error(`[RWV] ApiService ${error}`);
        });
    }

    async get() {
        return axios.get(this.getUrl()).catch(error => {
            throw new Error(`[RWV] ApiService ${error}`);
        });
    }

    async post(data) {
        return axios.post(this.getUrl(), data=data);
    }

    async update(id, params) {
        return axios.put(this.getUrl(id), params);
    }

    async put(params) {
        return axios.put(this.getUrl(), params);
    }

    async delete(resource) {
        return axios.delete(resource).catch(error => {
            throw new Error(`[RWV] ApiService ${error}`);
        });
    }
  }