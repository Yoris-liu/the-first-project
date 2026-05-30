<template>
  <div align="center">
    <el-table :data="[]" style="width: 100%">
      <el-table-column align="center" type="selection" width="55" />
      <el-table-column align="center" prop="role_id" label="角色编号" width="120" />
      <el-table-column align="center" prop="role_name" label="角色名称" width="150" />
      <el-table-column align="center" prop="role_code" label="角色编码" width="150" />
      <el-table-column align="center" prop="description" label="角色描述" width="200" />
      <el-table-column align="center" prop="create_time" label="创建时间" width="180" />
      <el-table-column align="center" label="操作" width="180">
        <template #default>
          <el-button type="primary" link>删除</el-button>
          <el-button type="primary" link>修改</el-button>
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
