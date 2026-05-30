/**
 * 订单明细管理组件
 * 功能：
 * - 订单明细列表展示
 * - 订单明细新增
 * - 订单明细修改
 * - 订单明细删除（单个和批量）
 */

<template>
    <!-- 订单明细管理页面 -->
<div align="center">
  <!-- 操作按钮区域 -->
<el-button type="primary" @click="deleteSelected">删除</el-button>
<el-button type="primary" @click="showDialog('add','')">新增</el-button>
<el-input v-model="searchData.order_id" placeholder="请输入订单编号" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-input v-model="searchData.product_name" placeholder="请输入商品名称" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-button type="primary" @click="getOrderItemList" style="width: 80px;margin-left: 25px;margin-right: 25px">搜索</el-button>
<el-button type="primary" @click="clearData" style="width: 80px;margin-left: 25px;margin-right: 25px">重置</el-button>
<!-- 订单明细列表表格 -->
<el-table :data="orderItemList" :row-class-name="tableRowClassName"  style="width: 100%" @selection-change="handleSelectionChange" >
    <el-table-column align="center" type="selection" width="55" />
    <el-table-column align="center" prop="item_id" label="明细编号" width="100" />
    <el-table-column align="center" prop="order_id" label="订单编号" width="100" />
    <el-table-column align="center" prop="product_id" label="商品编号" width="100" />
    <el-table-column align="center" prop="product_name" label="商品名称" width="150" />
    <el-table-column align="center" prop="product_price" label="单价" width="100" />
    <el-table-column align="center" prop="buy_num" label="数量" width="80" />
    <el-table-column align="center" prop="create_time" label="创建时间" width="180" />

    <!-- 操作列 -->
    <el-table-column align="center" label="操作" width="180">
        <template v-slot="{ row }">
          <el-button type="primary" link @click="delRow(row.item_id)">删除</el-button>
          <el-button type="primary" link @click="showDialog('edit',row.item_id)">修改</el-button>
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
<!-- 订单明细编辑对话框 -->
<el-dialog v-model="dialogVisible" :title="typeTile"  width="500" :before-close="handleClose">
      <el-form :model="itemData" label-width="120px" label-position="left">
                <el-form-item label="订单编号">
                  <el-input v-model="itemData.order_id" placeholder="请输入订单编号"></el-input>
                </el-form-item>
                <el-form-item label="商品编号">
                  <el-input v-model="itemData.product_id" placeholder="请输入商品编号"></el-input>
                </el-form-item>
                <el-form-item label="商品名称">
                  <el-input v-model="itemData.product_name" placeholder="请输入商品名称"></el-input>
                </el-form-item>
                <el-form-item label="商品单价">
                  <el-input v-model="itemData.product_price" placeholder="请输入商品单价"></el-input>
                </el-form-item>
                <el-form-item label="购买数量">
                  <el-input v-model="itemData.buy_num" placeholder="请输入购买数量"></el-input>
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
const orderItemList = ref([])  //订单明细列表数据
const selected = ref([])  //选中的订单明细
const typeTile=ref()  //对话框标题
const dialogVisible=ref(false) //对话框显示状态

// 订单明细数据表单
const itemData = ref({
    item_id:"",         //明细编号
    order_id:"",        //订单编号
    product_id:"",      //商品编号
    product_name:"",    //商品名称
    product_price:"",   //商品单价
    buy_num:""          //购买数量
  })
const searchData = ref({
  order_id: '',
  product_name: ''
})
// 分页参数
const pageNum = ref(1)     // 当前页码
const pageSize = ref(5)    // 每页条数
const total = ref(0)       // 总记录数
// 初始化函数
const getOrderItemList = async () => {
    try {
    // 过滤空字符串，防止Long类型字段反序列化失败
    const params = {};
    Object.keys(searchData.value).forEach(key => {
        if (searchData.value[key] !== '') {
            params[key] = searchData.value[key];
        }
    });
    const res = await request({
      url: '/ordersItems/list',
      method: 'POST',
      data: params,
      params: {
        pageNum: pageNum.value,
        pageSize: pageSize.value
      }
    })
    if (res.code === 200) {
      orderItemList.value = res.data.list
      total.value = res.data.total
      console.log('获取订单明细数据成功:', res)
    } else {
      console.log('接口返回非200:', res)
    }
  } catch (err) {
    console.log('请求订单明细列表失败:', err)
  }
}
// 每页条数改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getOrderItemList()
}

// 当前页改变
const handleCurrentChange = (val) => {
  pageNum.value = val
  getOrderItemList()
}
//清空查询条件
const clearData = async () => {
    searchData.value = {
        order_id: '',
        product_name: ''
    }
}
// 删除单个订单明细
const delRow=(id)=>{
    ElMessageBox.confirm('您是否要删除此数据','Warning',{confirmButtonText:'确定',cancelButtonText:'取消',type:'warning'})
    .then(async()=>{
        try {
            const res=await request.delete(`/ordersItems/delete/${id}`)
            if(res.code === 200){
                ElMessage({type:'success',message:'删除成功'})
            }
            await getOrderItemList()
        } catch (error) {
            console.error('删除订单明细失败:', error);
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

// 批量删除订单明细
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
                const ids = selected.value.map(item => item.item_id)
                console.log(ids);
                const res = await request.post('/ordersItems/deleteBatch', ids)
                console.log(res);
                if(res.code === 200){
                    ElMessage({
                        type:'success',
                        message:'删除成功！',
                })
                await getOrderItemList()
            }
            } catch (error) {
                console.error('批量删除订单明细失败:', error);
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
         typeTile.value = '新增订单明细'
      } else {
         typeTile.value = '修改订单明细'
          request({
              url: '/ordersItems/findById',
              method: 'GET',
              params: {
                  id: gid
              }
          }).then(res => {
              itemData.value = res.data
              console.log(res);
          }).catch(error => {
              console.error('获取订单明细详情失败:', error);
              ElMessage({type:'error',message:'获取订单明细详情失败'})
          })
      }

      dialogVisible.value = true
  }

// 新增或修改数据
const submit = async () => {
      try {
          if (typeTile.value == '新增订单明细') {
              const { item_id, ...addData } = itemData.value
              const res = await request.post('/ordersItems/add', addData)
              if (res.code === 200) {
                  ElMessage({
                      type: 'success',
                      message: '新增成功'
                  })
              }
          } else {
              const res = await request.put('/ordersItems/update', itemData.value)
              if (res.code === 200) {
                  ElMessage({
                      type: 'success',
                      message: '修改成功'
                  })
              }
          }
          // 清空表单
          itemData.value = {
            item_id:"",
            order_id:"",
            product_id:"",
            product_name:"",
            product_price:"",
            buy_num:""
          };
          await getOrderItemList()
          dialogVisible.value = false
      } catch (error) {
          console.error('保存订单明细失败:', error);
          ElMessage({type:'error',message:'保存失败'})
      }
  }

// 点击对话框中的"取消"按钮清空内存数据
const clear = () => {
    itemData.value = {
    item_id:"",
    order_id:"",
    product_id:"",
    product_name:"",
    product_price:"",
    buy_num:""
  }
   dialogVisible.value = false
}

// 表格行样式
const tableRowClassName = () => {}

// 处理对话框关闭
const handleClose = () => {
    clear()
}

// 组件挂载时获取订单明细列表
onMounted(() => {
    getOrderItemList()
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
