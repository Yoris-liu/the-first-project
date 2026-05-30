package com.hngc.service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hngc.mapper.OrdersDao;
import com.hngc.pojo.Orders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class OrdersServiceImpl implements OrdersService {
    @Autowired
    private OrdersDao ordersDao;
    @Override
    public List<Orders> list(Orders orders) {
        return ordersDao.findAll(orders);
    }
    @Override
    public PageInfo<Orders> list(Orders orders, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersDao.findAll(orders);
        return new PageInfo<>(list);
    }
    @Override
    public Orders findById(Long id) {
        return ordersDao.findById(id);
    }
    @Override
    public int save(Orders orders) {
        return ordersDao.save(orders);
    }
    @Override
    public int delete(Long id) {
        return ordersDao.delete(id);
    }
    @Override
    public int update(Orders orders) {
        return ordersDao.update(orders);
    }
}