package com.hngc.common;

public class Result<T> {
    private int code; //状态码  200=成功，500=失败，401=未登录
    private String msg; //提示消息 给前端程序员看的提示信息：操作成功，用户名不存在
    private T data;//返回给前端的数据，可以是对象，集合、字符串等
    /**
     * 查询数据
     * @param data
     * @param <T>
     * @return
     */
    public static <T> Result<T> success(T data){
        Result<T> result=new Result<>();
        result.setCode(200);
        result.setMsg("操作成功");
        result.setData(data);
        return result;
    }

    /**
     * 返回结果（不带数据）   添加，删除，修改
     * @param <T>
     * @return
     */
    public static <T> Result<T> success(){
        Result<T> result=new Result<>();
        result.setCode(200);
        result.setMsg("操作成功");
        return result;
    }
    /**
     * 失败返回（默认状态码）
     * @param msg
     * @param <T>
     * @return
     */
    public static <T> Result<T> error(String msg){
        Result<T> result=new Result<>();
        result.setCode(500);
        result.setMsg(msg);
        return result;
    }
    /**
     * 失败返回（自定义状态码）
     * @param msg
     * @param <T>
     * @return
     */
    public static <T> Result<T> error(int code,String msg){
        Result<T> result=new Result<>();
        result.setCode(code);
        result.setMsg(msg);
        return result;
    }
    public int getCode() {
        return code;
    }
    public void setCode(int code) {
        this.code = code;
    }
    public String getMsg() {
        return msg;
    }
    public void setMsg(String msg) {
        this.msg = msg;
    }
    public T getData() {
        return data;
    }
    public void setData(T data) {
        this.data = data;
    }
}
