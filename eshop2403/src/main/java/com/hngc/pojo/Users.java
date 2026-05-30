package com.hngc.pojo;
import lombok.Data;
import java.util.List;
@Data
public class Users {
    private Integer user_id;
    private String username;
    private String password;
    private String phone;
    private String email;
    private String real_name;
    private String gender;
    private String birthday;
    private Integer status;
    private String create_time;
    private String update_time;
    private List<Orders> orders;//定义对象
}
