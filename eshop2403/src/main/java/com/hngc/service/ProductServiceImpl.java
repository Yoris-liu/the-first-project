package com.hngc.service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hngc.mapper.ProductDao;
import com.hngc.pojo.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class ProductServiceImpl implements ProductService {
    @Autowired
    private ProductDao productDao;
    @Override
    public PageInfo<Product> list(Product product,Integer pageNum,Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);// 开启分页（必须写在查询前面）
        List<Product> list = productDao.findAll(product);// 查询全部，插件自动分页
        return new PageInfo<>(list);// 封装成分页对象
    }
    @Override
    public Product findById(Integer id) {
        return productDao.findById(id);
    }
    @Override
    public int save(Product product) {
        return productDao.save(product);
    }
    @Override
    public int delete(Integer id) {
        return productDao.delete(id);
    }
    @Override
    public int update(Product product) {
        return productDao.update(product);
    }
}