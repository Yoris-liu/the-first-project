package com.hngc.mapper;
import com.hngc.pojo.Users;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper //告诉spring，我是你的数据访问层
public interface UsersDao {
    public List<Users> findAll(Users users);//查询数据
    public Users findById(Integer id);//通过编号查询一条数据
    public Users getOrdersByUsers(String username);//通过用户名查询用户及用户订单
    public int save(Users users);//添加一条数据
    public int delete(Integer id);//删除一条数据
    public int update(Users users);//修改一条数据
    public Users login(Users users);//用户登录
}
