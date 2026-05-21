/*
 Navicat Premium Data Transfer

 Source Server         : 本地MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Database       : htny

 Target Server Type    : MYSQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 2025-01-01 00:00:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 部门表 sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 COMMENT='部门表';

-- ----------------------------
-- 初始化部门数据
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '总公司', 0, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);
INSERT INTO `sys_dept` VALUES (105, 100, '0,100', '杭州分公司', 2, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);
INSERT INTO `sys_dept` VALUES (106, 105, '0,100,105', '财务部门', 1, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);
INSERT INTO `sys_dept` VALUES (107, 105, '0,100,105', '运维部门', 2, 'admin', '15888888888', 'admin@qq.com', '0', '0', 'admin', sysdate(), '', NULL);

-- ----------------------------
-- 2. 用户表 sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `login_name` varchar(30) NOT NULL COMMENT '登录账号',
  `user_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT NULL COMMENT '用户类型',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像路径',
  `password` varchar(50) DEFAULT '' COMMENT '密码',
  `salt` varchar(20) DEFAULT NULL COMMENT '盐加密',
  `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='用户信息表';

-- ----------------------------
-- 初始化用户数据（密码是 admin123，SHA256加密）
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 100, 'admin', '管理员', NULL, 'admin@qq.com', '15888888888', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sW/gJlHpkHi', 'abc123', '0', '0', '127.0.0.1', sysdate(), NULL, 'admin', sysdate(), '', NULL);
INSERT INTO `sys_user` VALUES (2, 103, 'test', '测试用户', NULL, 'test@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sW/gJlHpkHi', 'abc123', '0', '0', '127.0.0.1', sysdate(), NULL, 'admin', sysdate(), '', NULL);

-- ----------------------------
-- 3. 角色表 sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` varchar(10) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：所有数据权限；2：自定义数据权限；3：本部门数据权限；4：本部门及以下数据权限）',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='角色信息表';

-- ----------------------------
-- 初始化角色数据
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', '1', '1', '0', '0', 'admin', sysdate(), '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', '2', '2', '0', '0', 'admin', sysdate(), '', NULL, '普通角色');

-- ----------------------------
-- 4. 菜单权限表 sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) DEFAULT 0 COMMENT '显示顺序',
  `url` varchar(200) DEFAULT '#' COMMENT '请求地址',
  `menu_type` varchar(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000 COMMENT='菜单权限表';

-- ----------------------------
-- 初始化菜单数据
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, '#', 'M', '0', '', 'system', 'admin', sysdate(), '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, '#', 'M', '0', '', 'monitor', 'admin', sysdate(), '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, '#', 'M', '0', '', 'tool', 'admin', sysdate(), '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, '/system/user', 'C', '0', 'system:user:list', 'user', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, '/system/role', 'C', '0', 'system:role:list', 'role', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, '/system/menu', 'C', '0', 'system:menu:list', 'tree-table', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, '/system/dept', 'C', '0', 'system:dept:list', 'tree', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, '/system/post', 'C', '0', 'system:post:list', 'post', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, '/system/dict', 'C', '0', 'system:dict:list', 'dict', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, '/system/config', 'C', '0', 'system:config:list', 'config', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, '/system/notice', 'C', '0', 'system:notice:list', 'notice', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, '#', 'M', '0', '', 'log', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (109, '操作日志', 108, 1, '/monitor/operlog', 'C', '0', 'monitor:operlog:list', 'form', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (110, '登录日志', 108, 2, '/monitor/logininfor', 'C', '0', 'monitor:logininfor:list', 'logininfor', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (111, '在线用户', 108, 3, '/monitor/online', 'C', '0', 'monitor:online:list', 'online', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (112, '定时任务', 108, 4, '/monitor/job', 'C', '0', 'monitor:job:list', 'job', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (113, '数据监控', 108, 5, '/monitor/druid', 'C', '0', 'monitor:druid:list', 'druid', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (114, '代码生成', 3, 1, '/tool/build', 'C', '0', 'tool:build:list', 'code', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (115, '系统接口', 3, 2, '/tool/swagger', 'C', '0', 'tool:swagger:list', 'swagger', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (200, '用户新增', 100, 1, '#', 'F', '0', 'system:user:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (201, '用户修改', 100, 2, '#', 'F', '0', 'system:user:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (202, '用户删除', 100, 3, '#', 'F', '0', 'system:user:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (203, '重置密码', 100, 4, '#', 'F', '0', 'system:user:resetPwd', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (204, '角色新增', 101, 1, '#', 'F', '0', 'system:role:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (205, '角色修改', 101, 2, '#', 'F', '0', 'system:role:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (206, '角色删除', 101, 3, '#', 'F', '0', 'system:role:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (207, '菜单新增', 102, 1, '#', 'F', '0', 'system:menu:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (208, '菜单修改', 102, 2, '#', 'F', '0', 'system:menu:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (209, '菜单删除', 102, 3, '#', 'F', '0', 'system:menu:remove', '#', 'admin', sysdate(), '', NULL, '');
-- 物流管理菜单
INSERT INTO `sys_menu` VALUES (500, '物流管理', 0, 4, '#', 'M', '0', '', 'logistics', 'admin', sysdate(), '', NULL, '物流管理目录');
INSERT INTO `sys_menu` VALUES (501, '物流订单', 500, 1, '/logistics/list', 'C', '0', 'logistics:list', 'logistics', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (502, '物流查询', 500, 2, '/logistics/query', 'C', '0', 'logistics:query', 'search', 'admin', sysdate(), '', NULL, '');

-- ----------------------------
-- 5. 用户和角色关联表 sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB COMMENT='用户和角色关联表';

INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- 6. 角色和菜单关联表 sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB COMMENT='角色和菜单关联表';

-- 超级管理员拥有所有菜单权限
INSERT INTO `sys_role_menu` SELECT 1, `menu_id` FROM `sys_menu`;
-- 普通角色只拥有基础权限
INSERT INTO `sys_role_menu` SELECT 2, `menu_id` FROM `sys_menu` WHERE `menu_id` IN (100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 500, 501, 502);

-- ----------------------------
-- 7. 用户和岗位关联表 sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB COMMENT='用户和岗位关联表';

INSERT INTO `sys_user_post` VALUES (1, 5);
INSERT INTO `sys_user_post` VALUES (2, 4);

-- ----------------------------
-- 8. 角色和部门关联表 sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB COMMENT='角色和部门关联表';

INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 103);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- 9. 岗位表 sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 COMMENT='岗位信息表';

INSERT INTO `sys_post` VALUES (1, 'ceo', 'CEO', 1, '0', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'tl', '组长', 3, '0', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'dev', '开发人员', 4, '0', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_post` VALUES (5, 'pg', 'CEO助理', 5, '0', 'admin', sysdate(), '', NULL, '');

-- ----------------------------
-- 10. 字典类型表 sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='字典类型表';

INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', sysdate(), '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', sysdate(), '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', sysdate(), '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', sysdate(), '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', sysdate(), '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', sysdate(), '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知公告状态', 'sys_notice_status', '0', 'admin', sysdate(), '', NULL, '通知公告状态列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知公告类型', 'sys_notice_type', '0', 'admin', sysdate(), '', NULL, '通知公告类型列表');
INSERT INTO `sys_dict_type` VALUES (9, '物流状态', 'logistics_status', '0', 'admin', sysdate(), '', NULL, '物流状态列表');

-- ----------------------------
-- 11. 字典数据表 sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='字典数据表';

INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', sysdate(), '', NULL, '男性');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', sysdate(), '', NULL, '女性');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', sysdate(), '', NULL, '未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '显示按钮');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '隐藏按钮');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '暂停状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', '0', 'sys_job_group', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', '1', 'sys_job_group', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '正常');
INSERT INTO `sys_dict_data` VALUES (15, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '关闭');
INSERT INTO `sys_dict_data` VALUES (16, 1, '通知', '1', 'sys_notice_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (17, 2, '公告', '2', 'sys_notice_type', '', 'info', 'N', '0', 'admin', sysdate(), '', NULL, '公告');
-- 物流状态字典数据
INSERT INTO `sys_dict_data` VALUES (20, 1, '已发货', 'shipped', 'logistics_status', '', 'primary', 'Y', '0', 'admin', sysdate(), '', NULL, '已发货');
INSERT INTO `sys_dict_data` VALUES (21, 2, '运输中', 'in_transit', 'logistics_status', '', 'info', 'N', '0', 'admin', sysdate(), '', NULL, '运输中');
INSERT INTO `sys_dict_data` VALUES (22, 3, '派送中', 'delivering', 'logistics_status', '', 'warning', 'N', '0', 'admin', sysdate(), '', NULL, '派送中');
INSERT INTO `sys_dict_data` VALUES (23, 4, '已签收', 'signed', 'logistics_status', '', 'success', 'N', '0', 'admin', sysdate(), '', NULL, '已签收');
INSERT INTO `sys_dict_data` VALUES (24, 5, '拒收', 'rejected', 'logistics_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', NULL, '拒收');

-- ----------------------------
-- 12. 参数配置表 sys_config（保留原有配置）
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='参数配置表';

INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', sysdate(), '', NULL, '蓝色皮肤');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', sysdate(), '', NULL, '初始化密码');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', sysdate(), '', NULL, '深色侧边栏');
INSERT INTO `sys_config` VALUES (4, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_config` VALUES (5, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', sysdate(), '', NULL, '');

-- ----------------------------
-- 13. 通知公告表 sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `notice_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` varchar(2000) DEFAULT NULL COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 COMMENT='通知公告表';

INSERT INTO `sys_notice` VALUES (1, '系统升级公告', '2', '系统将于今晚进行升级维护，请提前保存好数据。', '0', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_notice` VALUES (2, '系统通知', '1', '新的物流查询功能已上线，欢迎使用！', '0', 'admin', sysdate(), '', NULL, '');

-- ----------------------------
-- 14. 操作日志记录表 sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求地址',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '操作地点',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int(1) DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`oper_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='操作日志记录表';

-- ----------------------------
-- 15. 系统访问记录表 sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `login_name` varchar(50) DEFAULT '' COMMENT '登录账号',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 COMMENT='系统访问记录表';

-- ----------------------------
-- 16. 定时任务调度表 sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) DEFAULT 'default' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT 'cron计划策略',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=10 COMMENT='定时任务调度表';

-- ----------------------------
-- 17. 定时任务调度日志表 sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0成功 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 COMMENT='定时任务调度日志表';

-- ----------------------------
-- 18. 代码生成业务表 gen_table（保留原有配置）
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作 sub主子表操作）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 COMMENT='代码生成业务表';

-- ----------------------------
-- 19. 代码生成业务表字段 gen_table_column（保留原有配置）
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` varchar(64) DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 COMMENT='代码生成业务表字段';

-- ----------------------------
-- 20. 物流表 logistics（保留原有配置）
-- ----------------------------
DROP TABLE IF EXISTS `logistics`;
CREATE TABLE `logistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '物流ID',
  `order_number` varchar(50) NOT NULL COMMENT '订单编号',
  `phone_number` varchar(20) DEFAULT NULL COMMENT '收货人手机号码',
  `onsignee` varchar(50) DEFAULT NULL COMMENT '收货人姓名',
  `shipping_address` varchar(100) NOT NULL COMMENT '目的地',
  `shipping_time` datetime DEFAULT NULL COMMENT '订单发货时间',
  `receive_time` datetime DEFAULT NULL COMMENT '订单收货时间',
  `order_goods` varchar(200) DEFAULT NULL COMMENT '订单商品',
  `order_amount` varchar(50) DEFAULT NULL COMMENT '订单金额',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`),
  KEY `idx_order_number` (`order_number`)
) ENGINE=InnoDB AUTO_INCREMENT=206 COMMENT='物流表';

-- ----------------------------
-- 21. 物流位置表 logistics_location（保留原有配置）
-- ----------------------------
DROP TABLE IF EXISTS `logistics_location`;
CREATE TABLE `logistics_location` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '物流位置ID',
  `logistics_id` int(11) NOT NULL COMMENT '物流ID',
  `order_status` varchar(10) NOT NULL COMMENT '物流状态',
  `current_location` varchar(100) NOT NULL COMMENT '当前位置',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `currents_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '当前位置时间',
  PRIMARY KEY (`id`),
  KEY `logistics_id` (`logistics_id`),
  CONSTRAINT `logistics_location_ibfk_1` FOREIGN KEY (`logistics_id`) REFERENCES `logistics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 COMMENT='物流位置表';

-- ----------------------------
-- Quartz相关表（保留原有配置）
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组',
  `blob_data` blob COMMENT 'blob类型触发器',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`trigger_name`,`trigger_group`)
) ENGINE=InnoDB COMMENT='blob类型的触发器表';

DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '日历',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB COMMENT='日历信息表';

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组',
  `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`trigger_name`,`trigger_group`)
) ENGINE=InnoDB COMMENT='cron类型的触发器表';

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) NOT NULL COMMENT '调度器实例ID',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发时间',
  `sched_time` bigint(13) NOT NULL COMMENT '计划时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) NOT NULL COMMENT '状态',
  `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) DEFAULT NULL COMMENT '任务组',
  `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`),
  KEY `idx_qrtz_fired_triggers_sched_name` (`sched_name`),
  KEY `idx_qrtz_fired_triggers_sched_name_gstate` (`sched_name`,`state`),
  KEY `idx_qrtz_fired_triggers_gstate` (`sched_name`,`state`),
  KEY `idx_qrtz_fired_triggers_next_fire_time` (`sched_name`,`next_fire_time`),
  KEY `idx_qrtz_fired_triggers_sched_name_gstate_next_fire_time` (`sched_name`,`state`,`next_fire_time`)
) ENGINE=InnoDB COMMENT='已触发的触发器表';

DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务所属组',
  `description` varchar(250) DEFAULT NULL COMMENT '详细介绍',
  `job_class_name` varchar(250) NOT NULL COMMENT '任务类名',
  `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发执行',
  `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '任务数据',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`),
  KEY `idx_qrtz_j_req_recovery` (`sched_name`,`requests_recovery`),
  KEY `idx_qrtz_j_grp` (`sched_name`,`job_group`)
) ENGINE=InnoDB COMMENT='任务详情表';

DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`),
  KEY `sched_name` (`sched_name`,`lock_name`)
) ENGINE=InnoDB COMMENT='锁信息表';

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器组名称',
  PRIMARY KEY (`sched_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`trigger_group`)
) ENGINE=InnoDB COMMENT='暂停的触发器组表';

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔',
  PRIMARY KEY (`sched_name`,`instance_name`),
  KEY `sched_name` (`sched_name`,`instance_name`)
) ENGINE=InnoDB COMMENT='调度器状态表';

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复次数',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复间隔',
  `times_triggered` bigint(10) NOT NULL COMMENT '已触发次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`trigger_name`,`trigger_group`)
) ENGINE=InnoDB COMMENT='简单触发器表';

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组',
  `str_prop_1` varchar(512) DEFAULT NULL COMMENT '字符串类型属性1',
  `str_prop_2` varchar(512) DEFAULT NULL COMMENT '字符串类型属性2',
  `str_prop_3` varchar(512) DEFAULT NULL COMMENT '字符串类型属性3',
  `int_prop_1` int(11) DEFAULT NULL COMMENT '整数类型属性1',
  `int_prop_2` int(11) DEFAULT NULL COMMENT '整数类型属性2',
  `long_prop_1` bigint(20) DEFAULT NULL COMMENT '长整数类型属性1',
  `long_prop_2` bigint(20) DEFAULT NULL COMMENT '长整数类型属性2',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT '小数类型属性1',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT '小数类型属性2',
  `bool_prop_1` varchar(1) DEFAULT NULL COMMENT '布尔类型属性1',
  `bool_prop_2` varchar(1) DEFAULT NULL COMMENT '布尔类型属性2',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`trigger_name`,`trigger_group`)
) ENGINE=InnoDB COMMENT='同步触发器表';

DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组',
  `job_name` varchar(200) NOT NULL COMMENT '任务名字',
  `job_group` varchar(200) NOT NULL COMMENT '任务所属组',
  `description` varchar(250) DEFAULT NULL COMMENT '详细介绍',
  `next_fire_time` bigint(13) DEFAULT NULL COMMENT '下次触发时间',
  `prev_fire_time` bigint(13) DEFAULT NULL COMMENT '上次触发时间',
  `priority` int(11) DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) NOT NULL COMMENT '触发器类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) DEFAULT NULL COMMENT '日历名称',
  `misfire_instr` smallint(2) DEFAULT NULL COMMENT '补偿执行策略',
  `job_data` blob COMMENT '任务数据',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`trigger_name`,`job_name`,`job_group`),
  KEY `idx_qrtz_t_gstate` (`sched_name`,`trigger_group`,`trigger_state`),
  KEY `idx_qrtz_t_next_fire_time` (`sched_name`,`next_fire_time`),
  KEY `idx_qrtz_t_nft_st` (`sched_name`,`trigger_name`,`trigger_group`,`trigger_state`),
  KEY `idx_qrtz_t_nft_misfire` (`sched_name`,`next_fire_time`,`misfire_instr`),
  KEY `idx_qrtz_t_nft_st_misfire` (`sched_name`,`next_fire_time`,`trigger_state`,`misfire_instr`),
  KEY `idx_qrtz_t_nft_st_misfire_gstate` (`sched_name`,`next_fire_time`,`trigger_state`,`misfire_instr`,`trigger_group`),
  KEY `idx_qrtz_t_prev_fire_time` (`sched_name`,`prev_fire_time`),
  KEY `idx_qrtz_t_trig_clob` (`sched_name`,`trigger_name`,`trigger_group`,`blob_data`)
) ENGINE=InnoDB COMMENT='触发器表';

SET FOREIGN_KEY_CHECKS = 1;
