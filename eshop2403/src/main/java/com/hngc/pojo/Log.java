package com.hngc.pojo;
import lombok.Data;
@Data
public class Log {
    private long id;
    private String username;
    private String ip;
    private String operate_module;
    private String operate_time;
    private String class_name;
    private String method_name;
    private String method_params;
    private String return_value;
}
