// import './assets/main.css'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'    // 导入element-plus
import 'element-plus/dist/index.css'    // 导入css文件
import zhCn from 'element-plus/es/locale/lang/zh-cn'// 引入中文语言包
import * as ElementPlusIconsVue from '@element-plus/icons-vue' // 导入
// import Echarts from "vue-echarts"
// import * as echarts from "echarts"
const app = createApp(App)
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
}
app.use(router)
// app.use(ElementPlus)      // 将ElementPlus加载到vue实例中
// app.component("v-chart", Echarts) 
// app.config.globalProperties.$echarts = echarts
// 全局挂载中文
app.use(ElementPlus, {
    locale: zhCn
  })
app.mount('#app')
