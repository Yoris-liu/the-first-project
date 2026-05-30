/**
 * 布局组件
 * 应用的主布局结构，包含以下部分：
 * - 顶部导航栏
 * - 左侧菜单
 * - 主内容区域
 * - 底部版权信息
 */
<template>
  <div>
    <!-- 整体布局容器 -->
    <el-container  class="common-layout">      
      <!-- 顶部导航栏 -->
      <el-header class="header">
        <div class="header-left">
          <div class="header-title">网上商城后台管理</div>
        </div>
        <div class="header-right">
          <div class="user-info" v-if="userName">
            <el-icon><User /></el-icon>
            <span>{{ userName }}</span>
          </div>
        </div>
      </el-header>
      <!-- 主体内容区域 -->
      <el-container>          
        <!-- 左侧菜单 -->
        <el-aside height="100%" width="200px">
          <!-- 菜单组件，设置为占满高度，背景色和文本颜色，默认激活首页 -->
          <el-menu style="height:100%;align-items: center;" background-color="#eff7fd" text-color="#178fe9" default-active="/home" router >
            <!-- 遍历路由配置，生成菜单项 -->
            <template v-for="(item, index) in router" :key="index">
              <!-- 无子路由的菜单项 -->
              <template v-if="!item.children && item.meta">
                <el-menu-item :index="item.path">
                  <!-- 菜单图标，使用动态组件加载 -->
                  <el-icon v-if="item.meta && item.meta.icon"><component :is="item.meta.icon" /></el-icon>
                  <!-- 菜单项标题 -->
                  <template #title>{{ item.meta.title }}</template>
                </el-menu-item>
             </template>
              
              <!-- 只有一个子路由的菜单项，直接显示子路由 -->
              <template v-if="item.children?.length == 1 && item.meta">
                <el-menu-item :index="item.children[0].path" v-if="!item.meta.hidden">
                  <!-- 菜单图标，使用动态组件加载 -->
                  <el-icon v-if="item.meta && item.meta.icon"><component :is="item.meta.icon" /></el-icon>
                  <!-- 菜单项标题 -->
                  <template #title>{{ item.meta.title }}</template>
                </el-menu-item>
              </template>
              
              <!-- 有多个子路由的菜单项，显示为下拉菜单 -->
              <el-sub-menu :index="item.path" v-if="item.children?.length>1 && item.meta">
                  <!-- 下拉菜单标题 -->
                  <template #title>
                      <!-- 菜单图标，使用动态组件加载 -->
                      <el-icon v-if="item.meta && item.meta.icon">
                          <component :is="item.meta.icon" />
                      </el-icon>
                      <!-- 菜单项标题 -->
                      {{ item.meta.title }}
                  </template>
                  <!-- <Menu :routes="item.children"></Menu> -->
                  
                  <!-- 遍历子路由，生成下拉菜单项 -->
                  <template v-for="(subItem, subIndex) in item.children" :key="subIndex">
                    <!-- 无子路由的子菜单项 -->
                    <template v-if="!subItem.children && subItem.meta">
                        <el-menu-item :index="subItem.path">
                            <el-icon v-if="subItem.meta && subItem.meta.icon">
                                <component :is="subItem.meta.icon" />
                            </el-icon>
                            <template #title>
                                {{ subItem.meta.title }}
                            </template>
                        </el-menu-item>
                    </template>

                    <!-- 只有一个子路由的子菜单项 -->
                    <template v-if="subItem.children?.length == 1 && subItem.meta">
                        <el-menu-item :index="subItem.children[0].path" v-if="!subItem.meta.hidden">
                            <el-icon v-if="subItem.meta && subItem.meta.icon">
                                <component :is="subItem.meta.icon" />
                            </el-icon>
                            <template #title>
                                {{ subItem.meta.title }}
                            </template>
                        </el-menu-item>
                    </template>

                    <!-- 有多个子路由的菜单项，显示为二级下拉菜单 -->
                    <template v-if="subItem.children?.length > 1 && subItem.meta">
                        <el-sub-menu :index="subItem.path">
                            <template #title>
                                <el-icon v-if="subItem.meta && subItem.meta.icon">
                                    <component :is="subItem.meta.icon" />
                                </el-icon>
                                {{ subItem.meta.title }}
                            </template>
                            <template v-for="(grandItem, grandIndex) in subItem.children" :key="grandIndex">
                                <el-menu-item :index="grandItem.path">
                                    <el-icon v-if="grandItem.meta && grandItem.meta.icon">
                                        <component :is="grandItem.meta.icon" />
                                    </el-icon>
                                    <template #title>{{ grandItem.meta.title }}</template>
                                </el-menu-item>
                            </template>
                        </el-sub-menu>
                    </template>
                  </template>
              </el-sub-menu>
          </template>
          </el-menu>
        </el-aside>
        
        <!-- 右侧内容区域 -->
        <el-container>
          <!-- 主内容区域，用于显示路由组件 -->
          <el-main class="main">
            <RouterView/>
          </el-main>
          <!-- 底部版权信息 -->
          <!-- <el-footer class="footer">
            <div class="footer-content">
              <div class="footer-text">© 2026 网上商城后台管理系统</div>
              <div class="footer-version">版本 1.0.0</div>
            </div>
          </el-footer> -->
        </el-container>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
    // 导入路由配置
    import {routes} from '@/router/routes.js'
    // 导入Vue的reactive、ref和onMounted函数
    import { reactive, ref, onMounted } from 'vue'
    // 导入User图标
    import { User } from '@element-plus/icons-vue'
    
    // 将路由配置转换为响应式对象，用于模板中遍历
    const router = reactive(routes)
    // 打印路由配置，用于调试
    console.log(router);
    
    // 用户名响应式变量
    const userName = ref('')
    
    // 组件挂载时获取用户名
    onMounted(() => {
      // 从localStorage获取用户名
      const storedUser = localStorage.getItem('userName')
      if (storedUser) {
        userName.value = storedUser
      }
    })
