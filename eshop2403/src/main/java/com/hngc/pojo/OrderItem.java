package com.hngc.pojo;
import lombok.Data;
@Data
public class OrderItem {
    private Long item_id;
    private Long order_id;
    private Integer product_id;
    private String product_name;
    private Double product_price;
    private Integer buy_num;
    private String create_time;
}