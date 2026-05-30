package com.hngc.controller;
import com.hngc.common.Result;
import com.hngc.pojo.Shop;
import com.hngc.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
//@Controller //标识控制层注解
//@ResponseBody //返回JSON数据给前端
@RestController//标识控制层和返回JSON数据的组合注解
@RequestMapping("/shop") //加一级访问目录
@CrossOrigin //跨域
public class ShopController {
    @Autowired//装配对象
    private ShopService shopService;//定义业务逻辑层对象
    /**
     * 查询数据
     * @return
     */
//    @RequestMapping("/list") //加访问地址，支持前端发送的所有请求
    @GetMapping("/list") //加访问地址，支持前端发送的Get请求
    public Result<List<Shop>> list(){   //返回封装以后的结果给前端
        return Result.success(shopService.list(null));//调用业务逻辑层方法
    }
    /**
     * 删除数据
     */
    @DeleteMapping("/delete/{id}") //加访问地址，支持前端发送Delete,请求路径参数
    public Result delete(@PathVariable Long id){  //@PathVariable  路径参数注解
        if(shopService.delete(id)>0){   //调用各业务逻辑层方法删除数据
            return Result.success();
        }else{
            return Result.error("删除失败");
        }
    }
    /**
     * 根据ID查询
     */
    @GetMapping("/findShopById")
    public Result<Shop> findById(@RequestParam Long id){
        return Result.success(shopService.findById(id));
    }
    /**
     * 添加数据
     */
    @PostMapping("/addShop")
    public Result add(@RequestBody Shop shop){
        if(shopService.save(shop)>0){
            return Result.success();
        }else{
            return Result.error("添加失败");
        }
    }
    /**
     * 修改数据
     */
    @PutMapping("/updateShop")
    public Result update(@RequestBody Shop shop){
        if(shopService.update(shop)>0){
            return Result.success();
        }else{
            return Result.error("修改失败");
        }
    }
    /**
     * 批量删除
     */
    @PostMapping("/deleteBatchShop")
    public Result deleteBatch(@RequestBody List<Long> ids){
        int count=0;
        for(Long id:ids){
            count+=shopService.delete(id);
        }
        if(count>0){
            return Result.success();
        }else{
            return Result.error("批量删除失败");
        }
    }
}
