import axios from "axios";

export default axios.create({
    baseURL: import.meta.env.VITE_APP_BASE_URL || 'https://finance-tracker-567ntiy4ya-ew.a.run.app',
    timeout: 30000,
    headers: {
      //'Accept': 'application/vnd.GitHub.v3+json',
      //'Authorization': 'token <your-token-here> -- https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token'
    }
  });