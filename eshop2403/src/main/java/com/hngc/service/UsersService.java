package com.hngc.service;
import com.github.pagehelper.PageInfo;
import com.hngc.pojo.Users;
import java.util.List;
public interface UsersService {
    public PageInfo<Users> list(Users users,Integer pageNum,Integer pageSize);//查询数据
    public Users findById(Integer id);//定义方法，供控制层调用
    public Users getOrdersByUsers(String username);//通过用户名查询用户及用户订单
    public int save(Users users);//添加一条数据
    public int delete(Integer id);//删除一条数据
    public int update(Users users);//修改一条数据
    public Users login(Users users);//用户登录验证
}
