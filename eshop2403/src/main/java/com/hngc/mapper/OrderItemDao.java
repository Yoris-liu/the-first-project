package com.hngc.mapper;
import com.hngc.pojo.OrderItem;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper
public interface OrderItemDao {
    public List<OrderItem> findAll(OrderItem orderItem);
    public OrderItem findById(Long id);
    public int save(OrderItem orderItem);
    public int delete(Long id);
    public int update(OrderItem orderItem);
}