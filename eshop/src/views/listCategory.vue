<template>
   <div style="max-width: 1100px; margin: 40px auto;">
    <h2 style="margin-bottom: 20px; text-align: center; font-size: 24px; color: #303133;">商品分类管理</h2>

    <!-- 表格容器 -->
    <div class="table-container">

      <!-- 表格标题行 -->
      <div class="table-header">
        <span class="flex-1 header-cell">分类名称</span>
        <span class="width-150 header-cell">分类编码</span>
        <span class="width-200 header-cell">创建时间</span>
        <span class="width-200 header-cell">更新时间</span>
        <span class="width-150 header-cell">操作</span>
      </div>

      <!-- 表格数据行 -->
      <el-tree
        :data="list"
        :props="defaultProps"
        accordion
        default-expand-all
        class="custom-tree"
      >
        <template #default="{ node, data }">
          <span class="custom-tree-node">
            <span class="flex-1 data-cell">
              <i class="el-icon-folderOpened" style="margin-right: 8px; color: #409eff;"></i>
              {{ node.label }}
            </span>
            <span class="width-150 data-cell">{{ data.category_code || '-' }}</span>
            <span class="width-200 data-cell">{{ data.create_time || '-' }}</span>
            <span class="width-200 data-cell">{{ data.update_time || '-' }}</span>
            <span class="width-150 data-cell">
              <el-button type="danger" size="small" link @click="handleDelete(data)">删除</el-button>
              <el-button type="primary" size="small" link @click="handleEdit(data)">修改</el-button>              
            </span>
          </span>
        </template>
      </el-tree>
    </div>

    <!-- 修改分类对话框 -->
    <el-dialog v-model="dialogVisible" title="修改分类" width="500px">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="分类名称">
          <el-input v-model="formData.category_name" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="分类编码">
          <el-input v-model="formData.category_code" placeholder="请输入分类编码" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import { onMounted, ref } from 'vue'     //引入vue
import request from '@/utils/request.js'  //引入请求基地址
import { ElMessage, ElMessageBox, ElTree } from 'element-plus'
// 树形数据
const list = ref([])
// 树形组件配置
const defaultProps = {
  children: 'children',
  label: 'category_name'
}

// 对话框相关
const dialogVisible = ref(false)
const formData = ref({
  category_id: '',
  category_name: '',
  category_code: ''
})

// 获取后端树形分类
const getTreeData = async () => {
  try {
    const res = await request.get('/category/tree')  //使用request而不是axios
    console.log('获取分类树数据:', res)
    list.value = res.data || []
  } catch (error) {
    console.error('获取分类树数据失败:', error)
    ElMessage({type:'error',message:'获取分类数据失败'})
    list.value = []
  }
}

// 修改分类
const handleEdit = (data) => {
  formData.value = {
    category_id: data.category_id,
    category_name: data.category_name,
    category_code: data.category_code
  }
  dialogVisible.value = true
}

// 提交修改
const submitForm = async () => {
  try {
    const res = await request.put('/category/update', formData.value)
    if (res.code === 200) {
      ElMessage({type:'success',message:'修改成功'})
      dialogVisible.value = false
      await getTreeData()
    } else {
      ElMessage({type:'error',message:'修改失败'})
    }
  } catch (error) {
    console.error('修改分类失败:', error)
    ElMessage({type:'error',message:'修改失败'})
  }
}

// 删除分类
const handleDelete = (data) => {
  ElMessageBox.confirm('确定要删除该分类吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await request.delete(`/category/delete/${data.category_id}`)
      if (res.code === 200) {
        ElMessage({type:'success',message:'删除成功'})
        await getTreeData()
      } else {
        ElMessage({type:'error',message:'删除失败'})
      }
    } catch (error) {
      console.error('删除分类失败:', error)
      ElMessage({type:'error',message:'删除失败'})
    }
  }).catch(() => {
    ElMessage({type:'info',message:'已取消删除'})
  })
}

// 页面加载就获取分类树
onMounted(() => {
  getTreeData()
})
</script>
<style scoped>
/* 页面整体布局 */
@media (min-width: 1024px) {
  .about {
    min-height: 100vh;
    display: flex;
    align-items: center;
  }
}

/* 表格容器样式 */
.table-container {
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  border: 1px solid #e4e7ed;
}

/* 表格标题行样式 */
.table-header {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 16px 0;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  color: #ffffff;
  font-weight: 600;
  font-size: 15px;
}

/* 标题单元格样式 */
.header-cell {
  padding: 0 10px;
  text-align: center;
  letter-spacing: 1px;
}

/* 表格数据行样式 */
.custom-tree-node {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 14px 0;
  transition: all 0.3s ease;
}

/* 数据单元格样式 */
.data-cell {
  padding: 0 10px;
  text-align: center;
  color: #606266;
  font-size: 14px;
}

/* 统一列宽和布局类 */
.flex-1 {
  flex: 1;
  text-align: left;
  padding-left: 20px;
}
.width-150 {
  width: 150px;
}
.width-200 {
  width: 200px;
}

/* 树形组件样式调整 */
.custom-tree {
  background: transparent;
}

/* 悬停效果 */
:deep(.el-tree-node__content:hover) {
  background: linear-gradient(90deg, #ecf5ff 0%, #f0f9eb 100%);
}

:deep(.el-tree-node__content) {
  height: auto !important;
  padding: 0 !important;
  background: transparent !important;
}

:deep(.el-tree-node) {
  border-bottom: 1px solid #f0f0f0;
  transition: background 0.3s ease;
}

:deep(.el-tree-node:hover) {
  background: linear-gradient(90deg, #ecf5ff 0%, #f0f9eb 100%);
}

:deep(.el-tree-node__children .el-tree-node__content:hover) {
  background: linear-gradient(90deg, #fff4e6 0%, #fff9f0 100%);
}

/* 展开收起图标样式 */
:deep(.el-icon) {
  color: #409eff;
  font-size: 14px;
}

/* 圆角图标 */
:deep(.el-tree-node__content > .el-tree-node__expand-icon) {
  padding: 6px;
  border-radius: 4px;
  background: rgba(64, 158, 255, 0.1);
  margin-left: 10px;
}

:deep(.el-tree-node__content > .el-tree-node__expand-icon:hover) {
  background: rgba(64, 158, 255, 0.2);
}
</style>