<template>
    <!-- elmentui -->
<div  class="box">
      <el-col :span="5" v-for="item in goodsList" :key="item.gid" :offset="1">
        <el-card :body-style="{ padding: '0px' }" shadow="hover">
          <router-link :to="'/video?video=' + item.gid">
          <img :src="'http://127.0.0.1:90/eshop/images/'+item.pic" width="80" height="80">
          <p style="">{{ item.gname }}</p>
          </router-link>
        </el-card>
      </el-col> 
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'     //引入vue
import request from '@/utils/request.js'  //引入请求基地址
import { ElMessage, ElMessageBox  } from 'element-plus'//引入对话框
const goodsList = ref([])  //声明响应式变量
//数据列表
const getGoodsList = async () => {                //定义请求异步请求函数
    const res = await request.get('/goods/listGoods')  //发送get请求    
    console.log(res);
    goodsList.value = res.data    //给typeList对象赋值
}

//声明钩子函数
onMounted(() => {     
    getGoodsList()
})
</script>
<style>
@media (min-width: 1024px) {
  .about {
    min-height: 100vh;
    display: flex;
    align-items: center;
  }
  
}
.box{
    margin-right: 4%;
    display: flex;
    flex-wrap:wrap;
    
  }
  .el-card__body{
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
  }
.el-col{
    margin-top: 20px;
}
</style>