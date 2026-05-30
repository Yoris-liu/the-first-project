package com.hngc.service;
import com.github.pagehelper.PageInfo;
import com.hngc.pojo.Product;
import java.util.List;
public interface ProductService {
    public PageInfo<Product> list(Product product,Integer pageNum,Integer pageSize);
    public Product findById(Integer id);
    public int save(Product product);
    public int delete(Integer id);
    public int update(Product product);
}