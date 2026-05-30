/**
 * 商品管理组件
 * 功能：
 * - 商品列表展示
 * - 商品新增
 * - 商品修改
 * - 商品删除（单个和批量）
 * - 商品图片上传和下载
 */

<template>
    <!-- 商品管理页面 -->
<div align="center">
  <!-- 操作按钮区域 -->
<el-button type="primary" @click="deleteSelected">删除</el-button> 
<el-button type="primary" @click="showDialog('add','')">新增</el-button> 
<el-input v-model="searchData.product_name" placeholder="请输入商品名称" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-input v-model="searchData.product_code" placeholder="请输入商品编码" style="width: 120px;margin-left: 25px;margin-right: 25px" />
<el-button type="primary" @click="getProductList" style="width: 80px;margin-left: 25px;margin-right: 25px">搜索</el-button>
<el-button type="primary" @click="clearData" style="width: 80px;margin-left: 25px;margin-right: 25px">重置</el-button>
<!-- 商品列表表格 -->
<el-table :data="productList" :row-class-name="tableRowClassName"  style="width: 100%" @selection-change="handleSelectionChange" >
    <el-table-column align="center" type="selection" width="55" />
    <el-table-column align="center"  prop="product_id" label="商品编号" width="80" />
    <el-table-column align="center" prop="product_name" label="商品名称" width="150" />
    <el-table-column align="center" prop="product_code" label="商品编码" width="100" />
    <el-table-column align="center" prop="category_id" label="类型" width="80" />
    <el-table-column align="center" prop="original_price" label="原始单价" width="100" />
    <el-table-column align="center" prop="price" label="单价" width="100" />
    <el-table-column align="center" prop="stock_num" label="库存数量" width="80" />
    <el-table-column align="center" prop="sales_num" label="销售数量" width="80" />
    
    <!-- 商品图片展示 -->
    <el-table-column align="center"  label="商品图片" width="120" >
         <template v-slot="scope">
          <div class="demo-image__preview">
            <div @click="downloadImage(scope.row.image_url)">
            <el-image style="width: 75px; height: 75px;" :src="`http://127.0.0.1:90/eshop2403/images/${scope.row.image_url}`"  />
            </div>
          </div>
         </template>
    </el-table-column>
    
    <el-table-column align="center" prop="create_time" label="创建日期" width="180" />
    
    <!-- 操作列 -->
    <el-table-column align="center" label="操作" width="180">
        <template v-slot="{ row }">
          <el-button type="primary" link @click="delRow(row.product_id)">删除</el-button>
          <el-button type="primary" link @click="showDialog('edit',row.product_id)">修改</el-button>
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
<!-- 商品编辑对话框 -->
<el-dialog v-model="dialogVisible" :title="typeTile"  width="500" :before-close="handleClose">
      <el-form :model="goodsData" label-width="120px" label-position="left">  <!-- 设置宽度和左对其齐 -->
                <el-form-item label="商品名称">
                  <el-input v-model="goodsData.product_name" placeholder="请输入商品名称"></el-input>
                </el-form-item>
                <el-form-item label="商品编码">
                  <el-input v-model="goodsData.product_code" placeholder="请输入商品编码"></el-input>
                </el-form-item>
                <el-form-item label="类别编号">
                  <el-input v-model="goodsData.category_id" placeholder="请输入类别编号"></el-input>
                </el-form-item>
                <el-form-item label="商品单价">
                  <el-input  v-model="goodsData.price" placeholder="请输入商品单价"></el-input>
                </el-form-item>
                <el-form-item label="原始单价">
                  <el-input  v-model="goodsData.original_price" placeholder="请输入原始单价"></el-input>
                </el-form-item>
                <el-form-item label="库存数量">
                  <el-input  v-model="goodsData.stock_num" placeholder="请输入库存数量"></el-input>
                </el-form-item>

                <!-- 商品图片上传 -->
                <el-form-item label="商品图片">
                <el-upload  @http-request="uploadImg" >
                    <template #trigger>      <el-button type="primary">请选择文件</el-button>    </template>
                    <el-button class="ml-3" type="success" @click="uploadImg"> 文件上传 </el-button>
                </el-upload>
                </el-form-item>

                <el-form-item label="商品状态">
                   <el-input v-model="goodsData.status" placeholder="请输入状态(0下架/1上架)"></el-input>
                </el-form-item>
                <el-form-item label="商品简介">
                  <textarea style="width: 100%; height: auto; max-width: 100%" v-model="goodsData.subtitle"></textarea>
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
const productList = ref([])  //商品列表数据
const selected = ref([])  //选中的商品
const typeTile=ref()  //对话框标题
const dialogVisible=ref(false) //对话框显示状态
const uploadRef = ref() //上传组件引用

// 商品数据表单
const goodsData = ref({
    product_id:"",   //商品编号
    product_name:"", //商品名称
    product_code:"", //商品编码
    category_id:"",  //类别编号
    price:"",        //商品单价
    original_price:"",//原始单价
    stock_num:"",    //库存数量
    image_url:"",    //商品图片
    status:"",       //商品状态
    subtitle:""      //商品简介
  })
