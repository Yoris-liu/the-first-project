<template>
    <!-- elmentui -->
<div align="center">
<el-button type="primary" @click="deleteSelected">删除</el-button> 
<el-button type="primary" @click="showDialog('add','')">新增</el-button> 
<el-table :data="shopList" :row-class-name="tableRowClassName"  style="width: 100%" @selection-change="handleSelectionChange" >
    <el-table-column align="center" type="selection" width="55" />
    <el-table-column align="center"  prop="id" label="店铺编号" width="80" />
    <el-table-column align="center" prop="shop_name" label="店铺名称" width="130" />
    <el-table-column align="center" prop="contact_phone" label="手机号" width="130" />
    <el-table-column align="center" prop="contact_email" label="邮箱" width="200" />
    <el-table-column align="center" prop="sale_count" label="销售数量" width="80" />
    <el-table-column align="center" prop="favorites_count" label="收藏数" width="80" />
    <el-table-column align="center" prop="shop_status" label="状态" width="80" />
    <el-table-column align="center" prop="create_time" label="创建日期" width="200" />
    <el-table-column align="center" label="操作" width="180">
        <template v-slot="{ row }">
          <el-button type="primary" link @click="delRow(row.id)">删除</el-button>
          <el-button type="primary" link @click="showDialog('edit',row.id)">修改</el-button>
        </template>
    </el-table-column>
</el-table>

<el-dialog v-model="dialogVisible" :title="typeTile" width="500" :before-close="handleClose" @close="clear()">
    <el-form :model="shopData" label-width="120px" label-position="left">
      <el-form-item label="店铺名称">
        <el-input v-model="shopData.shop_name"  />
      </el-form-item>
      <el-form-item label="联系电话">
        <el-input v-model="shopData.contact_phone"  />
      </el-form-item>
      <el-form-item label="邮箱">
        <el-input v-model="shopData.contact_email"  />
      </el-form-item>
      <el-form-item label="店铺地址">
        <el-input v-model="shopData.address"  />
      </el-form-item>
      <el-form-item label="店铺状态">
        <el-input v-model="shopData.shop_status"  />
      </el-form-item>
      <el-form-item label="创建日期">
        <el-date-picker v-model="shopData.create_time"  type="date" format="YYYY/MM/DD" value-format="YYYY-MM-DD" style="width: 100%"/>
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
import { onMounted, ref } from 'vue'     //引入vue
import request from '@/utils/request.js'  //引入请求基地址
import { ElMessage, ElMessageBox } from 'element-plus'//引入对话框
const shopList = ref([])  //声明响应式变量
const selected = ref([])  //声明响应式变量
const typeTile=ref()  //声明响应式变量
const dialogVisible=ref(false) //声明响应式变量
const shopData = ref({
    id:"",
    shop_name:"",
    contact_phone:"",
    contact_email:"",
    address:"",
    shop_status:"",
    create_time:""
  })

//数据列表
const getShopList = async () => {                //定义请求异步请求函数
    const res = await request.get('/shop/list')  //发送get请求    
    console.log(res);
    shopList.value = res.data    //给typeList对象赋值
}
//删除一条数据
const delRow=(id)=>{
    ElMessageBox.confirm('您是否要删除此数据','Warning',{confirmButtonText:'确定',cancelButtonText:'取消',type:'warning'})
    .then(async()=>{
        const res=await request.delete(`/shop/delete/${id}`)
        if(res.code===200){
            ElMessage({type:'success',message:'删除成功'})
        }
        await getShopList()
    })
    .catch(()=>{ElMessage({type:'info',message:'取消删除'})})
}

// 批量删除数据---获取选择编号
const handleSelectionChange = (val) => {
    console.log(val);
    selected.value = val
}
//批量删除数据
const deleteSelected = async () => {
        ElMessageBox.confirm(
            '您确定要批量删除这些数据吗？',
            "Warning",
            {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }
        ).then(async () => {
            const ids = selected.value.map(item => item.id)
            console.log(ids);
            const res = await request.post('/shop/deleteBatchShop', ids)
            //console.log(res);
            if(res.code===200){
                ElMessage({
                    type:'success',
                    message:'删除成功！',
            })            
            await getShopList()//调用数据列表方法刷新前端页面
        }
    })
    .catch(() => {
        ElMessage({
            type: 'info',
            message: 'Delete canceled'
        })
    })
}

//判断点击是"新增"还是"修改"按钮，如果是修改按钮，取到这一条数据的编号，
const showDialog =  (type, sid) => {
      if (type == 'add') {
          typeTile.value = '新增店铺'
      }else {
          typeTile.value = '修改店铺'
          request({
              url: '/shop/findShopById',  //调用后端接口findTypeById方法,把返回的数据存放到表单对应的元素中显示
              method: 'GET',
              params: {
                  id: sid
              }
          }).then(res => {
              shopData.value = res.data
              console.log(res);
          })
      }
      dialogVisible.value = true
  }

//点击对话框中的"取消"按钮清空内存数据
const clear = () => {
  shopData.value = {
    id:"",
    shop_name:"",
    contact_phone:"",
    contact_email:"",
    address:"",
    shop_status:"",
    create_time:""
  }
   dialogVisible.value = false
}
//添加或修改保存数据
const submit = async () => {
      //传过来值为新增 执行次代码块执行新增操作
      if (typeTile.value == '新增店铺') {
          const { id, ...addData } = shopData.value
          const res = await request.post('/shop/addShop', addData)
          if (res.code === 200) {
              ElMessage({
                  type: 'success',
                  message: '新增成功'
              })
          }
          shopData.value = {
            id:"",
            shop_name:"",
            contact_phone:"",
            contact_email:"",
            address:"",
            shop_status:"",
            create_time:""
          }
          }else {
          const res = await request.put('/shop/updateShop', shopData.value)
          if (res.code === 200) {
              ElMessage({
                  type: 'success',
                  message: '修改成功'
              })
          }
          shopData.value = {
            id:"",
            shop_name:"",
            contact_phone:"",
            contact_email:"",
            address:"",
            shop_status:"",
            create_time:""
          }
      }  
      await getShopList() 
      dialogVisible.value = false
}

// 表格行样式
const tableRowClassName = () => {}
// 对话框关闭前处理
const handleClose = () => {
    clear()
}

onMounted(() => {     //声明钩子函数
    getShopList()
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
</style>