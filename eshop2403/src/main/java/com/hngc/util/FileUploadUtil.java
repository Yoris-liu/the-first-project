package com.hngc.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUploadUtil {
    
    // 上传路径，实际项目中应该配置在配置文件中
    private static final String UPLOAD_PATH = "e:\\upload\\product\\";
    
    /**
     * 上传文件
     * @param file 要上传的文件
     * @return 上传后的文件路径
     * @throws IOException  IOException
     */
    public static String upload(MultipartFile file) throws IOException {
        // 检查上传目录是否存在，不存在则创建
        File uploadDir = new File(UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
        String filename = UUID.randomUUID().toString() + suffix;
        
        // 保存文件
        File destFile = new File(UPLOAD_PATH + filename);
        file.transferTo(destFile);
        
        // 返回相对路径，用于存储到数据库
        return "/upload/product/" + filename;
    }
    
    /**
     * 获取完整的文件路径
     * @param relativePath 相对路径
     * @return 完整的文件路径
     */
    public static String getFullPath(String relativePath) {
        return UPLOAD_PATH + relativePath.substring(relativePath.lastIndexOf("/") + 1);
    }
}