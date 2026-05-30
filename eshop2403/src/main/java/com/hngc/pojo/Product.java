package com.hngc.pojo;
import lombok.Data;
@Data
public class Product {
    private Integer product_id;
    private String product_name;
    private String product_code;
    private Integer category_id;
    private String subtitle;
    private Double price;
    private Double original_price;
    private Integer stock_num;
    private Integer status;
    private String image_url;
    private Integer sales_num;
    private String create_time;
    private String update_time;
    private Category category;//定义一的一端对象
}