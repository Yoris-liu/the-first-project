/**
 * 订单管理组件
 * 功能：
 * - 订单列表展示
 * - 订单新增
 * - 订单修改
 * - 订单删除（单个和批量）
 */

<template>
    <!-- 订单管理页面 -->
<div align="center">
  <!-- 操作按钮区域 -->
<el-button type="primary" @click="deleteSelected">删除</el-button>
<el-button type="primary" @click="showDialog('add','')">新增</el-button>
<el-input v-model="searchData.order_no" placeholder="请输入订单号" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-input v-model="searchData.receiver_name" placeholder="请输入收件人" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-input v-model="searchData.receiver_phone" placeholder="请输入联系电话" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-button type="primary" @click="getOrderList" style="width: 80px;margin-left: 25px;margin-right: 25px">搜索</el-button>
<el-button type="primary" @click="clearData" style="width: 80px;margin-left: 25px;margin-right: 25px">重置</el-button>
<!-- 订单列表表格 -->
<el-table :data="orderList" :row-class-name="tableRowClassName"  style="width: 100%" @selection-change="handleSelectionChange" >
    <el-table-column align="center" type="selection" width="55" />
    <el-table-column align="center" prop="order_no" label="订单号" width="150" />
    <el-table-column align="center" prop="receiver_name" label="收件人" width="100" />
    <el-table-column align="center" prop="receiver_phone" label="联系电话" width="120" />
    <el-table-column align="center" prop="receiver_address" label="收货地址" width="200" />
    <el-table-column align="center" prop="total_price" label="总金额" width="100" />
    <el-table-column align="center" prop="pay_price" label="实付金额" width="100" />
    <el-table-column align="center" prop="order_status" label="订单状态" width="100" />
    <el-table-column align="center" prop="pay_type" label="支付方式" width="100" />
    <el-table-column align="center" prop="create_time" label="下单时间" width="180" />

    <!-- 操作列 -->
    <el-table-column align="center" label="操作" width="180">
        <template v-slot="{ row }">
          <el-button type="primary" link @click="delRow(row.order_id)">删除</el-button>
          <el-button type="primary" link @click="showDialog('edit',row.order_id)">修改</el-button>
        </template>
    </el-table-column>
</el-table>
<!-- 分页组件 -->
<div class="pagination-box">
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[5,10,15,20]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
</div>
<!-- 订单编辑对话框 -->
<el-dialog v-model="dialogVisible" :title="typeTile"  width="500" :before-close="handleClose">
      <el-form :model="orderData" label-width="120px" label-position="left">
                <el-form-item label="订单号">
                  <el-input v-model="orderData.order_no" placeholder="请输入订单号"></el-input>
                </el-form-item>
                <el-form-item label="用户ID">
                  <el-input v-model="orderData.user_id" placeholder="请输入用户ID"></el-input>
                </el-form-item>
                <el-form-item label="店铺ID">
                  <el-input v-model="orderData.shop_id" placeholder="请输入店铺ID"></el-input>
                </el-form-item>
                <el-form-item label="订单状态">
                  <el-input v-model="orderData.order_status" placeholder="请输入订单状态"></el-input>
                </el-form-item>
                <el-form-item label="支付方式">
                  <el-input v-model="orderData.pay_type" placeholder="请输入支付方式"></el-input>
                </el-form-item>
                <el-form-item label="总金额">
                  <el-input v-model="orderData.total_price" placeholder="请输入总金额"></el-input>
                </el-form-item>
                <el-form-item label="实付金额">
                  <el-input v-model="orderData.pay_price" placeholder="请输入实付金额"></el-input>
                </el-form-item>
                <el-form-item label="收件人">
                  <el-input v-model="orderData.receiver_name" placeholder="请输入收件人"></el-input>
                </el-form-item>
                <el-form-item label="联系电话">
                  <el-input v-model="orderData.receiver_phone" placeholder="请输入联系电话"></el-input>
                </el-form-item>
                <el-form-item label="收货地址">
                  <el-input v-model="orderData.receiver_address" placeholder="请输入收货地址"></el-input>
                </el-form-item>
                <el-form-item label="付款时间">
                  <el-input v-model="orderData.pay_time" placeholder="请输入付款时间"></el-input>
                </el-form-item>
                <el-form-item label="发货时间">
                  <el-input v-model="orderData.delivery_time" placeholder="请输入发货时间"></el-input>
                </el-form-item>
                <el-form-item label="收货时间">
                  <el-input v-model="orderData.receive_time" placeholder="请输入收货时间"></el-input>
                </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false; clear()">取消</el-button>
          <el-button type="primary" @click="submit()">
            确定
          </el-button>
        </div>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
// 导入Vue相关依赖
import { onMounted, ref } from 'vue'     //引入vue
// 导入请求工具
import request from '@/utils/request.js'  //引入请求基地址
// 导入Element Plus组件
import { ElMessage, ElMessageBox  } from 'element-plus'//引入对话框

// 响应式数据定义
const orderList = ref([])  //订单列表数据
const selected = ref([])  //选中的订单
const typeTile=ref()  //对话框标题
const dialogVisible=ref(false) //对话框显示状态

