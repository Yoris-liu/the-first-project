<template>
    <div align="center">
        <el-button type="primary" @click="deleteSelected()">删除</el-button>
        <el-button type="primary" @click="showDialog('add', '')">新增</el-button>
        <el-input v-model="searchData.tno" placeholder="请输入工号"
            style="width: 120px;margin-left: 25px;margin-right: 25px" />
        <el-input v-model="searchData.tname" placeholder="请输入姓名"
            style="width: 120px;margin-left: 25px;margin-right: 25px" />
        <el-button type="primary" @click="getList"
            style="width: 80px;margin-left: 25px;margin-right: 25px">搜索</el-button>
        <el-button type="primary" @click="clearData"
            style="width: 80px;margin-left: 25px;margin-right: 25px">重置</el-button>
        <el-table :data="list" :row-class-name="tableRowClassName" style="width: 100%"
            @selection-change="handleSelectionChange">
            <el-table-column align="center" type="selection" width="55" />
            <el-table-column align="center" prop="tno" label="工号" width="80" />
            <el-table-column align="center" prop="tname" label="姓名" width="120" />
            <el-table-column align="center" prop="sex" label="性别" width="80" />
            <el-table-column align="center" prop="birthday" label="出生日期" width="120" />
            <el-table-column align="center" label="照片" width="120">
                <template v-slot="scope">
                    <div class="demo-image__preview">
                        <div @click="downloadImage(scope.row.pic)">
                            <el-image style="width: 75px; height: 75px"
                                :src="'http://192.168.77.51:90/images/' + scope.row.pic" />
                        </div>
                    </div>
                </template>
            </el-table-column>

            <el-table-column align="center" prop="createDate" label="创建日期" width="100" />
            <el-table-column align="center" label="操作" width="150">
                <template v-slot="{ row }">
                    <el-button type="primary" link @click="delRow(row.tno)">删除</el-button>
                    <el-button type="primary" link @click="showDialog('edit', row.tno)">修改</el-button>
                </template>
            </el-table-column>
        </el-table>
        <div class="page">
            <el-pagination :page-size="pageData.pageSize" layout="total, prev, pager, next" :total="total"
                @current-change="handleCurrentChange">
            </el-pagination>
        </div>

        <el-dialog v-model="dialogVisible" :title="typeTile" width="500" :before-close="handleClose" @close="clear()">
            <el-form :model="teacherData" label-width="120px" label-position="left">
                <el-form-item label="编号">
                    <el-input v-model="teacherData.tno" />
                </el-form-item>
                <el-form-item label="姓名">
                    <el-input v-model="teacherData.tname" />
                </el-form-item>
                <el-form-item label="性别">
                    <el-radio-group v-model="teacherData.sex" >
                        <el-radio value="男">男</el-radio>
                        <el-radio value="女">女</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="照片">
                    <!-- <el-upload :http-request="uploadImg" limit="1">
           <template #trigger>
              <el-button type="primary">请选择文件</el-button>
            </template>           
            <template #tip><div class="el-upload__tip">jpg/png files with a size less than 500kb </div></template>
        </el-upload> -->
                <el-upload :http-request="uploadImg"  class="avatar-uploader" limit="1" :show-file-list="false">
                     <el-image  style="width: 200px; height: 200px"  v-if="teacherData.pic" :src="`http://192.168.77.51:90/images/${teacherData.pic}`" class="avatar" />
                     <el-icon v-else class="avatar-uploader-icon">
                      <Plus />
                      </el-icon>
                 </el-upload>
                </el-form-item>
                <el-form-item label="出生日期">
                    <el-col :span="11">
                        <el-date-picker value-format="YYYY-MM-DD" v-model="teacherData.birthday" type="date"
                            placeholder="Pick a date" style="width: 100%" />
                    </el-col>
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
import { onMounted, ref } from "vue"
import { ElMessage, ElMessageBox } from "element-plus"
import request from "@/utils/request.js"

const tableRowClassName = () => {}
const handleClose = () => { clear() }
const list = ref([])  //声明响应式数据
const searchData = ref({    //searchData
    tno: '',
    tname: ''
})
const selected = ref([])  //声明响应式数据
const teacherData = ref({  //声明响应式数据
    tno: '',
    tname: '',
    sex: '男',
    birthday: '',
    pic: '',
    createDate: ''
})
// 分页参数
const pageData = ref({
    pageNum: 1,
    pageSize: 6,
})
// 数据总条数
const total = ref(0)
const dialogVisible = ref(false)//对话框默认不显示
const typeTile = ref()  //声明响应式变量 判断是新增还修改
// 切换页码
const handleCurrentChange = (newPage) => {
    pageData.value.pageNum = newPage
    getList()
}
//数据列表
const getList = async () => {                //定义请求异步请求函数   
    // const res = await request.post('/teacher/list', searchData.value)    
    // list.value = res.data    //给typeList对象赋值
    request({
        url: '/teacher/list',
        method: 'POST',
        data: searchData.value,
        params: {
            pageNum: pageData.value.pageNum,
            pageSize: pageData.value.pageSize
        }
    }).then(res => {
        list.value = res.data.records
        total.value = res?.data.total
    })
}

