package com.hngc.service;
import com.hngc.mapper.LogDao;
import com.hngc.pojo.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class LogServiceImpl implements LogService{
    @Autowired
    private LogDao logDao;
    @Override
    public List<Log> list() {
        return logDao.findAll();//调用数据访问层方法查询数据
    }
    @Override
    public int save(Log log) {
        return logDao.save(log);//调用数据访问层方法添加数据
    }
}