// 订单数据表单
const orderData = ref({
    order_id:"",        //订单编号
    order_no:"",        //订单号
    user_id:"",         //用户ID
    shop_id:"",         //店铺ID
    order_status:"",    //订单状态
    pay_type:"",        //支付方式
    total_price:"",     //总金额
    pay_price:"",       //实付金额
    receiver_name:"",   //收件人
    receiver_phone:"",  //联系电话
    receiver_address:"",//收货地址
    pay_time:"",        //付款时间
    delivery_time:"",   //发货时间
    receive_time:""     //收货时间
  })
const searchData = ref({
  order_no: '',
  receiver_name: '',
  receiver_phone: ''
})
// 分页参数
const pageNum = ref(1)     // 当前页码
const pageSize = ref(5)    // 每页条数
const total = ref(0)       // 总记录数
// 初始化函数
const getOrderList = async () => {
    try {
    const res = await request({
      url: '/orders/list',
      method: 'POST',
      data: searchData.value,
      params: {
        pageNum: pageNum.value,
        pageSize: pageSize.value
      }
    })
    if (res.code === 200) {
      orderList.value = res.data.list
      total.value = res.data.total
      console.log('获取订单数据成功:', res)
    } else {
      console.log('接口返回非200:', res)
    }
  } catch (err) {
    console.log('请求订单列表失败:', err)
  }
}
// 每页条数改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getOrderList()
}

// 当前页改变
const handleCurrentChange = (val) => {
  pageNum.value = val
  getOrderList()
}
//清空查询条件
const clearData = async () => {
    searchData.value = {
        order_no: '',
        receiver_name: '',
        receiver_phone: ''
    }
}
// 删除单个订单
const delRow=(id)=>{
    ElMessageBox.confirm('您是否要删除此数据','Warning',{confirmButtonText:'确定',cancelButtonText:'取消',type:'warning'})
    .then(async()=>{
        try {
            const res=await request.delete(`/orders/delete/${id}`)
            if(res.code === 200){
                ElMessage({type:'success',message:'删除成功'})
            }
            await getOrderList()
        } catch (error) {
            console.error('删除订单失败:', error);
            ElMessage({type:'error',message:'删除失败'})
        }
    })
    .catch(()=>{ElMessage({type:'info',message:'取消删除'})})
}

// 批量删除数据---获取选择编号
const handleSelectionChange = (val) => {
    console.log(val);
    selected.value = val
}

// 批量删除订单
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
            try {
                const ids = selected.value.map(item => item.order_id)
                console.log(ids);
                const res = await request.post('/orders/deleteBatch', ids)
                console.log(res);
                if(res.code === 200){
                    ElMessage({
                        type:'success',
                        message:'删除成功！',
                })
                await getOrderList()
            }
            } catch (error) {
                console.error('批量删除订单失败:', error);
                ElMessage({type:'error',message:'批量删除失败'})
            }
    })
    .catch(() => {
        ElMessage({
            type: 'info',
            message: 'Delete canceled'
        })
    })
}

// 判断是新增还是修改操作
const showDialog =  (goods, gid) => {
      if (goods == 'add') {
         typeTile.value = '新增订单'
      } else {
         typeTile.value = '修改订单'
          request({
              url: '/orders/findById',
              method: 'GET',
              params: {
                  id: gid
              }
          }).then(res => {
              orderData.value = res.data
              console.log(res);
          }).catch(error => {
              console.error('获取订单详情失败:', error);
              ElMessage({type:'error',message:'获取订单详情失败'})
          })
      }

      dialogVisible.value = true
  }

// 新增或修改数据
const submit = async () => {
      try {
          if (typeTile.value == '新增订单') {
              const { order_id, ...addData } = orderData.value
              const res = await request.post('/orders/add', addData)
              if (res.code === 200) {
                  ElMessage({
                      type: 'success',
                      message: '新增成功'
                  })
              }
          } else {
              const res = await request.put('/orders/update', orderData.value)
              if (res.code === 200) {
                  ElMessage({
                      type: 'success',
                      message: '修改成功'
                  })
              }
          }
          // 清空表单
          orderData.value = {
            order_id:"",
            order_no:"",
            user_id:"",
            shop_id:"",
            order_status:"",
            pay_type:"",
            total_price:"",
            pay_price:"",
            receiver_name:"",
            receiver_phone:"",
            receiver_address:"",
            pay_time:"",
            delivery_time:"",
            receive_time:""
          };
          await getOrderList()
          dialogVisible.value = false
      } catch (error) {
          console.error('保存订单失败:', error);
          ElMessage({type:'error',message:'保存失败'})
      }
  }

// 点击对话框中的"取消"按钮清空内存数据
const clear = () => {
    orderData.value = {
    order_id:"",
    order_no:"",
    user_id:"",
    shop_id:"",
    order_status:"",
    pay_type:"",
    total_price:"",
    pay_price:"",
    receiver_name:"",
    receiver_phone:"",
    receiver_address:"",
    pay_time:"",
    delivery_time:"",
    receive_time:""
  }
   dialogVisible.value = false
}

// 表格行样式
const tableRowClassName = () => {}

// 处理对话框关闭
const handleClose = () => {
    clear()
}

// 组件挂载时获取订单列表
onMounted(() => {
    getOrderList()
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
.pagination-box{
  margin-top:20px;
  display: flex;
  justify-content: center;
}
</style>
