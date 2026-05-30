create database if not exists eshopDB03;
use eshopDB03;
-- 店铺表
drop table if exists shop;
create table if not exists shop(
  id bigint auto_increment primary key not null,  -- 店铺ID 主键
	shop_name varchar(100) not null,-- 店铺名称店铺Logo/头像URL
	shop_avatar varchar(255) default null, -- 店铺Logo/头像URL 
	shop_desc varchar(500) default null,-- 店铺简介/介绍
	merchant_id bigint not null,-- 关联的商家ID（用户表ID）
	category_id  bigint not null,-- 店铺经营类目ID（类目表ID）
	shop_status tinyint default 0 not null,-- 店铺状态：0-封禁 1-营业中 2-休息中 3-审核中
	address varchar(200) default null,-- 店铺所在地/发货地
	contact_phone varchar(20) default null,-- 联系电话
	contact_email varchar(50) default null,-- 联系邮箱,
	business_license varchar(255) default null, -- 营业执照图片URL	
	avg_score decimal(2,1) default '5.0',-- 店铺综合评分	
	sale_count bigint  default '5.0' not null, -- 累计销量
	favorites_count bigint default 0  not null,  -- 收藏人数
	create_time datetime default current_timestamp not null , -- '创建时间',
	update_time datetime default current_timestamp on update current_timestamp null,  -- '更新时间',
	deleted tinyint NOT NULL DEFAULT '0' -- 是否删除（0-未删 1-已删），用于逻辑删除
);
insert into shop (shop_name, shop_avatar, shop_desc, merchant_id, category_id, shop_status, address, contact_phone, contact_email, business_license, avg_score, sale_count, favorites_count, create_time, update_time, deleted)
VALUES
-- 1. 数码类-营业中店铺（华为授权店）
('华为授权体验店（深圳万象城）', 'https://img.example.com/shop/avatar1.jpg', '华为官方授权体验店，全系产品现货发售，鸿蒙生态一站式体验，全国联保', 1001, 101, 1, '广东省深圳市南山区科技园万象城1楼', '0755-88886661', 'huawei_sz@partner.com', 'https://img.example.com/license/1.jpg', 4.9, 25800, 35600, DEFAULT, DEFAULT, 0),
-- 2. 服装类-营业中店铺
('绫致时装（ONLY官方直营）', 'https://img.example.com/shop/avatar2.jpg', 'ONLY官方直营，北欧极简设计风格，都市女性通勤首选，当季新品同步专柜', 1002, 102, 1, '浙江省杭州市滨江区网商路599号', '0571-89996662', 'only_hz@bestseller.com', 'https://img.example.com/license/2.jpg', 4.7, 18600, 25300, DEFAULT, DEFAULT, 0),
-- 3. 食品类-休息中店铺
('良品铺子（华东仓储店）', 'https://img.example.com/shop/avatar3.jpg', '良品铺子官方仓储直营，零食坚果肉脯蜜饯，每日新鲜发货，满99包邮', 1003, 103, 2, '山东省济南市历城区工业北路188号普洛斯物流园', '0531-87776663', 'jn_wh@bestore.com', 'https://img.example.com/license/3.jpg', 4.8, 52000, 68500, DEFAULT, DEFAULT, 0),
-- 4. 美妆类-审核中店铺
('完美日记（广州体验中心）', 'https://img.example.com/shop/avatar4.jpg', '完美日记官方体验店，眼妆唇妆底妆全线在售，国货美妆领军品牌，支持专柜验货', 1004, 104, 3, '上海市浦东新区世纪大道100号东方大厦1层', '021-68886664', 'pudong_oc@perfectdiary.com', 'https://img.example.com/license/4.jpg', 5.0, 0, 18200, DEFAULT, DEFAULT, 0),
-- 5. 家居类-封禁店铺（资质过期）
('慕思家居（成都旗舰店）', 'https://img.example.com/shop/avatar5.jpg', '慕思寝具官方旗舰，床垫床架枕头全屋软装，试睡30天无忧退换', 1005, 105, 0, '四川省成都市武侯区二环路西一段6号红星美凯龙', '028-85556665', 'cd_musi@derucci.com', 'https://img.example.com/license/5.jpg', 4.6, 12800, 9100, DEFAULT, DEFAULT, 0),
-- 6. 图书类-营业中店铺
('当当网官方旗舰店', 'https://img.example.com/shop/avatar6.jpg', '当当网官方自营，正版图书保障，教材教辅小说社科全场满减，次日达', 1006, 106, 1, '北京市海淀区北四环西路66号中国技术交易大厦', '010-88886666', 'dangdang_self@dangdang.com', 'https://img.example.com/license/6.jpg', 4.7, 15200, 28900, DEFAULT, DEFAULT, 0),
-- 7. 母婴类-营业中店铺
('贝亲（中国官方旗舰店）', 'https://img.example.com/shop/avatar7.jpg', '贝亲官方直营，奶瓶奶嘴婴儿洗护喂养用品，日本母婴品牌，正品溯源', 1007, 107, 1, '广东省广州市天河区珠江新城华夏路16号富力中心', '020-88886667', 'gzc_pigeon@pigeon.com', 'https://img.example.com/license/7.jpg', 4.9, 9500, 36700, DEFAULT, DEFAULT, 0),
-- 8. 运动类-休息中店铺
('李宁（官方折扣店）', 'https://img.example.com/shop/avatar8.jpg', '李宁官方折扣直营店，跑步篮球训练装备，国潮设计，正品保真折扣特卖', 1008, 108, 2, '浙江省宁波市鄞州区南部商务区泰康中路588号', '0574-88886668', 'nb_linin@lining.com', 'https://img.example.com/license/8.jpg', 4.7, 22300, 14200, DEFAULT, DEFAULT, 0),
-- 9. 家电类-营业中店铺
('美的集团官方旗舰店', 'https://img.example.com/shop/avatar9.jpg', '美的官方直营，空调冰箱洗衣机厨房电器一站式购齐，上门安装以旧换新', 1009, 109, 1, '江苏省苏州市姑苏区干将西路1296号美的楼', '0512-88886669', 'sz_midea@midea.com', 'https://img.example.com/license/9.jpg', 4.8, 68000, 89500, DEFAULT, DEFAULT, 0),
-- 10. 饰品类-审核中店铺
('周大福（厦门专营店）', 'https://img.example.com/shop/avatar10.jpg', '周大福官方授权专营，黄金铂金钻石K金，足金保证，以旧换新免费清洗', 1010, 110, 3, '福建省厦门市思明区中山路318号周大福金店', '0592-88886670', 'xm_ctf@chowtaifook.com', 'https://img.example.com/license/10.jpg', 5.0, 0, 5850, DEFAULT, DEFAULT, 0);

