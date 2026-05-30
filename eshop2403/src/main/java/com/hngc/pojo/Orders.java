package com.hngc.pojo;
import lombok.Data;
@Data
public class Orders {
    private Long order_id;
    private String order_no;
    private Integer user_id;
    private Long shop_id;
    private Integer order_status;
    private Integer pay_type;
    private Double total_price;
    private Double pay_price;
    private String receiver_name;
    private String receiver_phone;
    private String receiver_address;
    private String pay_time;
    private String delivery_time;
    private String receive_time;
    private String create_time;
    private String update_time;
    private Users users;//定义对象
}