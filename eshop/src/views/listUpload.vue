<template>
    <!-- 文件上传组件容器 -->
    <div class="upload-box">
      <!-- 页面标题 -->
      <h3>Vue3 文件上传</h3>
      <!-- Element Plus 上传组件/组件引用，用于调用组件方法/组件样式类名/上传地址，#表示自定义上传/自定义上传方法，覆盖默认上传行为-->
      <!-- 上传前的钩子函数，用于文件校验/文件上传成功时的钩子/文件上传失败时的钩子/文件状态改变时的钩子/文件移除时的钩子-->
      <!-- 上传的文件列表,接受的文件类型/是否自动上传，false表示手动上传/是否启用拖拽上传 -->
      <el-upload ref="uploadRef" class="upload-demo" action="#" :http-request="httpRequest" :on-success="handleSuccess"        
        :on-error="handleError" :on-change="handleChange" :on-remove="handleRemove" :file-list="fileList"              
        accept=".jpg,.png,.jpeg,.gif,.pdf" :auto-upload="false" drag >
        <!-- 上传图标 -->
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
         <!-- 上传提示文本 -->
        <div class="el-upload__text">拖拽文件到此处 或 <em>点击上传</em></div>        
        <!-- 上传提示信息 -->
        <template #tip><div class="el-upload__tip">支持 .jpg、.png、.jpeg、.gif、.pdf 格式的文件</div></template>
      </el-upload>
      <!-- 操作按钮区域 -->
      <div class="upload-btn">
        <el-button type="primary" @click="submitUpload">开始上传</el-button>
        <el-button @click="clearFiles">清空文件</el-button>
      </div>
      <!-- 图片预览区域，仅在上传成功后显示 -->
      <div v-if="fileUrl" class="preview-section">
        <h4>图片预览：</h4>
        <!-- Element Plus 图片组件，支持预览放大/图片地址/预览图片列表/图片适应方式/图片样式类 -->
        <el-image
          :src="`http://127.0.0.1:90/eshop2403/images/${fileUrl}`"          
          :preview-src-list="[`http://127.0.0.1:90/eshop2403/images/${fileUrl}`]"
          fit="contain" class="preview-image"                                              
        />
      </div>
      <!-- 提示信息区域，仅在有提示信息时显示 -->
      <div v-if="tip" class="tip-section">
        <p :class="{'success': tipType === 'success', 'error': tipType === 'error'}">
          {{ tip }}
        </p>
      </div>
    </div>
  </template>

  <script setup>
  /**
   * 文件上传组件
   * 功能：支持拖拽上传、手动上传、文件大小校验、图片预览
   * 技术栈：Vue3 + Element Plus
   */  
  // 导入Vue3响应式API
  import { ref } from 'vue'  
  // 导入Element Plus消息提示组件
  import { ElMessage } from 'element-plus'  
  // 导入Element Plus上传图标
  import { UploadFilled } from '@element-plus/icons-vue'  
  // 导入自定义请求工具
  import request from '@/utils/request'
  // ==================== 响应式数据定义 ====================  
  // 上传组件引用，用于调用组件方法（如submit、clearFiles）
  const uploadRef = ref(null)  
  // 提示信息内容
  const tip = ref('')  
  // 提示信息类型（success/error）
  const tipType = ref('')  
  // 上传成功后的文件URL
  const fileUrl = ref('')  
  // 文件列表，存储已选择的文件
  const fileList = ref([])
  // ==================== 常量定义 ====================  
  // 限制文件大小为 10MB（10 * 1024 * 1024 字节）
  const MAX_FILE_SIZE = 10 * 1024 * 1024
  // ==================== 文件上传相关函数 ====================  
  /**
   * 文件上传前的校验函数
   * @param {File} file - 待上传的文件对象
   * @returns {boolean} - 返回true继续上传，返回false取消上传
   */
  const beforeUpload = (file) => {
    // 检查文件大小是否超过限制
    if (file.size > MAX_FILE_SIZE) {
      ElMessage.error('文件大小不能超过 10MB')
      return false  // 阻止上传
    }
    return true  // 允许上传
  }
  /**
   * 自定义上传方法
   * 使用自定义请求代替Element Plus默认的上传行为
   * @param {Object} options - 上传配置对象
   * @param {File} options.file - 文件对象
   * @param {Function} options.onSuccess - 成功回调
   * @param {Function} options.onError - 失败回调
   */
  const httpRequest = async (options) => {
    const { file, onSuccess, onError } = options
    try {
      // 创建FormData对象，用于文件上传
      const formData = new FormData()
      formData.append('file', file)  // 后端接收参数名必须为'file'
      // 发送上传请求
      const res = await request.post('/product/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'  // 设置请求头为文件上传类型
        }
      })
      // 判断上传是否成功
      if (res.code === 200) {
        // 上传成功处理
        fileUrl.value = res.data        // 保存文件URL
        onSuccess(res, file)            // 调用成功回调
        tip.value = '上传成功'          // 设置提示信息
        tipType.value = 'success'       // 设置提示类型
        ElMessage.success('文件上传成功') // 显示成功消息
      } else {
        // 上传失败处理
        tip.value = '上传失败：' + (res.data || '未知错误')
        tipType.value = 'error'
        onError(new Error(res.data || '上传失败'))
        ElMessage.error('文件上传失败')
      }
    } catch (error) {
      // 异常处理
      tip.value = '请求异常'
      tipType.value = 'error'
      onError(error)
      ElMessage.error('文件上传异常')
    }
  }
  /**
   * 文件状态改变时的钩子函数
   * 当选择文件或文件上传状态改变时触发
   * @param {Object} uploadFile - 当前文件对象
   * @param {Array} uploadFiles - 文件列表
   */
  const handleChange = (uploadFile, uploadFiles) => {
    fileList.value = uploadFiles  // 更新文件列表    
    // 如果文件状态为'ready'，表示刚选择文件
    if (uploadFile.status === 'ready') {
      tip.value = '已选择文件：' + uploadFile.name
      tipType.value = ''
    }
  }
  /**
   * 文件上传成功时的钩子函数
   * @param {Object} response - 服务器响应数据
   * @param {File} file - 上传的文件对象
   */
  const handleSuccess = (response, file) => {
    console.log('上传成功', response, file)
  }
  /**
   * 文件上传失败时的钩子函数
   * @param {Error} error - 错误对象
   * @param {File} file - 上传失败的文件对象
   */
  const handleError = (error, file) => {
    console.log('上传失败', error, file)
  }
  /**
   * 文件移除时的钩子函数
   * 当用户删除已选择的文件时触发
   * @param {Object} file - 被移除的文件对象
   * @param {Array} fileList - 剩余的文件列表
   */
  const handleRemove = (file, fileList) => {
    console.log('移除文件', file, fileList)
    fileList.value = fileList  // 更新文件列表    
    // 如果文件列表为空，清空相关状态
    if (fileList.length === 0) {
      fileUrl.value = ''
      tip.value = ''
      tipType.value = ''
    }
  }
  // ==================== 手动操作函数 ====================  
  /**
   * 手动提交上传
   * 点击"开始上传"按钮时调用
   */
  const submitUpload = () => {
    // 检查是否选择了文件
    if (fileList.value.length === 0) {
      ElMessage.warning('请先选择文件')
      return
    }
    // 调用上传组件的submit方法开始上传
    uploadRef.value.submit()
  }
  /**
   * 清空文件列表
   * 重置所有状态到初始值
   */
  const clearFiles = () => {
    uploadRef.value.clearFiles()  // 清空上传组件的文件列表
    fileList.value = []            // 清空文件列表数据
    fileUrl.value = ''             // 清空文件URL
    tip.value = ''                 // 清空提示信息
    tipType.value = ''             // 清空提示类型
  }
  </script>

  <style scoped>
  /* ==================== 容器样式 ==================== */
  
  /* 上传组件容器 */
  .upload-box {
    padding: 30px;  /* 内边距 */
  }

  /* 上传组件样式 */
  .upload-demo {
    margin-bottom: 20px;  /* 底部外边距 */
  }

  /* ==================== 上传区域样式 ==================== */
  
  /* 上传图标样式 */
  .el-icon--upload {
    font-size: 67px;        /* 图标大小 */
    color: #409eff;         /* 图标颜色（Element Plus主题蓝） */
    margin-bottom: 16px;    /* 底部外边距 */
  }

  /* 上传文本样式 */
  .el-upload__text {
    color: #606266;  /* 文本颜色 */
  }

  /* 上传提示样式 */
  .el-upload__tip {
    color: #909399;       /* 提示文本颜色 */
    margin-top: 7px;      /* 顶部外边距 */
  }

  /* ==================== 按钮区域样式 ==================== */
  
  /* 操作按钮容器 */
  .upload-btn {
    margin-top: 20px;  /* 顶部外边距 */
    display: flex;     /* 弹性布局 */
    gap: 10px;         /* 按钮间距 */
  }

  /* ==================== 预览区域样式 ==================== */
  
  /* 图片预览区域 */
  .preview-section {
    margin-top: 30px;               /* 顶部外边距 */
    border-top: 1px solid #ebeef5;  /* 顶部边框 */
    padding-top: 20px;              /* 顶部内边距 */
  }

  /* 预览区域标题 */
  .preview-section h4 {
    margin-bottom: 15px;  /* 底部外边距 */
    color: #303133;       /* 标题颜色 */
  }

  /* 预览图片样式 */
  .preview-image {
    width: 300px;                 /* 图片宽度 */
    height: 300px;                /* 图片高度 */
    border: 1px solid #ebeef5;    /* 边框 */
    border-radius: 8px;           /* 圆角 */
  }

  /* ==================== 提示信息样式 ==================== */
  
  /* 提示信息区域 */
  .tip-section {
    margin-top: 20px;  /* 顶部外边距 */
  }

  /* 提示信息文本 */
  .tip-section p {
    padding: 10px;         /* 内边距 */
    border-radius: 4px;    /* 圆角 */
    margin: 0;             /* 清除默认外边距 */
  }

  /* 成功提示样式 */
  .tip-section .success {
    background-color: #f0f9ff;  /* 背景色（浅蓝） */
    color: #67c23a;             /* 文本颜色（绿色） */
  }

  /* 错误提示样式 */
  .tip-section .error {
    background-color: #fef0f0;  /* 背景色（浅红） */
    color: #f56c6c;             /* 文本颜色（红色） */
  }
  </style>