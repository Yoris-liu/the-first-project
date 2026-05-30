package com.hngc.mapper;
import com.hngc.pojo.Shop;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper
public interface ShopDao {
    public List<Shop> findAll(Shop shop);
    public Shop findById(Long id);
    public int save(Shop shop);
    public int delete(Long id);
    public int update(Shop shop);
}