package com.hngc.controller;
import com.github.pagehelper.PageInfo;
import com.hngc.common.JWTUtil;
import com.hngc.common.Result;
import com.hngc.pojo.Users;
import com.hngc.service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@RestController  //返回JSON数据
@RequestMapping("/users")//加访问目录
@CrossOrigin //跨域
public class UsersController {
    @Autowired  //注入对象
    private UsersService usersService;
    /**
     * 查询用户信息
     * @return
     */
    @PostMapping("/list")
    public Result<PageInfo<Users>> list(@RequestBody Users users,@RequestParam(defaultValue = "1")
            Integer pageNum,@RequestParam(defaultValue = "5")Integer pageSize){
        return Result.success(usersService.list(users,pageNum,pageSize));
    }
    /**
     * 用户登录
     * @param users
     * @return
     */
    @PostMapping("/login")
    public Result<String> login(@RequestBody Users users){
        if(usersService.login(users)!=null) {
            Map<String, String> payload = new HashMap<>();
            payload.put("username", users.getUsername());
            String token = JWTUtil.getToken(payload);
            return Result.success(token); //token返回给前端
        }else{
            return Result.error("用户名或密码错误");
        }
//        if(usersService.login(users)!=null){
//            session.setAttribute("loginUser",users);//存入session对象
//            return Result.success(users.getUsername());
//        }else{
//            return Result.error("用户名或密码错误");
//        }
    }
    /**
     * 根据ID查询
     */
    @GetMapping("/findById")
    public Result<Users> findById(@RequestParam Integer id){
        return Result.success(usersService.findById(id));
    }
    /**
     * 添加数据
     */
    @PostMapping("/add")
    public Result add(@RequestBody Users users){
        if(usersService.save(users)>0){
            return Result.success();
        }else{
            return Result.error("添加失败");
        }
    }
    /**
     * 修改数据
     */
    @PutMapping("/update")
    public Result update(@RequestBody Users users){
        if(usersService.update(users)>0){
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
        if(usersService.delete(id)>0){
            return Result.success();
        }else{
            return Result.error("删除失败");
        }
    }
    /**
     * 批量删除
     */
    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<Integer> ids){
        int count=0;
        for(Integer id:ids){
            count+=usersService.delete(id);
        }
        if(count>0){
            return Result.success();
        }else{
            return Result.error("批量删除失败");
        }
    }
}
