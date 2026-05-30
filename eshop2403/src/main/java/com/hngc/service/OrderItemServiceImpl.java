package com.hngc.service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hngc.mapper.OrderItemDao;
import com.hngc.pojo.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class OrderItemServiceImpl implements OrderItemService {
    @Autowired
    private OrderItemDao orderItemDao;
    @Override
    public List<OrderItem> list(OrderItem orderItem) {
        return orderItemDao.findAll(orderItem);
    }
    @Override
    public PageInfo<OrderItem> list(OrderItem orderItem, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<OrderItem> list = orderItemDao.findAll(orderItem);
        return new PageInfo<>(list);
    }
    @Override
    public OrderItem findById(Long id) {
        return orderItemDao.findById(id);
    }
    @Override
    public int save(OrderItem orderItem) {
        return orderItemDao.save(orderItem);
    }
    @Override
    public int delete(Long id) {
        return orderItemDao.delete(id);
    }
    @Override
    public int update(OrderItem orderItem) {
        return orderItemDao.update(orderItem);
    }
}