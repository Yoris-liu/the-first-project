<template>
<!-- 外层全屏居中 -->
<div class="login-container">
    <div class="login-box">
      <h2 class="login-title">系统登录</h2>   
  <el-form ref="loginFormRef" :model="formData"  :rules="loginRules" label-width="80px" label-position="left">
      <el-form-item label="用户名" prop="username">
        <el-input v-model="formData.username"  placeholder="请输入用户名" />
      </el-form-item>
      <el-form-item label="密  码" prop="password">
        <el-input v-model="formData.password" placeholder="请输入密码" show-password />
      </el-form-item>
      <el-form-item class="btn-box">
        <el-button type="primary" @click="onSubmit" class="login-btn">登录</el-button>
        <el-button @click="onReset">取消</el-button>
     </el-form-item>
  </el-form>
</div>
</div> 
</template>
<script setup>
import { onMounted, ref } from 'vue'     //引入vue

const loginFormRef = ref(null)
import request from '@/utils/request.js'  //引入请求基地址
import { ElMessage, ElMessageBox } from 'element-plus'
import router from '@/router'
const formData = ref({    //创建typeData
    username: '',
    password: ''
})
//点击对话框中的“取消”按钮清空内存数据
const clear = () => {
  formData.value = {
    username: '',
    password: ''
  }
}
//添加或修改保存数据
const onSubmit = async () => {      
    const res = await request.post('/users/login', formData.value)
    if (res.code === 200) {
      ElMessage({type: 'success',message: '登录成功'})
      console.log(res.data)
      localStorage.setItem("token",res.data) //保存token
      localStorage.setItem("userName", formData.value.username) //保存用户名
      router.push("/shop")
     }else{
      ElMessage({type:'info',message:'用户名或密码错误'})
     } 
    // formData.value = {
    //     uname: '',
    //     upass: ''        
    // }      
    
}
// 表单校验规则
const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}
// 取消/重置
const onReset = () => {
  loginFormRef.value?.resetFields()
}
//声明钩子函数
onMounted(() => {     
    
})
</script>
<style>
@media (min-width: 1024px) {
  .about {
    min-height: 100vh;
    display: flex;
    align-items: center;
  }
}/* 全屏居中 */
.login-container {
  width: 100vw;
  height: 100vh;
  background-color: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
}
/* 登录卡片 */
.login-box {
  width: 420px;
  padding: 40px 30px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}
/* 标题 */
.login-title {
  text-align: center;
  margin: 0 0 30px;
  font-size: 24px;
  color: #333;
}
/* 按钮居中 */
.btn-box {
  text-align: center;
  margin-top: 10px;
}
/* 登录按钮加宽 */
.login-btn {
  width: 100px;
}

</style>
