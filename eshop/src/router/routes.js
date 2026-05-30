/**
 * 路由配置文件
 * 定义应用的所有路由路径和组件映射
 * 包含以下主要功能模块：
 * - 根路径重定向
 * - 首页模块
 * - 店铺管理模块
 * - 商品管理模块
 * - 数据可视化模块
 * - 登录页面
 */

// 路由配置数组
export const routes=[    
    /**
     * 根路径重定向
     * 当用户访问应用根路径时，自动重定向到登录页面
     * 确保用户首先进行身份验证
     */
    {
      path: '/',
      redirect: '/login',
      meta: { title: '重定向' }
    },    
    /**
     * 首页路由
     * 包含应用的主页面，展示店铺管理相关信息
     * 使用layout布局组件作为容器
     */
    {
      path: '/home',
      name: 'home',
      component: () => import('../layout/index.vue'),
      meta:{title:"首页",icon:"HomeFilled"},
      children:[
        /**
         * 首页子路由
         * 显示店铺管理的详细信息
         */
        {
            path: '/home',
            name: 'homeView',
            component: () => import('../views/HomeView.vue'),
            meta:{title:"店铺管理",icon:"ArrowRight"}
          },
    ]
    },
    
    /**
     * 店铺管理路由
     * 包含店铺相关的管理功能
     */
    {
      path: '/shopManager',
      name: 'shopManager',
      component: () => import('../layout/index.vue'),
      meta:{title:"店铺管理",icon:"Document"},
      children:[
        /**
         * 店铺信息子路由
         * 显示店铺列表，支持增删改查操作
         */
        {
            path: '/shop',
            name: 'shop',     
            component: () => import('../views/listShop.vue'),
            meta:{title:"店铺信息",icon:"ArrowRight"}
          }
        ]
    },    
    /**
     * 商品管理路由
     * 包含商品相关的管理功能
     */
    {
        path: '/productManager',
        name: 'productManager',     
        component: () => import('../layout/index.vue'),
        meta:{title:"商品管理",icon:"Document"},
        children:[
            /**
             * 商品类型子路由
             * 显示商品类型列表，支持分类管理
             */
            {
                path: '/category',
                name: 'category',     
                component: () => import('../views/listCategory.vue'),
                meta:{title:"商品类型",icon:"ArrowRight"}
              },              
              /**
               * 商品信息子路由
               * 显示商品列表，支持商品的增删改查操作
               */
              {
                path: '/product',
                name: 'product',     
                component: () => import('../views/listProduct.vue'),
                meta:{title:"商品信息",icon:"ArrowRight"}
              },              
              /**
               * 商品上传子路由
               */
              {
                path: '/upload',
                name: 'upload',     
                component: () => import('../views/listUpload.vue'),
                meta:{title:"商品上传",icon:"ArrowRight"}
              },
              /**
               * 商品上传子路由
               */
              {
                path: '/uploadBatch',
                name: 'uploadBatch',
                component: () => import('../views/listUploadBatch.vue'),
                meta:{title:"多文件上传",icon:"ArrowRight"}
              },
        ]
    },
    /**
     * 订单管理路由
     * 包含订单相关的管理功能
     */
    {
        path: '/orderManager',
        name: 'orderManager',
        component: () => import('../layout/index.vue'),
        meta:{title:"订单管理",icon:"Document"},
        children: [
            {
                path: '/orders',
                name: 'orders',
                component: () => import('../views/listOrders.vue'),
                meta:{title:"订单信息",icon:"ArrowRight"}
            },
            {
                path: '/orderItem',
                name: 'orderItem',
                component: () => import('../views/listOrderItem.vue'),
                meta:{title:"订单明细",icon:"ArrowRight"}
            }
        ]
    },
    /**
     * 店铺管理路由
     * 包含店铺相关的管理功能
     */
    {
      path: '/systemManager',
      name: 'systemManager',
      component: () => import('../layout/index.vue'),
      meta:{title:"用户管理",icon:"Document"},
      children:[
        /**
         * 店铺信息子路由
         * 显示店铺列表，支持增删改查操作
         */
        {
            path: '/users',
            name: 'users',
            component: () => import('../views/listUsers.vue'),
            meta:{title:"用户信息",icon:"ArrowRight"}
          },
          {
            path: '/roles',
            name: 'roles',
            component: () => import('../views/listRoles.vue'),
            meta:{title:"角色信息",icon:"ArrowRight"}
          },
          {
            path: '/log',
            name: 'log',
            component: () => import('../views/listLog.vue'),
            meta:{title:"日志信息",icon:"ArrowRight"}
          }
        ]
    },       
    /**
     * 数据可视化路由
     * 包含数据统计和图表展示功能
     */
    {
      path: '/dataViewManager',
      name: 'dataViewManager',     
      component: () => import('../layout/index.vue'),
      meta:{title:"数据可视化",icon:"Document"},
      children:[
            /**
             * 数据可视化子路由
             * 展示各种数据图表和统计信息
             */
            {
                path: '/dataView',
                name: 'dataView',     
                component: () => import('../views/shuju.vue'),
                meta:{title:"数据可视化",icon:"ArrowRight"}
              }    
        ]
    },    
    /**
     * 登录页面路由
     * 提供用户登录功能，验证用户身份
     * 访问此页面时会自动清除之前的token
     */
    {
      path: '/login',
      name: 'login',     
      component: () => import('../views/login.vue'),
      meta:{title:"退出"}
    },    
  ]