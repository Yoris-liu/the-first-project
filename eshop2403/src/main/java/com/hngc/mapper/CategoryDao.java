package com.hngc.mapper;
import com.hngc.pojo.Category;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper //告诉spring，我是你的数据访问层
public interface CategoryDao {
    public List<Category> findAll(Category category);//查询数据
    public Category findById(Integer id);//通过编号查询一条数据
    public Category getProductByCategory(Integer id);//通过类型id获取商品类型及类型下面商品信息
    public int save(Category category);//添加一条数据
    public int delete(Integer id);//删除一条数据
    public int update(Category category);//修改一条数据
}
