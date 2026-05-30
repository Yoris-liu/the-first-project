package com.hngc.service;
import com.github.pagehelper.PageInfo;
import com.hngc.pojo.Orders;
import java.util.List;
public interface OrdersService {
    public List<Orders> list(Orders orders);
    public PageInfo<Orders> list(Orders orders, Integer pageNum, Integer pageSize);
    public Orders findById(Long id);
    public int save(Orders orders);
    public int delete(Long id);
    public int update(Orders orders);
}