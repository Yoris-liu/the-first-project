import { createRouter, createWebHistory } from 'vue-router' //导入 VueRouter 核心方法：创建路由实例、创建历史模式
import {routes} from './routes.js' //导入路由规则配置文件（单独抽离的路由列表）
//创建路由实例
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL), //使用 history 路由模式（地址栏不带 #）
  routes // 挂载路由规则
})
//全局路由守卫：每次路由跳转前都会执行
router.beforeEach((to, from, next) => {  //to：要去的页面路由信息，from：从哪个页面来的路由信息，next：放行函数，必须调用
  //当访问登录页面时清除token
  if (to.path === '/login') {
    localStorage.removeItem('token') //清除本地存储中的 token（实现退出登录效果）
  }
  next() //放行，允许页面跳转
})

export default router //导出路由实例，供 main.js 挂载使用