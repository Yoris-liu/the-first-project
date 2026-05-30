package com.hngc.controller;
import com.github.pagehelper.PageInfo;
import com.hngc.common.Result;
import com.hngc.pojo.Product;
import com.hngc.service.ProductService;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

//@Controller //标识控制层注解
//@ResponseBody //返回JSON数据给前端
@RestController//标识控制层和返回JSON数据的组合注解
@RequestMapping("/product") //加一级访问目录
@CrossOrigin //跨域
public class ProductController {
    @Autowired//装配对象
    private ProductService productService;//定义业务逻辑层对象
    /**
     * 查询数据
     * @return
     */
//    @RequestMapping("/list") //加访问地址，支持前端发送的所有请求
    @PostMapping("/list") //加访问地址，支持前端发送的Post请求
    public Result<PageInfo<Product>> list(@RequestBody Product product,@RequestParam(defaultValue = "1")
            Integer pageNum,@RequestParam(defaultValue = "5")Integer pageSize){   //返回封装以后的结果给前端
        return Result.success(productService.list(product,pageNum,pageSize));//调用业务逻辑层方法
    }
    /**
     * 删除数据
     */
    @DeleteMapping("/delete/{id}") //加访问地址，支持前端发送Delete,请求路径参数
    public Result delete(@PathVariable Integer id){  //@PathVariable  路径参数注解
        if(productService.delete(id)>0){   //调用各业务逻辑层方法删除数据
            return Result.success();
        }else{
            return Result.error("删除失败");
        }
    }
    /**
     * 根据ID查询
     */
    @GetMapping("/findById")
    public Result<Product> findById(@RequestParam Integer id){
        return Result.success(productService.findById(id));
    }
    /**
     * 添加数据
     */
    @PostMapping("/add")
    public Result add(@RequestBody Product product){
        if(productService.save(product)>0){
            return Result.success();
        }else{
            return Result.error("添加失败");
        }
    }
    /**
     * 修改数据
     */
    @PutMapping("/update")
    public Result update(@RequestBody Product product){
        if(productService.update(product)>0){
            return Result.success();
        }else{
            return Result.error("修改失败");
        }
    }
    /**
     * 批量删除
     */
    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<Integer> ids){
        int count=0;
        for(Integer id:ids){
            count+=productService.delete(id);
        }
        if(count>0){
            return Result.success();
        }else{
            return Result.error("批量删除失败");
        }
    }
    /**
     * 文件上传
     * @param file
     * @return
     */
    @PostMapping("/upload")
    public Result<String> upload(MultipartFile file, HttpServletRequest request){
        // 1. 判断文件是否为空
        if (file.isEmpty()) {
            return Result.error("上传文件不能为空");
        }
        try {
            // 2. 获取文件原始名称
            String originalFilename = file.getOriginalFilename();
            // 3. 生成唯一文件名（防止重名覆盖）
            String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
//            String newFileName = UUID.randomUUID().toString() + suffix;
            String newFileName = new SimpleDateFormat("yyyyMMdd").format(new Date())+new Random().nextInt(1000) + suffix;
            // 4. 设置上传路径（项目根目录下的 upload 文件夹）
            String realPath = request.getServletContext().getRealPath("/images/");
            File folder = new File(realPath);
            if (!folder.exists()) {
                folder.mkdirs(); // 创建目录
            }
            // 5. 写入文件
            File targetFile = new File(folder, newFileName);
            file.transferTo(targetFile);
            // 6. 返回可访问的文件地址
//            String fileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
//                    + "/ehsop2403/images/" + newFileName;
            return Result.success(newFileName);
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("文件上传失败：" + e.getMessage());
        }
    }
    /**
     * 多文件上传
     * @param files
     * @param request
     * @return
     */
    @PostMapping("/uploadBatch")
    public Result<List<String>> uploadBatch(@RequestParam("files") MultipartFile[] files,HttpServletRequest request){
        if(files==null || files.length==0){
            return Result.error("请选择上传文件！");
        }
        String realPath=request.getServletContext().getRealPath("/images/");
        File filePath=new File(realPath);
        if(!filePath.exists()){
            filePath.mkdirs();
        }
        // 存储所有成功上传的文件名
        List<String> successFileNames = new ArrayList<>();
        try{
            for(MultipartFile file:files){
                // 2. 获取文件原始名称
                String originalFilename = file.getOriginalFilename();
                // 3. 生成唯一文件名（防止重名覆盖）
                String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
                String newFileName = new SimpleDateFormat("yyyyMMdd").format(new Date())+new Random().nextInt(1000) + suffix;
                file.transferTo(new File(filePath+File.separator+newFileName));
                // 添加到成功列表
                successFileNames.add(newFileName);
            }
           return Result.success(successFileNames);
        }catch (Exception e){
            e.printStackTrace();
           return Result.error("文件上传失败！");
        }
    }
    /**
     * 文件下载
     * @return
     */
    // 商品图片下载接口
    //文件下载
    @GetMapping("/download") //或使用@GetMapping("/download")
    public ResponseEntity<byte[]> downloadProduct(String fileName, HttpServletRequest request) throws IOException{
        String realPath=request.getServletContext().getRealPath("/images/");
        fileName=new String(fileName.getBytes("ISO-8859-1"),"UTF-8");//处理乱码
        File file=new File(realPath+File.separator+fileName);//创建文件操作对象
        HttpHeaders headers=new HttpHeaders();//设置文件头
        headers.setContentDispositionFormData("attachment",fileName);//出现另存为
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);//以二进制流的形式打开
        return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(file),headers, HttpStatus.OK);//返回
    }
}
