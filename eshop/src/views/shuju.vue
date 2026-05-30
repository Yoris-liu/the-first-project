<template>
	<div id="main1" style="width: 100%;height: 200px;"></div>
	<div id="main2" style="width: 100%;height: 200px;"></div>
</template>
<script setup>
import { onMounted, ref} from 'vue'     //引入vue
import request from '@/utils/request.js'  //引入请求基地址	
import * as echarts from 'echarts'
//数据列表
const init1 = async () => {                //定义请求异步请求函数
    let chartDom = document.getElementById('main1')
				let mychart = echarts.init(chartDom)
				let option = {
					tooltip:{},
					xAxis:{
						type:'category',
						data:['2023-01','2023-02','2023-03','2023-04','2023-05','2023-06']
					},
					yAxis:{
						type:'value'
						
					},
					series:[{
						name: "充电量",
						type: "bar",
						data: [1,2,3,4,5,6]
					},
					{
						name: "花费",
						type: "bar",
						data: [11,22,33,44,55,66]
					},
					{
						name:'充电次数',
						type:"bar",
						data:[10,20,30,40,50,60]
					}
					]
				}
				mychart.setOption(option)
}
const init2 = async () => {                //定义请求异步请求函数
				let chartDom = document.getElementById('main2')
				let mychart = echarts.init(chartDom)
				let option ={
					tooltip:{},
					xAxis:{
						type:'category',
						data:['2023-03','2023-05']
					},
					yAxis:{
						type:'value'
					},
					series:[
						{
							name:'耗电量',
							type:'line',
							data:[30,40]
						},
						{
							name:'行驶里程',
							type:'line',
							data:[300,400]
						},
						{
							name:'平均百公里耗电量',
							type:'line',
							data:[3,4]
						}
					]
				}
				mychart.setOption(option)			
}
onMounted(() => {     
    init1()
    init2()
})
</script>