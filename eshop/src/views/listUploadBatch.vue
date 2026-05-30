<template>
  <!-- 文件上传组件容器 -->
  <div class="upload-box">
    <!-- 页面标题 -->
    <h3>Vue3 多文件批量上传</h3>
    <!-- Element Plus 上传组件/支持多文件上传 -->
    <el-upload
      ref="uploadRef"
      class="upload-demo"
      action="#"
      :http-request="httpRequest"
      :on-success="handleSuccess"
      :on-error="handleError"
      :on-change="handleChange"
      :on-remove="handleRemove"
      :file-list="fileList"
      accept=".jpg,.png,.jpeg,.gif,.pdf"
      :auto-upload="false"
      drag
      multiple  
    >
      <el-icon class="el-icon--upload"><upload-filled /></el-icon>
      <div class="el-upload__text">拖拽多文件到此处 或 <em>点击上传</em></div>
      <template #tip>
        <div class="el-upload__tip">支持多文件上传，格式：jpg、png、jpeg、gif、pdf</div>
      </template>
    </el-upload>

    <!-- 操作按钮区域 -->
    <div class="upload-btn">
      <el-button type="primary" @click="submitUpload">批量上传</el-button>
      <el-button @click="clearFiles">清空所有文件</el-button>
    </div>

    <!-- 多文件预览区域 -->
    <div v-if="previewList.length > 0" class="preview-section">
      <h4>已上传文件预览（{{ previewList.length }}个）：</h4>
      <div class="preview-list">
        <div class="preview-item" v-for="url in previewList" :key="url">
          <el-image
            :src="`http://127.0.0.1:90/eshop2403/images/${url}`"
            :preview-src-list="previewList.map(item => `http://127.0.0.1:90/eshop2403/images/${item}`)"
            fit="contain"
            class="preview-image"
          />
        </div>
      </div>
    </div>

    <!-- 提示信息区域 -->
    <div v-if="tip" class="tip-section">
      <p :class="{'success': tipType === 'success', 'error': tipType === 'error'}">
        {{ tip }}
      </p>
    </div>
  </div>
</template>

<script setup>
/**
 * 多文件批量上传组件
 */
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { UploadFilled } from '@element-plus/icons-vue'
import request from '@/utils/request'

// ==================== 响应式数据 ====================
const uploadRef = ref(null)
const tip = ref('')
const tipType = ref('')
const fileList = ref([])
const previewList = ref([]) // 多文件预览地址

// ==================== 常量 ====================
const MAX_FILE_SIZE = 10 * 1024 * 1024

// ==================== 自定义批量上传 ====================
const httpRequest = async (options) => {
  const { file, onSuccess, onError } = options
  try {
    const formData = new FormData()
    formData.append('files', file) // 后端批量接收参数

    const res = await request.post('/product/uploadBatch', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })

    if (res.code === 200) {
      const fileName = res.data
      previewList.value.push(fileName)
      onSuccess(res, file)
      ElMessage.success(`${file.name} 上传成功`)
    } else {
      ElMessage.error(`${file.name} 上传失败`)
      onError(new Error('上传失败'))
    }
  } catch (error) {
    ElMessage.error(`${file.name} 上传异常`)
    onError(error)
  }
}

// ==================== 事件钩子 ====================
const handleChange = (uploadFile, uploadFiles) => {
  fileList.value = uploadFiles
}

const handleSuccess = (response, file) => {
  tip.value = `已成功上传 ${previewList.value.length} 个文件`
  tipType.value = 'success'
}

const handleError = (error, file) => {
  tip.value = file.name + ' 上传失败'
  tipType.value = 'error'
}

const handleRemove = (file, fileListArr) => {
  fileList.value = fileListArr
  // 移除预览
  const fileName = file.response?.data
  if (fileName) {
    previewList.value = previewList.value.filter(item => item !== fileName)
  }
}

// ==================== 手动批量上传 ====================
const submitUpload = () => {
  if (fileList.value.length === 0) {
    ElMessage.warning('请先选择文件')
    return
  }
  tip.value = '正在批量上传，请稍候...'
  tipType.value = ''
  uploadRef.value.submit()
}

// ==================== 清空 ====================
const clearFiles = () => {
  uploadRef.value.clearFiles()
  fileList.value = []
  previewList.value = []
  tip.value = ''
  tipType.value = ''
}
</script>

<style scoped>
.upload-box {
  padding: 30px;
}

.upload-demo {
  margin-bottom: 20px;
}

.el-icon--upload {
  font-size: 67px;
  color: #409eff;
  margin-bottom: 16px;
}

.el-upload__text {
  color: #606266;
}

.el-upload__tip {
  color: #909399;
  margin-top: 7px;
}

.upload-btn {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}

/* 多文件预览布局 */
.preview-section {
  margin-top: 30px;
  border-top: 1px solid #ebeef5;
  padding-top: 20px;
}

.preview-list {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}

.preview-item {
  width: 120px;
}

.preview-image {
  width: 120px;
  height: 120px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
}

.tip-section {
  margin-top: 20px;
}

.tip-section p {
  padding: 10px;
  border-radius: 4px;
  margin: 0;
}

.success {
  background-color: #f0f9ff;
  color: #67c23a;
}

.error {
  background-color: #fef0f0;
  color: #f56c6c;
}
</style>