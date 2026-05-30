package com.hngc.pojo;
import lombok.Data;
@Data
public class Shop {
    private Long id;
    private String shop_name;
    private String shop_avatar;
    private String shop_desc;
    private Long merchant_id;
    private Long category_id;
    private Integer shop_status;
    private String address;
    private String contact_phone;
    private String contact_email;
    private String business_license;
    private Double avg_score;
    private Long sale_count;
    private Long favorites_count;
    private String create_time;
    private String update_time;
    private Integer deleted;
}