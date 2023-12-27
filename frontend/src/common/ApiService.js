
const ApiService = {

  setHeader(token) {
    axios.defaults.headers = {
      'Authorization': `Token ${token}`
    }
  },

  query(resource, params) {
    return axios.get(resource, {params: params}).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  },

  get(resource) {
    return axios.get(`${resource}`).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  },

  post(resource, data) {
    return axios.post(`${resource}`, data=data);
  },

  update(resource, slug, params) {
    return axios.put(`${resource}/${slug}`, params);
  },

  put(resource, params) {
    return axios.put(`${resource}`, params);
  },

  delete(resource) {
    return axios.delete(resource).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  }
};

export default ApiService;