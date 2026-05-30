package com.hngc.controller;
import com.github.pagehelper.PageInfo;
import com.hngc.common.Result;
import com.hngc.pojo.Orders;
import com.hngc.service.OrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/orders")
@CrossOrigin
public class OrdersController {
    @Autowired
    private OrdersService ordersService;

    @PostMapping("/list")
    public Result<PageInfo<Orders>> list(@RequestBody Orders orders, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "5") Integer pageSize){
        return Result.success(ordersService.list(orders, pageNum, pageSize));
    }

    @GetMapping("/findOrders")
    public Result<List<Orders>> list(){
        return Result.success(ordersService.list(null));
    }

    @GetMapping("/findById")
    public Result<Orders> findById(@RequestParam Long id){
        return Result.success(ordersService.findById(id));
    }

    @PostMapping("/add")
    public Result add(@RequestBody Orders orders){
        if(ordersService.save(orders)>0){
            return Result.success();
        }else{
            return Result.error("添加失败");
        }
    }

    @PutMapping("/update")
    public Result update(@RequestBody Orders orders){
        if(ordersService.update(orders)>0){
            return Result.success();
        }else{
            return Result.error("修改失败");
        }
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id){
        if(ordersService.delete(id)>0){
            return Result.success();
        }else{
            return Result.error("删除失败");
        }
    }

    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<Long> ids){
        int count = 0;
        for(Long id : ids){
            count += ordersService.delete(id);
        }
        if(count > 0){
            return Result.success();
        }else{
            return Result.error("批量删除失败");
        }
    }
}
