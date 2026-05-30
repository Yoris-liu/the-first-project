package com.hngc.service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hngc.mapper.UsersDao;
import com.hngc.pojo.Product;
import com.hngc.pojo.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service //告诉spring，我是你的业务逻辑层
public class UsersServiceImpl implements UsersService{
    @Autowired  //自动装配，创建一个对象
    private UsersDao usersDao;
    @Override
    public PageInfo<Users> list(Users users,Integer pageNum,Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);// 开启分页（必须写在查询前面）
        List<Users> list = usersDao.findAll(users);// 查询全部，插件自动分页
        return new PageInfo<>(list);// 封装成分页对象
    }
    @Override
    public Users findById(Integer id) {
        return usersDao.findById(id);//调用数据访问层接口查询一条数据
    }

    @Override
    public Users getOrdersByUsers(String username) {
        return usersDao.getOrdersByUsers(username);
    }

    @Override
    public int save(Users users) {
        return usersDao.save(users);//调用数据访问层接口保存一条数据
    }
    @Override
    public int delete(Integer id) {
        return usersDao.delete(id);//调用数据访问层接口删除一条数据
    }
    @Override
    public int update(Users users) {
        return usersDao.update(users);//调用数据访问层接口修改一条数据
    }
    @Override
    public Users login(Users users) {
        return usersDao.login(users);//调用数据访问层方法实现登录验证
    }
}
