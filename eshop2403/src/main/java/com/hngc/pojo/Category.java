package com.hngc.pojo;
import lombok.Data;
import java.util.List;
@Data
public class Category {
    private Integer category_id;
    private String category_name;
    private String category_code;
    private Integer parent_id;
    private Integer sort_num;
    private Integer status;
    private String create_time;
    private String update_time;
    private List<Product> products;//定义多的一端对象
    private List<Category> children;//类型下面有子类型
}
