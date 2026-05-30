package com.hngc.service;
import com.hngc.pojo.Shop;
import java.util.List;
public interface ShopService {
    public List<Shop> list(Shop shop);
    public Shop findById(Long id);
    public int save(Shop shop);
    public int delete(Long id);
    public int update(Shop shop);
}