package com.hngc.service;
import com.hngc.pojo.Category;
import java.util.List;
public interface CategoryService {
    public List<Category> list(Category category);//查询数据
    public Category findById(Integer id);//定义方法，供控制层调用
    public Category getProductByCategory(Integer id);//通过类型id获取商品类型及类型下面商品信息
    public int save(Category category);//添加一条数据
    public int delete(Integer id);//删除一条数据
    public int update(Category category);//修改一条数据
}