select * from shop;

-- 商品类型表
drop table if exists category;
create table if not exists category(
  category_id  int  auto_increment primary key not null,  -- 编号
	category_name  varchar(50) not null,   -- 名称
	category_code  varchar(20) not null,   -- 编码	
	parent_id int not null,       -- 父类型ID
	sort_num int not null,        -- 排序序号
	status int default 1, -- 状态（0=禁用，1=启用）
	create_time varchar(20),	 -- 创建时间
	update_time varchar(20)   -- 修改时间
);

insert into category (category_name, category_code, parent_id, sort_num, status, create_time, update_time)
values
-- 1. 一级类目-数码类（无父类目，parent_id=0）
('数码产品', 'SM001', 0, 1, 1, '2026-01-10 10:00:00', '2026-01-10 10:00:00'),
-- 2. 二级类目-手机（父类目为数码产品，parent_id=1）
('手机', 'SM00101', 1, 2, 1, '2026-01-10 10:05:00', '2026-01-10 10:05:00'),
-- 3. 二级类目-电脑/平板（父类目为数码产品，parent_id=1）
('电脑/平板', 'SM00102', 1, 3, 1, '2026-01-10 10:08:00', '2026-01-10 10:08:00'),
-- 4. 一级类目-服装类
('服装服饰', 'SM002', 0, 4, 1, '2026-01-10 10:10:00', '2026-01-10 10:10:00'),
-- 5. 二级类目-女装（父类目为服装服饰，parent_id=4）
('女装', 'SM00201', 4, 5, 1, '2026-01-10 10:12:00', '2026-01-10 10:12:00'),
-- 6. 二级类目-男装（父类目为服装服饰，parent_id=4）
('男装', 'SM00202', 4, 6, 1, '2026-01-10 10:15:00', '2026-01-10 10:15:00'),
-- 7. 一级类目-食品类
('食品生鲜', 'SM003', 0, 7, 1, '2026-01-10 10:18:00', '2026-01-10 10:18:00'),
-- 8. 一级类目-美妆类
('美妆护肤', 'SM004', 0, 8, 0, '2026-01-10 10:20:00', '2026-01-12 09:30:00'),
-- 9. 一级类目-家居类
('家居用品', 'SM005', 0, 9, 1, '2026-01-10 10:22:00', '2026-01-10 10:22:00'),
-- 10. 二级类目-家居软装（父类目为家居用品，parent_id=9）
('家居软装', 'SM00501', 9, 10, 1, '2026-01-10 10:25:00', '2026-01-10 10:25:00');
select * from category;

-- insert into category (category_name, category_code, parent_id, sort_num, status)
-- values
-- -- 一级分类（parent_id = 0）
-- ('数码产品', 'ELEC', 0, 1, 1),
-- ('食品生鲜', 'FOOD', 0, 2, 1),
-- ('家居用品', 'HOME', 0, 3, 1),
-- ('服饰鞋帽', 'CLOTH', 0, 4, 1),
-- ('美妆护肤', 'BEAUTY', 0, 5, 1),
-- -- 二级分类（归属数码产品，parent_id = 1）
-- ('智能手机', 'ELEC_PHONE', 1, 1, 1),
-- ('笔记本电脑', 'ELEC_LAPTOP', 1, 2, 1),
-- ('平板电脑', 'ELEC_TABLET', 1, 3, 1),
-- ('智能手表', 'ELEC_WATCH', 1, 4, 1),
-- -- 二级分类（归属食品生鲜，parent_id = 2）
-- ('休闲零食', 'FOOD_SNACK', 2, 1, 1),
-- ('新鲜水果', 'FOOD_FRUIT', 2, 2, 1),
-- ('冷冻食品', 'FOOD_FROZEN', 2, 3, 1),
-- -- 二级分类（归属家居用品，parent_id = 3）
-- ('厨房用具', 'HOME_KITCHEN', 3, 1, 1),
-- ('清洁用品', 'HOME_CLEAN', 3, 2, 1),
-- -- 二级分类（归属服饰鞋帽，parent_id = 4）
-- ('男士服装', 'CLOTH_MAN', 4, 1, 1),
-- ('女士鞋子', 'CLOTH_WOMAN_SHOE', 4, 2, 1),
-- -- 二级分类（归属美妆护肤，parent_id = 5）
-- ('面部精华', 'BEAUTY_SERUM', 5, 1, 1),
-- ('口红唇膏', 'BEAUTY_LIPSTICK', 5, 2, 1);
-- select * from category;

-- 用户表
drop table if exists users;
create table users (
  user_id int primary key auto_increment not null,
  username varchar(50) not null,-- 用户名,
  password varchar(100)  not null, -- 密码（加密存储）,
  phone varchar(20) null, -- 手机号,
  email varchar(100) null,  -- 邮箱,
  real_name varchar(50)  null, -- 真实姓名,
  gender varchar(2) check(gender='男' or gender='女')  null, -- 性别,
  birthday date null, -- 生日,
  status tinyint null default 1 null, -- 用户状态（0=禁用，1=正常）
  create_time datetime null default current_timestamp, -- 注册时间
  update_time datetime null default current_timestamp -- 更新时间
); 

