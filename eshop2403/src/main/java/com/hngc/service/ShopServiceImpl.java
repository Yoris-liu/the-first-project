package com.hngc.service;
import com.hngc.mapper.ShopDao;
import com.hngc.pojo.Shop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class ShopServiceImpl implements ShopService {
    @Autowired
    private ShopDao shopDao;
    @Override
    public List<Shop> list(Shop shop) {
        return shopDao.findAll(shop);
    }
    @Override
    public Shop findById(Long id) {
        return shopDao.findById(id);
    }
    @Override
    public int save(Shop shop) {
        return shopDao.save(shop);
    }
    @Override
    public int delete(Long id) {
        return shopDao.delete(id);
    }
    @Override
    public int update(Shop shop) {
        return shopDao.update(shop);
    }
}