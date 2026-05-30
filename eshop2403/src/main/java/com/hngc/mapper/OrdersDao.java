package com.hngc.mapper;
import com.hngc.pojo.Orders;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper
public interface OrdersDao {
    public List<Orders> findAll(Orders orders);
    public Orders findById(Long id);
    public int save(Orders orders);
    public int delete(Long id);
    public int update(Orders orders);
}