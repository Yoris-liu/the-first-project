package com.hngc.mapper;
import com.hngc.pojo.Product;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper
public interface ProductDao {
    public List<Product> findAll(Product product);
    public Product findById(Integer id);
    public int save(Product product);
    public int delete(Integer id);
    public int update(Product product);
}