-- 往users表插入20条测试数据，严格适配表结构所有字段，贴合电商用户场景，符合约束要求
INSERT INTO users (username, password, phone, email, real_name, gender, birthday, status, create_time, update_time)
VALUES
-- 1. 普通用户-男（深圳互联网从业者）
('alex_wang', 'e10adc3949ba59abbe56e057f20f883e', '13800138001', 'alex.wang@qq.com', '王浩宇', '男', '1995-03-15', 1, DEFAULT, DEFAULT),
-- 2. 普通用户-女（杭州电商运营）
('lily_chen', 'e10adc3949ba59abbe56e057f20f883e', '13900139002', 'lilychen@163.com', '陈思琪', '女', '1998-07-22', 1, DEFAULT, DEFAULT),
-- 3. 普通用户-男
('liuyang_2023', 'e10adc3949ba59abbe56e057f20f883e', '13700000003', 'liuyang@163.com', '刘阳', '男', '2000-01-05', 1, DEFAULT, DEFAULT),
-- 4. 商家用户-女（华为授权店店长）
('zhangwei_888', 'e10adc3949ba59abbe56e057f20f883e', '13700137003', 'zhangwei@huawei-partner.com', '张薇', '女', '1992-10-18', 1, DEFAULT, DEFAULT),
-- 5. 普通用户-男（禁用状态，涉嫌异常登录）
('jasonshao', 'e10adc3949ba59abbe56e057f20f883e', '13600136004', 'jason.shao@gmail.com', '邵杰', '男', '1996-05-30', 0, DEFAULT, DEFAULT),
-- 6. 普通用户-女
('xiaoxiao_zhou', 'e10adc3949ba59abbe56e057f20f883e', '13500135005', 'xiaoxiaozhou@sina.com', '周晓晓', '女', '1997-06-15', 1, DEFAULT, DEFAULT),
-- 7. 商家用户-男（绫致时装区域经理）
('mike_huang', 'e10adc3949ba59abbe56e057f20f883e', '13400134006', 'mike.huang@bestseller.com', '黄俊杰', '男', '1990-08-12', 1, DEFAULT, DEFAULT),
-- 8. 普通用户-女（广州教师）
('emma_li', 'e10adc3949ba59abbe56e057f20f883e', '13300133007', 'emma.li@qq.com', '李诗雅', '女', '1999-04-08', 1, DEFAULT, DEFAULT),
-- 9. 普通用户-男（在校研究生）
('tech_fan_2024', 'e10adc3949ba59abbe56e057f20f883e', '13200132008', 'techfan@qq.com', '赵天宇', '男', '2001-09-25', 1, DEFAULT, DEFAULT),
-- 10. 商家用户-女（完美日记店长）
('sarah_zhang', 'e10adc3949ba59abbe56e057f20f883e', '13100131009', 'sarah.zhang@perfectdiary.com', '张雅婷', '女', '1988-11-03', 1, DEFAULT, DEFAULT),
-- 11. 普通用户-男（北京程序员）
('kevin_wu', 'e10adc3949ba59abbe56e057f20f883e', '13000130010', 'kevin.wu@outlook.com', '吴凯文', '男', '1997-02-17', 1, DEFAULT, DEFAULT),
-- 12. 普通用户-女（禁用状态，长期未登录）
('yueyue_zhao', 'e10adc3949ba59abbe56e057f20f883e', '13600000012', 'zhaoyue@163.com', '赵悦', '女', '1994-06-20', 0, DEFAULT, DEFAULT),
-- 13. 商家用户-男（慕思家居大区总监）
('james_liu', 'e10adc3949ba59abbe56e057f20f883e', '13800138011', 'james.liu@derucci.com', '刘建平', '男', '1991-07-09', 1, DEFAULT, DEFAULT),
-- 14. 普通用户-女
('rainie_yang', 'e10adc3949ba59abbe56e057f20f883e', '13500000014', 'rainie.yang@qq.com', '杨雨欣', '女', '1996-09-20', 1, DEFAULT, DEFAULT),
-- 15. 普通用户-男（大学生）
('tommy_lin', 'e10adc3949ba59abbe56e057f20f883e', '13900139012', 'tommy.lin@gmail.com', '林宇轩', '男', '2002-03-14', 1, DEFAULT, DEFAULT),
-- 16. 商家用户-女（贝亲中国运营主管）
('nancy_guo', 'e10adc3949ba59abbe56e057f20f883e', '13700137013', 'nancy.guo@pigeon.com', '郭楠', '女', '1989-05-28', 1, DEFAULT, DEFAULT),
-- 17. 普通用户-男
('david_xu', 'e10adc3949ba59abbe56e057f20f883e', '13600136014', 'david.xu@qq.com', '徐大卫', '男', '1993-08-30', 1, DEFAULT, DEFAULT),
-- 18. 普通用户-女（成都自由职业）
('vicki_cheng', 'e10adc3949ba59abbe56e057f20f883e', '13500135015', 'vicki.cheng@163.com', '程婉婷', '女', '1998-12-01', 1, DEFAULT, DEFAULT),
-- 19. 商家用户-男（美的区域经理）
('tony_he', 'e10adc3949ba59abbe56e057f20f883e', '13400134016', 'tony.he@midea.com', '何志远', '男', '1990-04-11', 1, DEFAULT, DEFAULT),
-- 20. 普通用户-女（禁用状态）
('sandy_niu', 'e10adc3949ba59abbe56e057f20f883e', '13300133017', 'sandy.niu@qq.com', '牛珊珊', '女', '2000-07-16', 0, DEFAULT, DEFAULT);

select * from users;

