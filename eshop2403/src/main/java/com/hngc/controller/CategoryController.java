package com.hngc.controller;
import com.hngc.common.Result;
import com.hngc.pojo.Category;
import com.hngc.service.CategoryService;
import com.hngc.util.TreeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
@RestController
@RequestMapping("/category")
@CrossOrigin
public class CategoryController {
    @Autowired
    private CategoryService categoryService;
    @GetMapping("/list")
    public Result<List<Category>> list(){
        return Result.success(categoryService.list(null));
    }
    @GetMapping("/tree")
    public Result<List<Category>> getTree(){
        List<Category> list1 = categoryService.list(null);
        return Result.success(TreeUtil.buildTree(list1));
    }
    /**
     * 根据ID查询
     */
    @GetMapping("/findById")
    public Result<Category> findById(@RequestParam Integer id){
        return Result.success(categoryService.findById(id));
    }
    /**
     * 添加数据
     */
    @PostMapping("/add")
    public Result add(@RequestBody Category category){
        if(categoryService.save(category)>0){
            return Result.success();
        }else{
            return Result.error("添加失败");
        }
    }
    /**
     * 修改数据
     */
    @PutMapping("/update")
    public Result update(@RequestBody Category category){
        if(categoryService.update(category)>0){
            return Result.success();
        }else{
            return Result.error("修改失败");
        }
    }
    /**
     * 删除数据
     */
    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id){
        if(categoryService.delete(id)>0){
            return Result.success();
        }else{
            return Result.error("删除失败");
        }
    }
}
