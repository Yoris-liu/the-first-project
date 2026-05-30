<template>
  <div align="center">
    <el-table :data="[]" style="width: 100%">
      <el-table-column align="center" type="selection" width="55" />
      <el-table-column align="center" prop="id" label="日志编号" width="100" />
      <el-table-column align="center" prop="username" label="操作人" width="120" />
      <el-table-column align="center" prop="ip" label="IP地址" width="140" />
      <el-table-column align="center" prop="operate_module" label="操作模块" width="150" />
      <el-table-column align="center" prop="operate_time" label="操作时间" width="180" />
      <el-table-column align="center" prop="class_name" label="类名" width="200" />
      <el-table-column align="center" prop="method_name" label="方法名" width="150" />
      <el-table-column align="center" label="操作" width="120">
        <template #default>
          <el-button type="primary" link>查看</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-box">
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[5,10,15,20]"
        layout="total, sizes, prev, pager, next, jumper"
      />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
</script>

<style scoped>
.pagination-box {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
</style>
