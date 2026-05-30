package com.hngc.controller;
import com.github.pagehelper.PageInfo;
import com.hngc.common.Result;
import com.hngc.pojo.OrderItem;
import com.hngc.service.OrderItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/ordersItems")
@CrossOrigin
public class OrderItemController {
    @Autowired
    private OrderItemService orderItemService;

    @PostMapping("/list")
    public Result<PageInfo<OrderItem>> list(@RequestBody OrderItem orderItem, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "5") Integer pageSize){
        return Result.success(orderItemService.list(orderItem, pageNum, pageSize));
    }

    @GetMapping("/findById")
    public Result<OrderItem> findById(@RequestParam Long id){
        return Result.success(orderItemService.findById(id));
    }

    /**
     * 根据订单ID查询订单明细
     */
    @GetMapping("/findOrdersByOid")
    public Result<List<OrderItem>> findByOrderId(@RequestParam Long id){
        OrderItem param = new OrderItem();
        param.setOrder_id(id);
        return Result.success(orderItemService.list(param));
    }

    @PostMapping("/add")
    public Result add(@RequestBody OrderItem orderItem){
        if(orderItemService.save(orderItem)>0){
            return Result.success();
        }else{
            return Result.error("添加失败");
        }
    }

    @PutMapping("/update")
    public Result update(@RequestBody OrderItem orderItem){
        if(orderItemService.update(orderItem)>0){
            return Result.success();
        }else{
            return Result.error("修改失败");
        }
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id){
        if(orderItemService.delete(id)>0){
            return Result.success();
        }else{
            return Result.error("删除失败");
        }
    }

    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<Long> ids){
        int count = 0;
        for(Long id : ids){
            count += orderItemService.delete(id);
        }
        if(count > 0){
            return Result.success();
        }else{
            return Result.error("批量删除失败");
        }
    }
}