const searchData = ref({    //searchData
  product_name: '',
  product_code: ''
})
// 分页参数
const pageNum = ref(1)     // 当前页码
const pageSize = ref(5)    // 每页条数
const total = ref(0)       // 总记录数
// 初始化函数
const getProductList = async () => {                //定义请求异步请求函数
    try {
    // 异步等待请求完成
    const res = await request({
      url: '/product/list',
      method: 'POST',
      // 这里必须是 data，不是 product！！！
      data: searchData.value,
      params: {
        pageNum: pageNum.value,
        pageSize: pageSize.value
      }
    })
    if (res.code === 200) {
      productList.value = res.data.list
      total.value = res.data.total
      console.log('✅ 获取商品数据成功:', res)
    } else {
      console.log('❌ 接口返回非200:', res)
    }
  } catch (err) {
    // 捕获请求错误
    console.log('❌ 请求商品列表失败:', err)
  }
}
// 每页条数改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getProductList()
}

// 当前页改变
const handleCurrentChange = (val) => {
  pageNum.value = val
  getProductList()
}
//清空查询条件
const clearData = async () => {                //定义请求异步请求函数
    searchData.value = {
        product_name: '',
        product_code: ''
    }
}
// 删除单个商品
const delRow=(id)=>{
    ElMessageBox.confirm('您是否要删除此数据','Warning',{confirmButtonText:'确定',cancelButtonText:'取消',type:'warning'})
    .then(async()=>{
        try {
            const res=await request.delete(`/product/delete/${id}`)
            if(res.code === 200){
                ElMessage({type:'success',message:'删除成功'})
            }     
            await getProductList()
        } catch (error) {
            console.error('删除商品失败:', error);
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

// 批量删除商品
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
                const ids = selected.value.map(item => item.product_id)
                console.log(ids);
                const res = await request.post('/product/deleteBatch', ids)
                console.log(res);
                if(res.code === 200){
                    ElMessage({
                        type:'success',
                        message:'删除成功！',
                })            
                await getProductList()//调用数据列表方法刷新前端页面
            }
            } catch (error) {
                console.error('批量删除商品失败:', error);
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
         typeTile.value = '新增商品'
      } else {
         typeTile.value = '修改商品'
          request({
              url: '/product/findById',
              method: 'GET',
              params: {
                  id: gid
              }
          }).then(res => {
              goodsData.value = res.data
              console.log(res);
          }).catch(error => {
              console.error('获取商品详情失败:', error);
              ElMessage({type:'error',message:'获取商品详情失败'})
          })
      }
  
      dialogVisible.value = true
  }

// 新增或修改数据
const submit = async () => {
      try {
          if (typeTile.value == '新增商品') {
              const { product_id, ...addData } = goodsData.value
              const res = await request.post('/product/add', addData)
              if (res.code === 200) {
                  ElMessage({
                      type: 'success',
                      message: '新增成功'
                  })
              }
          } else {        
              const res = await request.put('/product/update', goodsData.value)
              if (res.code === 200) {
                  ElMessage({
                      type: 'success',
                      message: '修改成功'
                  })
              }
          }
          // 清空表单
          goodsData.value = {
            product_id:"",
            product_name:"",
            product_code:"",
            category_id:"",
            price:"",
            original_price:"",
            stock_num:"",
            image_url:"",
            status:"",
            subtitle:""
          };
          await getProductList()
          dialogVisible.value = false
      } catch (error) {
          console.error('保存商品失败:', error);
          ElMessage({type:'error',message:'保存失败'})
      }
  }

// 点击对话框中的"取消"按钮清空内存数据
const clear = () => {
    goodsData.value = {
    product_id:"",
    product_name:"",
    product_code:"",
    category_id:"",
    price:"",
    original_price:"",
    stock_num:"",
    image_url:"",
    status:"",
    subtitle:""
  }
   dialogVisible.value = false
}

// 文件上传
const uploadImg = async(fileData) =>{
  try {
    console.log(fileData);
    const {file}=fileData;
    const fdata=new FormData();
    fdata.append("file",file);
    const res=await request({
      method: "post",
      url: "/product/upload",
      data: fdata,
      headers: {"Content-Type":"multipart/form-data"}
    });
    if(res.code==200){
      ElMessage({
          type: 'success',
          message: '文件上传成功'
       })
       goodsData.value.image_url=res.data;
    }
  } catch (error) {
    console.error('上传文件失败:', error);
    ElMessage({type:'error',message:'上传失败'})
  }
}

// 文件下载
const downloadImage = async (fileName) => {  
      try {  
        // 调用后端API下载图片  
        const response = await request({  
          method: 'get',  
          url: '/product/download', // 后端接口 
          params: {  
            fileName: fileName, // 传递图片文件名给后端  
          },  
          responseType: 'blob',  
        });
        // 创建blob对象  
        let blob=new Blob([response],{type:"application/octet-stream"});        
        const url = window.URL.createObjectURL(blob); //创建一个零时的url指向blob对象  
       // 创建一个a标签用于下载  
        const link = document.createElement('a');          
        link.href = url;  
        link.setAttribute('download', fileName); // 设置下载文件的文件名  
        document.body.appendChild(link);  
        link.click(); // 模拟点击a标签实现下载  
        setTimeout(()=>{
          window.URL.revokeObjectURL(url);
        },0);         
      } catch (error) {
        console.error('下载图片时出错:', error);
        ElMessage({type:'error',message:'下载失败'})
      }
  }

// 表格行样式
const tableRowClassName = () => {}

// 处理对话框关闭
const handleClose = () => {
    clear()
}

// 组件挂载时获取商品列表
onMounted(() => {     
    getProductList()
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