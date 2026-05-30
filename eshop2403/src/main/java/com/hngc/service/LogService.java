package com.hngc.service;
import com.hngc.pojo.Log;
import java.util.List;
public interface LogService {
    public List<Log> list();//查询数据
    public int save(Log log);//添加数据
}
