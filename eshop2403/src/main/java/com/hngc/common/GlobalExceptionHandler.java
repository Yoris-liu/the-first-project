package com.hngc.common;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
@RestControllerAdvice
public class GlobalExceptionHandler {
    // 1. 处理空指针异常（具体异常）
    @ExceptionHandler(NullPointerException.class)
    public Result handleNullPointerException(NullPointerException e) {
        // 打印异常信息（便于开发调试）
        e.printStackTrace();
        // 返回规范的JSON响应
        return Result.error("空指针异常：对象或参数不能为空");
    }
    // 2. 处理参数异常（拓展，可选）
    @ExceptionHandler(IllegalArgumentException.class)
    public Result handleIllegalArgumentException(IllegalArgumentException e) {
        e.printStackTrace();
        return Result.error("参数异常：" + e.getMessage());
    }
    // 3. 处理所有异常（兜底，通用异常）
    @ExceptionHandler(Exception.class)
    public Result handleException(Exception e) {
        e.printStackTrace();
        return Result.error("服务器异常，请稍后再试：" + e.getMessage());
    }

}
