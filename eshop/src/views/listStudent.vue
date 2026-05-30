<template>
<div align="center">
    <el-input v-model="searchData.sno"  placeholder="请输入学号" style="width: 120px;margin-left: 25px;margin-right: 25px"/>
    <el-input v-model="searchData.sname"  placeholder="请输入姓名" style="width: 120px;margin-left: 25px;margin-right: 25px"/>
    <el-button type="primary" @click="getList"  style="width: 80px;margin-left: 25px;margin-right: 25px">搜索</el-button>
    <el-button type="primary" @click="clearData"  style="width: 80px;margin-left: 25px;margin-right: 25px">重置</el-button>
    <el-table :data="list" :row-class-name="tableRowClassName"  style="width: 100%" @selection-change="handleSelectionChange" >
    <el-table-column align="center" type="selection" width="55" />
    <el-table-column align="center" prop="sno" label="学号" width="120" />
    <el-table-column align="center" prop="sname" label="姓名" width="100" />
    <el-table-column align="center" prop="sex" label="性别" width="80" />
    <el-table-column align="center" prop="birthday" label="出生日期" width="100" />
    <el-table-column align="center" prop="createDate" label="创建日期" width="100" />
    <el-table-column align="center" label="操作" width="150">
        <template v-slot="{ row }">
          <el-button type="primary" link @click="delRow(row.sno)">删除</el-button>
          <el-button type="primary" link @click="showDialog('edit',row.sno)">修改</el-button>
        </template>
    </el-table-column>
</el-table>
</div>
</template>
<script setup>
import { onMounted, ref } from "vue"
import request from "@/utils/request.js"

const tableRowClassName = () => {}
const handleClose = () => { clear() }
const list = ref([])  //声明响应式变量
const studentData = ref({    //创建typeData
    sno: '',
    sname: '',
    sex: '',
    birthday: '',
    createDate: ''
})
const  searchData = ref({    //searchData
    sno: '',
    sname: ''    
})
//数据列表
const getList = async () => {                //定义请求异步请求函数
    // const res = await request.get('/student/list1')  //发送get请求
    const res = await request.post('/student/list', searchData.value)    
    list.value = res.data    //给typeList对象赋值
    console.log("asda");
}
//清空查询条件
const clearData = async () => {                //定义请求异步请求函数
    searchData.value = {
      sno: '',
      sname: ''
    }
}
//声明钩子函数
onMounted(() => {     
    getList()
})
</script>
<style scoped>

</style>