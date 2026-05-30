<template>
  <!-- 用户管理页面整体容器 -->
  <div class="container" align="center">
    <!-- ===================== 顶部功能按钮区 ===================== -->
    <!-- 批量删除按钮 -->
    <el-button type="primary" @click="deleteSelected">批量删除</el-button>
    <!-- 新增用户按钮 -->
    <el-button type="primary" @click="showDialog('add','')">新增用户</el-button>

    <!-- 用户名搜索框 -->
    <el-input 
      v-model="searchData.username" 
      placeholder="请输入用户名" 
      style="width: 140px;margin: 0 15px" 
    />
    <!-- 搜索按钮：点击查询用户列表 -->
    <el-button type="primary" @click="getUserList">搜索</el-button>
    <!-- 重置按钮：清空搜索条件并刷新 -->
    <el-button type="primary" @click="clearData" style="margin-left: 10px">重置</el-button>

    <!-- ===================== 用户数据表格 ===================== -->
    <el-table 
      :data="userList"
      style="width: 100%;margin-top: 20px"
      @selection-change="handleSelectionChange"
    >
      <!-- 复选框列：用于批量选择 -->
      <el-table-column align="center" type="selection" width="55" />
      <!-- 用户编号 -->
      <el-table-column align="center" prop="user_id" label="用户编号" width="90" />
      <!-- 用户名 -->
      <el-table-column align="center" prop="username" label="用户名" width="120" />
      <!-- 密码 -->
      <el-table-column align="center" prop="password" label="密码" width="120" />
      <!-- 真实姓名 -->
      <el-table-column align="center" prop="real_name" label="真实姓名" width="120" />
      <!-- 手机号 -->
      <el-table-column align="center" prop="phone" label="手机号" width="130" />
      <!-- 邮箱 -->
      <el-table-column align="center" prop="email" label="邮箱" width="180" />
      
      <!-- 性别列：自定义显示内容 -->
      <el-table-column align="center" prop="gender" label="性别" width="80">
        <template #default="{row}">
          <span>{{ row.gender === '男' ? '男' : row.gender === '女' ? '女' : '未知' }}</span>
        </template>
      </el-table-column>

      <!-- 状态列：使用标签样式显示 -->
      <el-table-column align="center" prop="status" label="状态" width="80">
        <template #default="{row}">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '正常' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>

      <!-- 创建时间 -->
      <el-table-column align="center" prop="create_time" label="创建时间" width="200" />
      
      <!-- 操作列：删除 + 修改 -->
      <el-table-column align="center" label="操作" width="180">
        <template #default="{ row }">
          <el-button type="primary" link @click="delRow(row.user_id)">删除</el-button>
          <el-button type="primary" link @click="showDialog('edit',row.user_id)">修改</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- ===================== 分页组件 ===================== -->
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

    <!-- ===================== 新增/编辑 对话框 ===================== -->
    <el-dialog v-model="dialogVisible" :title="typeTile" width="550px">
      <!-- 表单：绑定数据、校验规则 -->
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        
        <el-form-item label="用户名" prop="username">
          <el-input v-model="formData.username" placeholder="请输入用户名" />
        </el-form-item>

        <el-form-item label="登录密码" prop="password">
          <el-input v-model="formData.password" placeholder="请输入密码" show-password />
        </el-form-item>

        <el-form-item label="真实姓名" prop="real_name">
          <el-input v-model="formData.real_name" placeholder="请输入真实姓名" />
        </el-form-item>

        <el-form-item label="手机号" prop="phone">
          <el-input v-model="formData.phone" placeholder="请输入手机号" />
        </el-form-item>

        <el-form-item label="邮箱" prop="email">
          <el-input v-model="formData.email" placeholder="请输入邮箱" />
        </el-form-item>

        <!-- 性别单选 -->
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="formData.gender">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <!-- 状态单选 -->
        <el-form-item label="账号状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>

      <!-- 对话框底部按钮 -->
      <template #footer>
        <el-button @click="clearForm">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
// 引入Vue3组合式API
import { ref, reactive, onMounted } from 'vue'
// 引入封装的axios请求工具
import request from '@/utils/request.js'
// 引入Element Plus消息提示、确认框
import { ElMessage, ElMessageBox } from 'element-plus'

// ===================== 表格数据与分页 =====================
// 用户列表数据
const userList = ref([])
// 当前页码
const pageNum = ref(1)
// 每页显示条数
const pageSize = ref(10)
// 总记录数
const total = ref(0)

// ===================== 搜索条件 =====================
const searchData = ref({
  username: ''  // 根据用户名搜索
})

