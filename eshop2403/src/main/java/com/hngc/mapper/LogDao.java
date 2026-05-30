package com.hngc.mapper;
import com.hngc.pojo.Log;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
@Mapper
public interface LogDao {
    public List<Log> findAll();//查询日志
    public int save(Log log);//保存数据
}
