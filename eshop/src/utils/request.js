import axios from 'axios'        //导入axios
const request = axios.create({      // 实例化请求对象
  // TODO 1. 基础地址，超时时间
  baseURL: 'http://127.0.0.1:90/eshop2403'  //192.168.77.7
})
request.interceptors.request.use(
  (config) => {
    // TODO 2. 携带token
    config.headers.token=localStorage.getItem("token") //取token
    return config
  },
  (err) => Promise.reject(err)
)
request.interceptors.response.use(
  (res) => {
    // TODO 3. 处理业务失败
    // TODO 4. 摘取核心响应数据
    return res.data
  },
  (err) => {
    // TODO 5. 处理401错误
    return Promise.reject(err)
  }
)
export default request