</script>

<style scoped>
/* 整体布局样式 */
.common-layout{
  height: 100vh; /* 设置布局高度为视口高度 */
}

/* 顶部导航栏样式 */
.header {
  /* position: fixed;
  top: 0;
  left: 10;
  width: calc(100%-$base-menu-width);
  height:$base-header-height; */
  background-color:#2eaef7; /* 设置导航栏背景色 */
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px; /* 设置左右内边距 */
  height: 60px; /* 设置导航栏高度 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 添加底部阴影，增强层次感 */
}

/* 顶部导航栏左侧区域 */
.header-left {
  display: flex;
  align-items: center;
}

/* 顶部导航栏标题样式 */
.header-title {
  font-size: 20px; /* 设置字体大小 */
  font-weight: bold; /* 设置字体粗细 */
  color: white; /* 设置字体颜色 */
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 添加文字阴影效果 */
  letter-spacing: 2px; /* 设置字间距 */
}

/* 顶部导航栏右侧区域 */
.header-right {
  display: flex;
  align-items: center;
}

/* 用户信息样式 */
.user-info {
  display: flex;
  align-items: center;
  color: white; /* 设置字体颜色 */
  font-size: 14px; /* 设置字体大小 */
  gap: 8px; /* 设置图标和文字的间距 */
  padding: 6px 12px; /* 设置内边距 */
  background-color: rgba(255, 255, 255, 0.1); /* 设置背景色，带透明度 */
  border-radius: 20px; /* 设置圆角 */
  cursor: pointer; /* 设置鼠标指针 */
  transition: background-color 0.3s ease; /* 添加过渡效果 */
}

/* 用户信息悬停效果 */
.user-info:hover {
  background-color: rgba(255, 255, 255, 0.2); /* 悬停时改变背景色 */
}

/* 主内容区域样式 */
.main{
  /* position: fixed;
  left:10; */
  /* top:$base-menu-width;
  left:$base-menu-width;
  width: calc(100%-$base-menu-width);
  height: calc(100%-$base-menu-height);
  padding:20px; 
  overflow:auto; */
}

/* 底部版权信息样式 */
.footer{
  background-color: #eff7fd; /* 设置底部背景色，与左侧导航背景颜色一致 */
  display: flex;
  align-items: center;
  justify-content: center;
  height: 50px; /* 设置底部高度 */
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1); /* 添加顶部阴影，增强层次感 */
}

/* 底部内容容器 */
.footer-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}

/* 底部文字样式 */
.footer-text {
  font-size: 14px; /* 设置字体大小 */
  color: #178fe9; /* 设置字体颜色，与左侧导航文字颜色一致 */
  margin-bottom: 4px; /* 设置底部间距 */
  letter-spacing: 1px; /* 设置字间距 */
}

/* 版本信息样式 */
.footer-version {
  font-size: 12px; /* 设置字体大小 */
  color: #178fe9; /* 设置字体颜色，与左侧导航文字颜色一致 */
  opacity: 0.8; /* 设置透明度 */
}

/* 响应式样式，当屏幕宽度大于等于1024px时应用 */
@media (min-width: 1024px) {
  .greetings h1,
  .greetings h3 {
    text-align: left;
  }
}
</style>