-- insert into users values (1, 'zhangsan1001', 'e10adc3949ba59abbe56e057f20f883e', '13800138000', 'zhangsan@example.com', '张三', '男', '1990-01-15', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(2, 'lisi1002', 'e10adc3949ba59abbe56e057f20f883e', '13900139000', 'lisi@example.com', '李四', '男', '1995-05-20', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(3, 'wangwu1003', 'e10adc3949ba59abbe56e057f20f883e', '13700137000', 'wangwu@example.com', '王五', '男', '1988-08-10', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(4, 'zhaoliu1004', 'e10adc3949ba59abbe56e057f20f883e', '13600136000', 'zhaoliu@example.com', '赵六', "女", '1992-03-25', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(5, 'sunqi1005', 'e10adc3949ba59abbe56e057f20f883e', '13500135000', 'sunqi@example.com', '孙七', "女", '1998-11-05', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(6, 'zhouba1006', 'e10adc3949ba59abbe56e057f20f883e', '13400134000', 'zhouba@example.com', '周八', '男', '2000-07-18', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(7, 'wujiu1007', 'e10adc3949ba59abbe56e057f20f883e', '13300133000', 'wujiu@example.com', '吴九', '女', '1993-09-30', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(8, 'zhengshi1008', 'e10adc3949ba59abbe56e057f20f883e', '13200132000', 'zhengshi@example.com', '郑十', "男", '1996-04-12', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(9, 'chenyi1009', 'e10adc3949ba59abbe56e057f20f883e', '13100131000', 'chenyi@example.com', '陈一', "女", '1985-12-08', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(10, 'lianger1010', 'e10adc3949ba59abbe56e057f20f883e', '13000130000', 'lianger@example.com', '梁二', '女', '1991-06-19', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(11, 'songsan1011', 'e10adc3949ba59abbe56e057f20f883e', '12900129000', 'songsan@example.com', '宋三', '男', '1989-02-22', 0, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(12, 'xusisi1012', 'e10adc3949ba59abbe56e057f20f883e', '12800128000', 'xusisi@example.com', '徐四','女', '1997-08-14', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(13, 'malwu1013', 'e10adc3949ba59abbe56e057f20f883e', '12700127000', '', '马五', '男','2001-01-02', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(14, 'yangliu1014', 'e10adc3949ba59abbe56e057f20f883e', '12600126000', 'yangliu@example.com', '杨六', '男', '2001-01-01', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(15, 'huchi1015', 'e10adc3949ba59abbe56e057f20f883e', '12500125000', 'huchi@example.com', '胡七', '男', '1994-10-28', 1, '2026-03-11 15:33:53', '2026-03-11 15:33:53');
-- select * from users;
-- 商品表
drop table if exists product;
create table  product  (
  product_id int primary key auto_increment not null, -- '商品ID（主键）'
  product_name varchar(100)  not null, -- '商品名称',
  product_code varchar(30)  unique not null, -- '商品编码（SKU）'
  category_id int not null, -- '商品类型ID（关联商品类型表）',
  subtitle varchar(200) null default '' null , -- '商品副标题',
  price decimal(10, 2) not null, -- 商品售价（元）',
  original_price decimal(10, 2) null default 0.00 null,  -- '商品原价（元）',
  stock_num int default 0  not null, -- '库存数量',
  status tinyint default 1  null,  --  '商品状态（0=下架，1=上架，2=预售，3=缺货）'
  image_url varchar(500) null default '',  -- '商品主图URL',
  sales_num int null default 0, -- '累计销量',
  create_time datetime null default current_timestamp, -- '创建时间',
  update_time datetime null default current_timestamp on update current_timestamp -- '更新时间', 
);

-- 商品表 product 插入 25 条标准测试数据（完全匹配你的 category 表）
INSERT INTO product (product_name, product_code, category_id, subtitle, price, original_price, stock_num, status, image_url, sales_num, create_time, update_time)
VALUES
-- 1. 一级类目：数码产品 (category_id=1)
('华为 Mate 60 Pro（鸿蒙旗舰）', 'HW-M60PRO-001', 1, '麒麟9000S芯｜卫星通话｜鸿蒙OS 4.0｜昆仑玻璃', 6999.00, 7999.00, 150, 1, 'img/product_001.jpg', 320, DEFAULT, DEFAULT),
-- 2. 二级类目：手机 (category_id=2)
('Apple iPhone 15 Pro Max 256G', 'APPLE-IP15PM-002', 2, 'A17 Pro芯片｜钛金属设计｜4800万像素主摄｜USB-C', 8999.00, 9999.00, 120, 1, 'img/product_002.jpg', 280, DEFAULT, DEFAULT),
-- 3. 二级类目：电脑/平板 (category_id=3)
('Apple iPad Air 11英寸 M2芯片', 'APPLE-IPADAIR-003', 3, 'M2芯片｜10.9英寸 Liquid Retina｜轻薄办公学习', 4799.00, 4999.00, 200, 1, 'img/product_003.jpg', 186, DEFAULT, DEFAULT),
-- 4. 一级类目：服装服饰 (category_id=4)
('ONLY 春季新款通勤西装外套', 'ONLY-BLAZER-004', 4, '法式复古｜收腰设计｜职场通勤｜2026春季新品', 599.00, 799.00, 300, 1, 'img/product_004.jpg', 458, DEFAULT, DEFAULT),
-- 5. 二级类目：女装 (category_id=5)
('ONLY 碎花雪纺连衣裙 春夏', 'ONLY-DRESS-005', 5, '法式碎花｜收腰显瘦｜雪纺飘逸｜约会通勤', 359.00, 499.00, 300, 1, 'img/product_005.jpg', 520, DEFAULT, DEFAULT),
-- 6. 二级类目：女装 (category_id=5)
('ONLY 高腰弹力牛仔裤（预售款）', 'ONLY-JEANS-006', 5, '高腰显瘦｜弹力修身｜百搭经典蓝｜预售7天发货', 259.00, 329.00, 0, 2, 'img/product_006.jpg', 120, DEFAULT, DEFAULT),
-- 7. 二级类目：男装 (category_id=6)
('李宁 男士纯棉宽松T恤 国潮系列', 'LINING-TEE-007', 6, '国潮设计｜纯棉亲肤｜宽松百搭｜多色可选', 129.00, 179.00, 400, 1, 'img/product_007.jpg', 632, DEFAULT, DEFAULT),
-- 8. 二级类目：男装 (category_id=6)
('李宁 束脚工装裤 运动休闲', 'LINING-CARGO-008', 6, '宽松多口袋｜束脚设计｜机能风｜耐磨面料', 239.00, 299.00, 220, 1, 'img/product_008.jpg', 376, DEFAULT, DEFAULT),
-- 9. 一级类目：食品生鲜 (category_id=7)
('良品铺子 纯牛奶 200ml×16盒 礼盒装', 'LP-NMILK-009', 7, '优质牧场奶源｜营养早餐｜蛋白质3.6g/100ml', 59.90, 79.90, 500, 1, 'img/product_009.jpg', 890, DEFAULT, DEFAULT),
-- 10. 一级类目：食品生鲜 (category_id=7)
('良品铺子 全麦欧包早餐面包 600g', 'LP-BREAD-010', 7, '全麦粗粮｜无蔗糖添加｜松软可口｜独立包装', 36.90, 49.90, 0, 3, 'img/product_010.jpg', 356, DEFAULT, DEFAULT),
-- 11. 一级类目：食品生鲜 (category_id=7)
('良品铺子 每日坚果礼盒 750g/30包', 'LP-NUTS-011', 7, '9种坚果果干混合｜每日一包｜送礼自用皆宜', 139.00, 169.00, 120, 1, 'img/product_011.jpg', 210, DEFAULT, DEFAULT),
-- 12. 一级类目：美妆护肤 (category_id=8)
('完美日记 小细跟口红 丝绒哑光', 'PD-LIPSTICK-012', 8, '丝绒哑光质地｜显白不拔干｜多色号可选｜国货美妆', 79.90, 129.00, 250, 1, 'img/product_012.jpg', 780, DEFAULT, DEFAULT),
-- 13. 一级类目：美妆护肤 (category_id=8)
('完美日记 修护保湿面霜 50g', 'PD-CREAM-013', 8, '神经酰胺修护｜深层补水｜敏感肌适用｜清爽不油腻', 169.00, 229.00, 60, 0, 'img/product_013.jpg', 178, DEFAULT, DEFAULT),
-- 14. 一级类目：美妆护肤 (category_id=8)
('完美日记 持妆粉底液 30ml', 'PD-FOUNDATION-014', 8, '控油持妆24h｜自然遮瑕｜奶油肌妆效｜SPF25防晒', 89.90, 139.00, 160, 1, 'img/product_014.jpg', 389, DEFAULT, DEFAULT),
-- 15. 一级类目：家居用品 (category_id=9)
('慕思 慢回弹记忆棉腰靠垫', 'MUSI-BACK-015', 9, '人体工学设计｜慢回弹记忆棉｜办公驾驶通用｜透气网眼', 199.00, 299.00, 350, 1, 'img/product_015.jpg', 420, DEFAULT, DEFAULT),
-- 16. 二级类目：家居软装 (category_id=10)
('慕思 全遮光窗帘 轻奢高精密', 'MUSI-CURTAIN-016', 10, '物理全遮光｜高精密面料｜隔热防晒｜免费定制尺寸', 459.00, 599.00, 0, 2, 'img/product_016.jpg', 95, DEFAULT, DEFAULT),
-- 17. 二级类目：家居软装 (category_id=10)
('慕思 抽屉式收纳盒 3个装', 'MUSI-BOX-017', 10, '加厚PP材质｜分类收纳｜可叠加｜半透明视窗', 49.90, 79.90, 280, 1, 'img/product_017.jpg', 610, DEFAULT, DEFAULT),
-- 18. 二级类目：家居软装 (category_id=10)
('慕思 60支长绒棉四件套 1.8m床', 'MUSI-BEDSHEET-018', 10, '60支长绒棉｜亲肤丝滑｜不起球不褪色｜免熨烫', 499.00, 699.00, 130, 1, 'img/product_018.jpg', 198, DEFAULT, DEFAULT),
-- 19. 二级类目：手机 (category_id=2)
('Huawei FreeBuds Pro 4 降噪耳机', 'HW-FREEBUDS-019', 2, '智慧动态降噪3.0｜星闪连接｜超长续航｜鸿蒙生态', 1299.00, 1499.00, 80, 0, 'img/product_019.jpg', 520, DEFAULT, DEFAULT),
-- 20. 二级类目：手机 (category_id=2)
('Huawei WATCH GT 4 运动智能手表', 'HW-WATCHGT4-020', 2, '科学运动监测｜血氧心率睡眠｜14天续航｜时尚设计', 1588.00, 1788.00, 0, 3, 'img/product_020.jpg', 245, DEFAULT, DEFAULT),
-- 21. 二级类目：手机 (category_id=2)
('Huawei 66W 超级快充充电器套装', 'HW-CHARGER-021', 2, '66W超级快充｜Type-C接口｜安全认证｜含6A数据线', 129.00, 169.00, 500, 1, 'img/product_021.jpg', 720, DEFAULT, DEFAULT),
-- 22. 二级类目：电脑/平板 (category_id=3)
('联想 小新Pro 14 2026 锐龙版', 'LX-XIAOXIN-022', 3, '锐龙R7-8845H｜2.8K 120Hz｜32G+1T｜轻薄办公本', 5999.00, 6599.00, 90, 1, 'img/product_022.jpg', 156, DEFAULT, DEFAULT),
-- 23. 二级类目：女装 (category_id=5)
('ONLY 双排扣气质风衣 春秋季', 'ONLY-TRENCH-023', 5, '经典双排扣｜中长款显瘦｜防风抗皱｜通勤百搭', 599.00, 799.00, 180, 1, 'img/product_023.jpg', 278, DEFAULT, DEFAULT),
-- 24. 一级类目：食品生鲜 (category_id=7)
('良品铺子 苏打饼干 海盐味 500g', 'LP-BISCUIT-024', 7, '减盐配方｜低脂低卡｜酥脆口感｜独立小包装', 22.90, 32.90, 400, 1, 'img/product_024.jpg', 530, DEFAULT, DEFAULT),
-- 25. 二级类目：女装 (category_id=5)
('贝亲 婴儿纯棉连体衣 新生儿', 'PIGEON-BABY-025', 5, '纯棉A类面料｜无骨缝设计｜暗扣易穿脱｜四季通用', 89.00, 129.00, 300, 1, 'img/product_025.jpg', 410, DEFAULT, DEFAULT);
select * from product;
-- insert into  product values (1, '华为Mate 70 Pro', 'HUAWEI_MATE70_PRO', 6, '鸿蒙OS 4.2，麒麟芯片', 6999.00, 7499.00, 500, 1, 'https://example.com/huawei_mate70.jpg', 1200, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(2, '苹果iPhone 16', 'APPLE_IPHONE16', 6, 'A18芯片，超窄边框', 5999.00, 6299.00, 800, 1, 'https://example.com/iphone16.jpg', 1500, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(3, '联想小新Pro 2025', 'LENOVO_XIAOXIN_PRO25', 7, '锐龙7 8845H，2.8K屏', 4999.00, 5499.00, 300, 1, 'https://example.com/lenovo_xiaoxin.jpg', 800, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(4, '苹果MacBook Air M3', 'APPLE_MACBOOK_AIR_M3', 7, 'M3芯片，续航18小时', 7999.00, 8499.00, 200, 1, 'https://example.com/macbook_air.jpg', 600, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(5, 'iPad Pro 2025', 'APPLE_IPAD_PRO25', 8, 'M4芯片，12.9英寸全面屏', 6299.00, 6799.00, 150, 1, 'https://example.com/ipad_pro.jpg', 400, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(6, '华为Watch GT5', 'HUAWEI_WATCH_GT5', 9, '续航14天，血氧监测', 1299.00, 1499.00, 1000, 1, 'https://example.com/huawei_watch.jpg', 2000, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(7, '三只松鼠每日坚果', 'THREESQUIRRELS_NUTS', 10, '30包混合坚果，独立包装', 89.90, 109.90, 2000, 1, 'https://example.com/three_squirrels.jpg', 5000, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(8, '山东烟台红富士苹果', 'YANTAI_APPLE', 11, '85mm大果，脆甜多汁', 29.90, 39.90, 5000, 1, 'https://example.com/yantai_apple.jpg', 8000, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(9, '安井速冻水饺（猪肉白菜）', 'ANJING_DUMPLING', 12, '1kg装，皮薄馅大', 19.90, 25.90, 3000, 1, 'https://example.com/anjing_dumpling.jpg', 3000, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(10, '苏泊尔不粘锅炒锅', 'SUPOR_PAN', 13, '32cm，不粘易清洗', 199.00, 259.00, 800, 1, 'https://example.com/supor_pan.jpg', 1200, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(11, '蓝月亮洗衣液（深层洁净）', 'BLUEMOON_LAUNDRY', 14, '5kg装，薰衣草香', 49.90, 59.90, 4000, 1, 'https://example.com/bluemoon.jpg', 6000, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(12, '优衣库男士纯棉T恤', 'UNIQLO_MEN_TEE', 15, 'XL码，白色，透气亲肤', 59.90, 79.90, 1000, 1, 'https://example.com/uniqlo_tee.jpg', 4000, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(13, '百丽女士真皮高跟鞋', 'BAILI_WOMAN_SHOE', 16, '37码，黑色，5cm跟高', 399.00, 499.00, 300, 1, 'https://example.com/baili_shoe.jpg', 800, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(14, '兰蔻小黑瓶精华', 'LANCOME_SERUM', 17, '50ml，修护肌底', 1080.00, 1280.00, 200, 1, 'https://example.com/lancome_serum.jpg', 900, '2026-03-11 15:33:53', '2026-03-11 15:33:53'),(15, '迪奥999哑光口红', 'DIOR_LIPSTICK_999', 18, '经典正红，哑光质地', 380.00, 420.00, 500, 1, 'https://example.com/dior_lipstick.jpg', 1500, '2026-03-11 15:33:53', '2026-03-11 15:33:53');
-- select * from product;

-- 订单主表：存储订单整体信息
drop table if exists orders;
create table if not exists orders (
  order_id bigint primary key auto_increment not null,  -- 订单ID（主键）
  order_no varchar(30) unique not null,                 -- 订单编号（唯一）
  user_id int not null,                                 -- 下单用户ID（关联users表）
  shop_id bigint not null,                              -- 店铺ID（关联shop表）
  order_status tinyint default 0 not null,              -- 订单状态：0待付款 1待发货 2待收货 3已完成 4已取消
  pay_type tinyint default 0 null,                      -- 支付方式：0未支付 1微信 2支付宝 3银行卡
  total_price decimal(10,2) not null,                   -- 订单总金额
  pay_price decimal(10,2) not null,                     -- 实付金额
  receiver_name varchar(20) null,                       -- 收件人姓名
  receiver_phone varchar(20) null,                       -- 收件人电话
  receiver_address varchar(255) null,                    -- 收货地址
  pay_time datetime null,                                -- 支付时间
  delivery_time datetime null,                           -- 发货时间
  receive_time datetime null,                            -- 确认收货时间
  create_time datetime default current_timestamp null,   -- 创建时间
  update_time datetime default current_timestamp on update current_timestamp null
);
-- 订单明细表：存储订单里的每个商品
drop table if exists order_item;
create table if not exists order_item (
  item_id bigint primary key auto_increment not null,   -- 明细ID
  order_id bigint not null,                             -- 关联订单ID
  product_id int not null,                              -- 商品ID（关联product表）
  product_name varchar(100) not null,                   -- 商品名称（快照）
  product_price decimal(10,2) not null,                 -- 商品单价
  buy_num int not null,                                 -- 购买数量
  create_time datetime default current_timestamp null
);
-- 插入 10 条订单（数据关联新用户和新商品）
insert into orders (order_no, user_id, shop_id, order_status, pay_type, total_price, pay_price, receiver_name, receiver_phone, receiver_address)
values
('HW20260501001', 1, 1, 1, 1, 6999.00, 6999.00, '王浩宇', '13800138001', '广东省深圳市南山区科技南路18号'),
('BD20260502002', 2, 1, 2, 2, 8999.00, 8999.00, '陈思琪', '13900139002', '浙江省杭州市余杭区仓前街道未来科技城'),
('LP20260503003', 3, 2, 3, 1, 239.00, 239.00, '刘阳', '13700137003', '山东省济南市历下区泉城路26号'),
('PD20260504004', 4, 4, 0, 0, 169.00, 0.00, '张薇', '13600136004', '上海市浦东新区张江高科技园区'),
('LP20260505005', 5, 3, 1, 2, 139.00, 139.00, '邵杰', '13500135005', '北京市海淀区中关村大街1号'),
('MUSI20260506006', 1, 5, 4, 1, 199.00, 0.00, '王浩宇', '13800138001', '广东省深圳市南山区科技南路18号'),
('ONLY20260507007', 2, 2, 2, 2, 259.00, 259.00, '陈思琪', '13900139002', '浙江省杭州市余杭区仓前街道未来科技城'),
('MUSI20260508008', 3, 5, 3, 1, 499.00, 499.00, '刘阳', '13700137003', '山东省济南市历下区泉城路26号'),
('PD20260509009', 4, 4, 1, 2, 79.90, 79.90, '张薇', '13600136004', '上海市浦东新区张江高科技园区'),
('HW20260510010', 5, 1, 2, 1, 1588.00, 1588.00, '邵杰', '13500135005', '北京市海淀区中关村大街1号');
-- 插入 20 条订单明细（同步更新商品名称和价格）
insert into order_item (order_id, product_id, product_name, product_price, buy_num)
values
(1, 1, '华为 Mate 60 Pro（鸿蒙旗舰）', 6999.00, 1),
(2, 2, 'Apple iPhone 15 Pro Max 256G', 8999.00, 1),
(3, 5, 'ONLY 碎花雪纺连衣裙 春夏', 239.00, 1),
(4, 13, '完美日记 修护保湿面霜 50g', 169.00, 1),
(5, 11, '良品铺子 每日坚果礼盒 750g/30包', 139.00, 1),
(6, 15, '慕思 慢回弹记忆棉腰靠垫', 199.00, 1),
(7, 6, 'ONLY 高腰弹力牛仔裤（预售款）', 259.00, 1),
(8, 18, '慕思 60支长绒棉四件套 1.8m床', 499.00, 1),
(9, 12, '完美日记 小细跟口红 丝绒哑光', 79.90, 1),
(10, 20, 'Huawei WATCH GT 4 运动智能手表', 1588.00, 1),
(1, 21, 'Huawei 66W 超级快充充电器套装', 129.00, 2),
(2, 22, '联想 小新Pro 14 2026 锐龙版', 5999.00, 1),
(3, 23, 'ONLY 双排扣气质风衣 春秋季', 599.00, 1),
(4, 14, '完美日记 持妆粉底液 30ml', 89.90, 1),
(5, 24, '良品铺子 苏打饼干 海盐味 500g', 22.90, 3),
(6, 17, '慕思 抽屉式收纳盒 3个装', 49.90, 1),
(7, 25, '贝亲 婴儿纯棉连体衣 新生儿', 89.00, 2),
(8, 6, 'ONLY 高腰弹力牛仔裤（预售款）', 259.00, 1),
(9, 10, '良品铺子 全麦欧包早餐面包 600g', 36.90, 2),
(10, 3, 'Apple iPad Air 11英寸 M2芯片', 4799.00, 1);

-- 1. 查询【所有订单 + 用户 + 店铺】
SELECT
  o.order_id,          -- 订单ID
  o.order_no,          -- 订单编号
  o.order_status,      -- 订单状态
  o.total_price,       -- 订单总价
  u.username,          -- 下单用户名
  u.phone,             -- 用户电话
  s.shop_name          -- 店铺名称
FROM orders o
LEFT JOIN users u ON o.user_id = u.user_id
LEFT JOIN shop s ON o.shop_id = s.id
ORDER BY o.order_id DESC;
-- 2. 查询【订单详情 + 商品信息 + 类目】
SELECT
  oi.item_id,            -- 订单明细ID
  o.order_no,            -- 订单编号
  u.username,            -- 用户名
  s.shop_name,           -- 店铺名称
  p.product_name,        -- 商品名称
  c.category_name,       -- 商品类目
  oi.product_price,      -- 商品单价
  oi.buy_num,            -- 购买数量
  (oi.product_price * oi.buy_num) AS item_total_price  -- 小计金额
FROM order_item oi
LEFT JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN users u ON o.user_id = u.user_id
LEFT JOIN shop s ON o.shop_id = s.id
LEFT JOIN product p ON oi.product_id = p.product_id
LEFT JOIN category c ON p.category_id = c.category_id
ORDER BY o.order_id;
-- 3. 查询【单个订单完整信息】（按订单 ID 查）
SELECT
  o.*,
  u.username,
  u.real_name,
  s.shop_name,
  s.contact_phone
FROM orders o
LEFT JOIN users u ON o.user_id = u.user_id
LEFT JOIN shop s ON o.shop_id = s.id
WHERE o.order_id = 1;  -- 可修改订单号
-- 4. 查询【订单状态中文说明】（最适合展示）
SELECT
  order_id,
  order_no,
  user_id,
  total_price,
  CASE order_status
    WHEN 0 THEN '待付款'
    WHEN 1 THEN '待发货'
    WHEN 2 THEN '待收货'
    WHEN 3 THEN '已完成'
    WHEN 4 THEN '已取消'
  END AS order_status_text
FROM orders
ORDER BY order_id DESC;

-- 电商订单全套实用 SQL（新增 / 改状态 / 统计销量 / 销售额）
-- 1. 新增订单（自动生成订单 + 同时生成订单明细）
-- ① 先插入订单主表sql
INSERT INTO orders (order_no, user_id, shop_id, order_status, pay_type, total_price, pay_price, receiver_name, receiver_phone, receiver_address)
VALUES ('ORDER2026011', 2, 3, 0, 0, 159.00, 0.00, '李四', '13900139002', '浙江省杭州市余杭区服装城');
-- ② 再插入订单明细（必须对应同一个 order_id）sql
INSERT INTO order_item (order_id, product_id, product_name, product_price, buy_num)
VALUES (11, 10, '丝绒哑光口红', 159.00, 1);
-- 2. 修改订单状态（最常用）
-- ① 待付款 → 待发货（已支付）sql
UPDATE orders 
SET order_status = 1, pay_time = NOW(), pay_type = 1 
WHERE order_id = 11;
-- ② 待发货 → 待收货（已发货）sql
UPDATE orders 
SET order_status = 2, delivery_time = NOW() 
WHERE order_id = 11;
-- ③ 待收货 → 已完成（确认收货）sql
UPDATE orders 
SET order_status = 3, receive_time = NOW() 
WHERE order_id = 11;
-- ④ 任意状态 → 已取消
UPDATE orders 
SET order_status = 4 
WHERE order_id = 11;
-- 3. 统计商品销量（排名版，超实用）
SELECT 
  p.product_id,
  p.product_name,
  c.category_name,
  SUM(oi.buy_num) AS total_sales
FROM order_item oi
LEFT JOIN product p ON oi.product_id = p.product_id
LEFT JOIN category c ON p.category_id = c.category_id
GROUP BY p.product_id
ORDER BY total_sales DESC;
-- 4. 统计店铺销售额（排名 + 订单数）
SELECT 
  s.id AS shop_id,
  s.shop_name,
  COUNT(o.order_id) AS order_count,
  SUM(o.pay_price) AS total_sales
FROM orders o
LEFT JOIN shop s ON o.shop_id = s.id
WHERE o.order_status IN (1,2,3)  -- 有效订单
GROUP BY s.id
ORDER BY total_sales DESC;
-- 5. 查询某个用户的所有订单（带状态中文）
SELECT 
  o.order_id,
  o.order_no,
  o.total_price,
  o.pay_price,
  CASE o.order_status 
    WHEN 0 THEN '待付款'
    WHEN 1 THEN '待发货'
    WHEN 2 THEN '待收货'
    WHEN 3 THEN '已完成'
    WHEN 4 THEN '已取消'
  END AS status_text,
  s.shop_name,
  o.create_time
FROM orders o
LEFT JOIN shop s ON o.shop_id = s.id
WHERE o.user_id = 1  -- 改用户ID即可
ORDER BY o.create_time DESC;
-- 6. 自动同步商品销量（订单完成后更新销量）
UPDATE product p
JOIN (
  SELECT product_id, SUM(buy_num) AS num 
  FROM order_item 
  GROUP BY product_id
) oi ON p.product_id = oi.product_id
SET p.sales_num = oi.num;

-- 1. 购物车表（cart）
drop table if exists cart;
create table if not exists cart (
  cart_id bigint primary key auto_increment not null,  -- 购物车ID
  user_id int not null,                                 -- 用户ID（关联users）
  product_id int not null,                              -- 商品ID（关联product）
  shop_id bigint not null,                              -- 店铺ID（关联shop）
  buy_num int default 1 not null,                       -- 购买数量
  checked tinyint default 1 not null,                   -- 是否勾选：0未勾选 1已勾选
  create_time datetime default current_timestamp,       -- 创建时间
  update_time datetime default current_timestamp on update current_timestamp
);

-- 插入10条购物车测试数据（关联新用户和新商品）
insert into cart (user_id, product_id, shop_id, buy_num, checked)
values
(1, 1, 1, 1, 1),
(1, 21, 1, 2, 1),
(2, 5, 2, 1, 1),
(2, 7, 2, 1, 0),
(3, 12, 4, 1, 1),
(3, 15, 5, 3, 1),
(4, 14, 4, 1, 0),
(4, 23, 2, 1, 1),
(5, 20, 1, 1, 1),
(5, 24, 3, 2, 1);
-- 2. 用户收货地址表（user_address）
drop table if exists user_address;
create table if not exists user_address (
  address_id bigint primary key auto_increment not null,  -- 地址ID
  user_id int not null,                                  -- 用户ID
  receiver_name varchar(20) not null,                    -- 收件人
  receiver_phone varchar(20) not null,                   -- 联系电话
  province varchar(20) not null,                         -- 省
  city varchar(20) not null,                            -- 市
  district varchar(20) not null,                        -- 区
  detail_address varchar(255) not null,                  -- 详细地址
  is_default tinyint default 0 not null,                 -- 是否默认：0否 1是
  create_time datetime default current_timestamp
);
-- 插入10条地址测试数据（真实化收件人）
insert into user_address (user_id, receiver_name, receiver_phone, province, city, district, detail_address, is_default)
values
(1, '王浩宇', '13800138001', '广东省', '深圳市', '南山区', '科技南路18号深圳湾科技生态园9栋', 1),
(2, '陈思琪', '13900139002', '浙江省', '杭州市', '余杭区', '仓前街道文一西路1500号未来科技城', 1),
(3, '刘阳', '13700137003', '山东省', '济南市', '历城区', '工业北路188号普洛斯物流园A区', 0),
(4, '张薇', '13600136004', '上海市', '浦东新区', '张江镇', '张江高科技园区博云路2号', 1),
(5, '邵杰', '13500135005', '北京市', '海淀区', '中关村街道', '中关村大街1号海龙大厦12层', 1);
-- 3. 商品收藏表（user_favorite）
drop table if exists user_favorite;
create table if not exists user_favorite (
  id bigint primary key auto_increment not null,  -- 主键ID
  user_id int not null,                           -- 用户ID
  product_id int not null,                        -- 商品ID
  shop_id bigint not null,                        -- 店铺ID
  create_time datetime default current_timestamp  -- 收藏时间
);

-- 插入10条收藏测试数据（关联新商品和新店铺）
insert into user_favorite (user_id, product_id, shop_id)
values
(1, 1, 1),
(1, 12, 4),
(2, 5, 2),
(2, 18, 5),
(3, 9, 3),
(3, 22, 1),
(4, 20, 1),
(4, 7, 2),
(5, 24, 3),
(5, 23, 2);
-- 4. 给你配套 最常用业务查询 SQL
-- ① 查询用户购物车（带商品、店铺、价格）sql
SELECT 
  c.*,
  p.product_name,
  p.price,
  p.image_url,
  s.shop_name
FROM cart c
LEFT JOIN product p ON c.product_id = p.product_id
LEFT JOIN shop s ON c.shop_id = s.id
WHERE c.user_id = 1;
-- ② 查询用户默认收货地址sql
SELECT * FROM user_address 
WHERE user_id = 1 AND is_default = 1;
-- ③ 查询用户收藏的商品sql
SELECT 
  f.*,
  p.product_name,
  p.price,
  p.image_url
FROM user_favorite f
LEFT JOIN product p ON f.product_id = p.product_id
WHERE f.user_id = 1;
