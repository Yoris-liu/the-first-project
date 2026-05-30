<template>
<div align="center">
    <el-button type="primary" @click="deleteSelected()">删除</el-button>
    <el-button type="primary" @click="showDialog('add','')">新增</el-button>
    <el-input v-model="searchData.eno"  placeholder="请输入工号" style="width: 120px;margin-left: 25px;margin-right: 25px"/>
    <el-input v-model="searchData.ename"  placeholder="请输入姓名" style="width: 120px;margin-left: 25px;margin-right: 25px"/>
    <el-button type="primary" @click="getList"  style="width: 80px;margin-left: 25px;margin-right: 25px">搜索</el-button>
    <el-button type="primary" @click="clearData"  style="width: 80px;margin-left: 25px;margin-right: 25px">重置</el-button>
    <el-table :data="list" :row-class-name="tableRowClassName" style="width: 100%" @selection-change="handleSelectionChange" >
        <el-table-column align="center" type="selection" width="55" />
        <el-table-column align="center" prop="eno" label="工号" width="80" />
        <el-table-column align="center" prop="ename" label="姓名" width="120" />
        <el-table-column align="center" prop="sex" label="性别" width="80" />
        <el-table-column align="center" prop="birthday" label="出生日期" width="120" />
        <el-table-column align="center" prop="createDate" label="创建日期" width="100" />
        <el-table-column align="center" label="操作" width="150">
            <template v-slot="{ row }">
                <el-button type="primary" link @click="delRow(row.eno)">删除</el-button>
                <el-button type="primary" link @click="showDialog('edit',row.eno)">修改</el-button>
            </template>
        </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="typeTile" width="500" :before-close="handleClose" @close="clear()">
    <el-form :model="employeeData" label-width="120px" label-position="left">
      <el-form-item label="编号">
        <el-input v-model="employeeData.eno" />
      </el-form-item>
      <el-form-item label="姓名">
        <el-input v-model="employeeData.ename"  />
      </el-form-item>
      <el-form-item label="性别">
        <el-input v-model="employeeData.sex"  />
      </el-form-item>
      <el-form-item label="出生日期">
        <el-input v-model="employeeData.birthday"  />
      </el-form-item>
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="clear()">取消</el-button>
        <el-button type="primary" @click="submit()">确定</el-button>
      </div>
    </template>
</el-dialog>
</div>
</template>
<script setup>
import { onMounted, ref } from "vue"
import request from "@/utils/request.js"

const tableRowClassName = () => {}
const handleClose = () => { clear() }
const list = ref([])  //声明响应式数据
const  searchData = ref({    //searchData
    eno: '',
    ename: ''    
})
const selected = ref([])  //声明响应式数据
const employeeData = ref({  //声明响应式数据
    eno: '',
    ename: '',
    sex: '',
    birthday: ''
})
const dialogVisible=ref(false)//对话框默认不显示
const typeTile=ref()  //声明响应式变量 判断是新增还修改
//数据列表
const getList = async () => {                //定义请求异步请求函数
    // const res = await request.get('/teacher/list1')  //发送get请求
    const res = await request.post('/employee/list', searchData.value)    
    list.value = res.data    //给typeList对象赋值
}
//清空查询条件
const clearData = async () => {                //定义请求异步请求函数
    searchData.value = {
      eno: '',
      ename: ''
    }
}
//删除单条数据
const delRow=(id)=>{
    ElMessageBox.confirm('您确认要删除此数据吗？','警告！',{confirmButtonText:'确定',cancelButtonText:'取消',type:'warning'})
    .then(async()=>{
        const res=await request.delete(`/employee/delete/${id}`)
        if(res===200){
            ElMessage({type:'success',message:'删除成功'})
        }     
        await getList() 
    })
    .catch(()=>{ElMessage({type:'info',message:'取消删除'})})
}
// 批量删除数据---获取选择编号
const handleSelectionChange = (val) => {   
    selected.value = val
}
//批量删除数据
const deleteSelected = async () => {
        ElMessageBox.confirm('您确定要批量删除这些数据吗？',"警告！",{confirmButtonText:'确定',cancelButtonText:'取消',type:'warning'})
        .then(async()=>{
            const ids = selected.value.map(item => item.eno)           
            const res = await request.post('/employee/deleteBatch', ids)          
            if(res.data){
                ElMessage({type:'success', message:'删除成功！', })            
                await getList()//调用数据列表方法刷新前端页面
            }
        })
        .catch(() => {
        ElMessage({type: 'info',message: '取消删除'})
    })
}
//判断点击是“新增”还是“修改”按钮，如果是修改按钮，取到这一条数据的编号，
const showDialog =  (type, id) => {
      if (type == 'add') {
          typeTile.value = '新增'
      }else {
          typeTile.value = '修改'
          request({
              url: `/employee/findById/${id}`,  //调用后端接口findById方法,把返回的数据存放到表单对应的元素中显示
              method: 'GET',
          }).then(res => {
              teacherData.value = res.data
              console.log(res);
          })
      }
      dialogVisible.value = true
  }
//点击对话框中的“取消”按钮清空内存数据
const clear = () => {
  employeeData.value = {
    eno: '',
    ename: '',
    sex: '',
    birthday: ''
  }
   dialogVisible.value = false
}
//声明钩子函数
onMounted(() => {     
    getList()
})  
</script>
<style scoped>

</style>