// ===================== 批量选择 =====================
// 存储用户选中的多条数据
const selected = ref([])

// ===================== 弹窗相关 =====================
// 控制弹窗显示/隐藏
const dialogVisible = ref(false)
// 弹窗标题：新增用户 / 编辑用户
const typeTile = ref('')
// 表单DOM引用，用于校验
const formRef = ref(null)

// ===================== 表单数据 =====================
const formData = ref({
  user_id: '',      // 用户ID
  username: '',     // 用户名
  password: '',     // 密码
  real_name: '',    // 真实姓名
  phone: '',        // 手机号
  email: '',        // 邮箱
  gender: '男',     // 性别，默认男
  status: 1         // 状态，默认正常1
})

// ===================== 表单校验规则 =====================
const formRules = reactive({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ],
  real_name: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' }
  ]
})

// ===================== 获取用户列表 =====================
const getUserList = async () => {
  // 发送请求
  const res = await request({
    url: '/users/list',
    method: 'POST',
    data: searchData.value,    // 搜索条件
    params: { pageNum: pageNum.value, pageSize: pageSize.value } // 分页
  })
  // 请求成功，赋值给表格
  if (res.code === 200) {
    userList.value = res.data.list
    total.value = res.data.total
  }
}

// ===================== 清空搜索条件 =====================
const clearData = () => {
  searchData.value.username = ''
  getUserList() // 重新查询
}

// ===================== 分页事件 =====================
// 改变每页条数
const handleSizeChange = () => {
  pageNum.value = 1
  getUserList()
}
// 改变页码
const handleCurrentChange = () => {
  getUserList()
}

// ===================== 删除单条数据 =====================
const delRow = (id) => {
  // 弹出确认框
  ElMessageBox.confirm('确定删除该用户？', '提示', { type: 'warning' })
  .then(async () => {
    // 调用删除接口
    await request.delete(`/users/delete/${id}`)
    ElMessage.success('删除成功')
    // 刷新列表
    getUserList()
  }).catch(() => {
    ElMessage.info('已取消')
  })
}

// ===================== 批量选择事件 =====================
const handleSelectionChange = (val) => {
  // val 就是选中的所有行
  selected.value = val
}

// ===================== 批量删除 =====================
const deleteSelected = async () => {
  // 没选数据直接提示
  if (selected.value.length === 0) {
    return ElMessage.warning('请先选择要删除的数据')
  }
  ElMessageBox.confirm('确定批量删除选中用户？')
  .then(async () => {
    // 提取选中数据的ID
    const ids = selected.value.map(item => item.user_id)
    // 调用批量删除接口
    await request.post('/users/deleteBatch', ids)
    ElMessage.success('批量删除成功')
    // 刷新列表
    getUserList()
  }).catch(() => {
    ElMessage.info('已取消')
  })
}

// ===================== 打开弹窗（新增/编辑） =====================
const showDialog = async (type, id) => {
  // 先清空表单
  clearForm()
  // 判断是新增还是编辑
  if (type === 'add') {
    typeTile.value = '新增用户'
  } else {
    typeTile.value = '编辑用户'
    // 根据ID查询当前用户数据，回显到表单
    const res = await request.get('/users/findById', { params: { id } })
    formData.value = res.data
  }
  // 打开弹窗
  dialogVisible.value = true
}

// ===================== 清空表单 & 关闭弹窗 =====================
const clearForm = () => {
  formData.value = {
    user_id: '',
    username: '',
    password: '',
    real_name: '',
    phone: '',
    email: '',
    gender: '男',
    status: 1
  }
  // 清除校验提示
  formRef.value?.clearValidate()
  // 关闭弹窗
  dialogVisible.value = false
}

// ===================== 提交：新增或修改 =====================
const submitForm = async () => {
  // 先做表单校验
  await formRef.value.validate()
  // 判断是新增
  if (typeTile.value === '新增用户') {
    const { user_id, ...addData } = formData.value
    await request.post('/users/add', addData)
    ElMessage.success('新增成功')
  } else {
    // 否则是修改
    await request.put('/users/update', formData.value)
    ElMessage.success('修改成功')
  }
  // 提交完成，清空表单并关闭弹窗
  clearForm()
  // 刷新列表
  getUserList()
}

// ===================== 页面加载完成后自动执行 =====================
onMounted(() => {
  getUserList()
})
</script>

<style scoped>
/* 分页样式 */
.pagination-box {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
/* 页面容器 */
.container {
  padding: 20px;
}
</style>