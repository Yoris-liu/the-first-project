package com.hngc.service;
import com.hngc.mapper.CategoryDao;
import com.hngc.pojo.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service //告诉spring，我是你的业务逻辑层
public class CategoryServiceImpl implements CategoryService{
    @Autowired  //自动装配，创建一个对象
    private CategoryDao categoryDao;
    @Override
    public List<Category> list(Category category) {
        return categoryDao.findAll(category);//调用数据访问层接口查询所有数据
    }
    @Override
    public Category findById(Integer id) {
        return categoryDao.findById(id);//调用数据访问层接口查询一条数据
    }
    @Override
    public Category getProductByCategory(Integer id) {
        return categoryDao.getProductByCategory(id);//调用数据访问层接口查询数据
    }
    @Override
    public int save(Category category) {
        return categoryDao.save(category);//调用数据访问层接口保存一条数据
    }
    @Override
    public int delete(Integer id) {
        return categoryDao.delete(id);//调用数据访问层接口删除一条数据
    }
    @Override
    public int update(Category category) {
        return categoryDao.update(category);//调用数据访问层接口修改一条数据
    }
}