//清空查询条件
const clearData = async () => {                //定义请求异步请求函数
    searchData.value = {
        tno: '',
        tname: ''
    }
}
//删除单条数据
const delRow = (id) => {
    ElMessageBox.confirm('您确认要删除此数据吗？', '警告！', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
        .then(async () => {
            const res = await request.delete(`/teacher/delete/${id}`)
            if (res === 200) {
                ElMessage({ type: 'success', message: '删除成功' })
            }
            await getList()
        })
        .catch(() => { ElMessage({ type: 'info', message: '取消删除' }) })
}
// 批量删除数据---获取选择编号
const handleSelectionChange = (val) => {
    selected.value = val
}
//批量删除数据
const deleteSelected = async () => {
    ElMessageBox.confirm('您确定要批量删除这些数据吗？', "警告！", { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
        .then(async () => {
            const ids = selected.value.map(item => item.tno)
            const res = await request.post('/teacher/deleteBatch', ids)
            if (res.data) {
                ElMessage({ type: 'success', message: '删除成功！', })
                await getList()//调用数据列表方法刷新前端页面
            }
        })
        .catch(() => {
            ElMessage({ type: 'info', message: '取消删除' })
        })
}
//判断点击是“新增”还是“修改”按钮，如果是修改按钮，取到这一条数据的编号，
const showDialog = (type, id) => {
    if (type == 'add') {
        typeTile.value = '新增'
    } else {
        typeTile.value = '修改'
        request({
            url: `/teacher/findById/${id}`,  //调用后端接口findById方法,把返回的数据存放到表单对应的元素中显示
            method: 'GET',
        }).then(res => {
            teacherData.value = res.data
            console.log(res);
        })
    }
    dialogVisible.value = true
}
//新增或修改数据
const submit = async () => {
    if (typeTile.value == "新增") {
        const res = await request.post("/teacher/add", teacherData.value);
        if (res.code === 200) {
            ElMessage({ type: "success", message: "新增成功", });
            await getList();
        }
        teacherData.value = {
            tno: '',
            tname: '',
            sex: '',
            birthday: '',
            pic: '',
            createDate: ''
        };
    } else {
        const res = await request.put("/teacher/update", teacherData.value);
        if (res.code === 200) {
            ElMessage({ type: "success", message: "修改成功", });
            await getList();
        }
        teacherData.value = {
            tno: '',
            tname: '',
            sex: '',
            birthday: '',
            pic: '',
            createDate: ''
        };
    }
    await getList();
    dialogVisible.value = false;
};

//点击对话框中的“取消”按钮清空内存数据
const clear = () => {
    teacherData.value = {
        tno: '',
        tname: '',
        sex: '',
        birthday: '',
        pic: '',
        createDate: ''
    }
    dialogVisible.value = false
}
//文件上传
const uploadImg = async (fileData) => {
    const { file } = fileData;
    console.log(file);
    const fdata = new FormData();
    fdata.append("file", file);
    const res = await request({
        method: "post",
        url: "/teacher/upload",
        data: fdata,
        headers: { "Content-Type": "multipart/form-data" },
    });
    if (res.code == 200) {
        ElMessage({
            type: "success",
            message: "文件上传成功",
        });
        teacherData.value.pic = res.data;
    }
};
// 文件下载
const downloadImage = async (fileName) => {
    console.log("fileName", fileName);
    try {
        // 调用后端API下载图片
        const response = await request({
            method: "get",
            url: "/teacher/download", // 后端接口
            params: {
                fileName: fileName, // 传递图片文件名给后端
            },
            responseType: "blob",
        });
        let blob = new Blob([response], { type: "application/octet-stream" }); // 为blob设置文件类型，这里以.xlsx为例
        // let nowDate = new Date();
        // let fileDate = nowDate.getFullYear() + "-" + (nowDate.getMonth() + 1) + "-" + nowDate.getDate();
        // let filename = "教师信息导出" + fileDate + ".png"; // 指定您想要的文件名
        let url = window.URL.createObjectURL(blob); // 创建一个临时的url指向blob对象
        let a = document.createElement("a");
        a.href = url;
        a.download = fileName; // 设置下载文件名
        a.click(); // 触发点击下载
        // 下载完成后释放这个临时的对象url
        setTimeout(() => {
            window.URL.revokeObjectURL(url);
        }, 0);
    } catch (error) {
        console.error("下载图片时出错:", error);
    }
};

//声明钩子函数
onMounted(() => {
    getList()
})  
</script>
<style scoped>
:deep(.el-pagination) {
    justify-content: center;
}
</style>