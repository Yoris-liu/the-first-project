package com.hngc.util;

import com.hngc.pojo.Category;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
/**
 * 树形结构工具类
 * 作用：将数据库查询出的【平铺分类列表】，封装成【前端需要的父子层级树形结构】
 * 适用：商品分类、菜单、部门等具有层级关系的数据
 */
@Component
public class TreeUtil {
    /**
     * 构建分类树形结构的入口方法
     * @param categoryList 从数据库查询的所有分类列表（平铺结构，无父子关系）
     * @return 封装好的树形结构列表（顶级分类 + 多级子分类）
     */
    public static List<Category> buildTree(List<Category> categoryList) {
        List<Category> treeList = new ArrayList<>();// 最终返回的树形结构集合
        // 1. 遍历所有分类，找到【顶级节点】（父ID = 0）
        for (Category category : categoryList) {
            if (category.getParent_id() == 0) { // 判断：如果当前分类的父ID是0，说明是一级分类（顶级节点）
                treeList.add(findChildren(category, categoryList));// 2.递归查找该顶级节点的所有子节点，并封装到children中
            }
        }
        return treeList;//3.返回完整树形结构
    }
    /**
     * 【递归方法】：给当前节点查找并封装所有子节点
     * 递归思想：自己调用自己，直到没有子节点为止
     * @param category 当前需要找子节点的分类
     * @param categoryList 所有分类数据
     * @return 封装好子节点的当前分类
     */
    private static Category findChildren(Category category, List<Category> categoryList) {
        for (Category child : categoryList) { // 遍历所有分类，判断谁是当前分类的子节点
            if (child.getParent_id().equals(category.getCategory_id())) { // 判断条件：子分类的父ID == 当前分类的ID → 就是子节点
                if (category.getChildren() == null) { // 如果当前分类的children集合为空，先初始化（防止空指针）
                    category.setChildren(new ArrayList<>());
                }
                // 递归：继续找这个子节点的子节点（孙子节点），然后加入children集合
                category.getChildren().add(findChildren(child, categoryList));// 把子节点放进 children
            }
        }
        return category;// 返回已经封装完所有子节点的当前分类对象
    }
}
