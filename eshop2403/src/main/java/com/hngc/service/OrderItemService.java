package com.hngc.service;
import com.github.pagehelper.PageInfo;
import com.hngc.pojo.OrderItem;
import java.util.List;
public interface OrderItemService {
    public List<OrderItem> list(OrderItem orderItem);
    public PageInfo<OrderItem> list(OrderItem orderItem, Integer pageNum, Integer pageSize);
    public OrderItem findById(Long id);
    public int save(OrderItem orderItem);
    public int delete(Long id);
    public int update(OrderItem orderItem);
}