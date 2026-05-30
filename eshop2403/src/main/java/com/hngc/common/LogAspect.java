package com.hngc.common;
import com.alibaba.fastjson.JSON;
import com.hngc.pojo.Log;
import com.hngc.service.LogService;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
@Aspect
@Component
public class LogAspect {
    @Autowired
    private LogService logService;//定义业务逻辑层对象
    @Autowired
    private HttpServletRequest request; // 注入请求对象
    /**
     * 调用业务逻辑层忘日志表中添加一条日志信息
     * @return
     */
    @Around("@annotation(LogAnnotation)")//环绕通知
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();// 获取注解
        LogAnnotation logAnnotation = signature.getMethod().getAnnotation(LogAnnotation.class);
        Log log=new Log();//构造对象
        log.setUsername("admin");//取登录用户名
        log.setIp(getClientIp(request));//获取操作电脑的IP
        log.setOperate_module(logAnnotation.module());//模块名称
        log.setOperate_time(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));//操作时间
        log.setClass_name(joinPoint.getTarget().getClass().getName());//类名
        log.setMethod_name(signature.getMethod().getName());//方法名
        log.setMethod_params(JSON.toJSONString(joinPoint.getArgs()));//参数名
        // 执行方法
        Object result = null;
        try {
            result = joinPoint.proceed();
            log.setReturn_value(JSON.toJSONString(result));//返回值
        } catch (Exception e) {
            log.setReturn_value("异常：" + e.getMessage());
            throw e;
        } finally {
            logService.save(log);//调用业务逻辑层方法向日志表中添加一条数据
        }
        return result;
    }
    /**
     * 获取客户端真实IP地址
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多级代理时取第一个IP
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return "0:0:0:0:0:0:0:1".equals(ip) ? "127.0.0.1" : ip;
    }
}
