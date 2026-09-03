-- Personmis (人事管理系统) schema + seed data.
--
-- The original repository README references a `personmis.sql` bootstrap script
-- that is not committed. This file reconstructs the schema from the MyBatis
-- mapper XML files (src/main/resources/mappers) and the entity classes
-- (com.ch.personmis.entity) so the backend and the Python agent server can run
-- against a real database in the Cloud Agent environment.

CREATE DATABASE IF NOT EXISTS personmis
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE personmis;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS transfer;
DROP TABLE IF EXISTS quit;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS ausertable;
SET FOREIGN_KEY_CHECKS = 1;

-- 部门 (department)
CREATE TABLE department (
  id INT PRIMARY KEY AUTO_INCREMENT,
  dname VARCHAR(100),
  dtype VARCHAR(50),
  dtel VARCHAR(50),
  dfax VARCHAR(50),
  description VARCHAR(255),
  supdepartment INT,
  establishmentdate DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 岗位 (post)
CREATE TABLE post (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pname VARCHAR(100),
  ptype VARCHAR(50),
  organization INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 员工 (staff) - column order matches the positional INSERT in StaffMapper.xml
CREATE TABLE staff (
  id INT PRIMARY KEY AUTO_INCREMENT,
  sname VARCHAR(100),
  sex VARCHAR(10),
  birthday DATE,
  sid VARCHAR(30),
  depart_id INT,
  post_id INT,
  entrydate DATE,
  joinworkdate DATE,
  workform VARCHAR(50),
  staffsource VARCHAR(50),
  politicalstatus VARCHAR(50),
  nation VARCHAR(50),
  nativeplace VARCHAR(100),
  stel VARCHAR(50),
  semail VARCHAR(100),
  sheight DOUBLE,
  bloodtype VARCHAR(10),
  maritalstatus VARCHAR(20),
  registeredresidence VARCHAR(100),
  education VARCHAR(50),
  degree VARCHAR(50),
  university VARCHAR(100),
  major VARCHAR(100),
  graduationdate DATE,
  startdate DATE,
  enddate DATE,
  status VARCHAR(20),
  peroidopdate DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 调动 (transfer) - column order matches the positional INSERT in TransferMapper.xml
CREATE TABLE transfer (
  id INT PRIMARY KEY AUTO_INCREMENT,
  staff_id INT,
  sname VARCHAR(100),
  beforepost_id INT,
  afterpost_id INT,
  ttype VARCHAR(50),
  tdate DATE,
  opdate DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 离职 (quit) - column order matches the positional INSERT in QuitMapper.xml
CREATE TABLE quit (
  id INT PRIMARY KEY AUTO_INCREMENT,
  staff_id INT,
  sname VARCHAR(100),
  qtype VARCHAR(50),
  qdate DATE,
  opdate DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 管理员账号 (ausertable) - referenced by AdminMapper.xml login query
CREATE TABLE ausertable (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50),
  password VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- Seed data
-- ---------------------------------------------------------------------------
INSERT INTO ausertable (id, username, password) VALUES (1, 'admin', 'admin');

INSERT INTO department (id, dname, dtype, dtel, dfax, description, supdepartment, establishmentdate) VALUES
  (1, '总公司',   '总部',   '010-10000000', '010-10000001', '顶级部门',       1, '2000-01-01'),
  (2, '技术部',   '职能部门', '010-10000010', '010-10000011', '负责研发与运维', 1, '2005-06-01'),
  (3, '市场部',   '职能部门', '010-10000020', '010-10000021', '负责市场与营销', 1, '2006-03-15'),
  (4, '人力资源部', '职能部门', '010-10000030', '010-10000031', '负责人事管理',   1, '2004-09-10');

INSERT INTO post (id, pname, ptype, organization) VALUES
  (1, '后端工程师', '技术', 8),
  (2, '前端工程师', '技术', 5),
  (3, '测试工程师', '技术', 3),
  (4, '市场专员',   '营销', 6),
  (5, '市场经理',   '营销', 2),
  (6, '人事专员',   '管理', 4),
  (7, '财务专员',   '财务', 2);

INSERT INTO staff (id, sname, sex, birthday, sid, depart_id, post_id, entrydate, joinworkdate,
  workform, staffsource, politicalstatus, nation, nativeplace, stel, semail, sheight, bloodtype,
  maritalstatus, registeredresidence, education, degree, university, major, graduationdate,
  startdate, enddate, status, peroidopdate) VALUES
  (1, '张伟', '男', '1990-04-12', '110101199004120011', 2, 1, '2018-07-01', '2013-07-01',
   '全职', '社会招聘', '群众', '汉族', '北京', '13800000001', 'zhangwei@example.com', 175.5, 'A',
   '已婚', '北京市海淀区', '本科', '学士', '清华大学', '计算机科学与技术', '2013-06-30',
   NULL, NULL, '正常', NULL),
  (2, '李娜', '女', '1993-08-20', '110101199308200022', 2, 2, '2019-03-15', '2016-07-01',
   '全职', '校园招聘', '党员', '汉族', '上海', '13800000002', 'lina@example.com', 165.0, 'B',
   '未婚', '上海市浦东新区', '硕士', '硕士', '复旦大学', '软件工程', '2016-06-30',
   '2019-03-15', '2019-06-15', '试用', NULL),
  (3, '王强', '男', '1988-12-05', '110101198812050033', 3, 4, '2015-05-20', '2011-07-01',
   '全职', '社会招聘', '群众', '汉族', '广州', '13800000003', 'wangqiang@example.com', 180.0, 'O',
   '已婚', '广州市天河区', '本科', '学士', '中山大学', '市场营销', '2011-06-30',
   NULL, NULL, '正常', NULL),
  (4, '赵敏', '女', '1995-02-28', '110101199502280044', 4, 6, '2020-09-01', '2018-07-01',
   '全职', '校园招聘', '群众', '汉族', '成都', '13800000004', 'zhaomin@example.com', 168.0, 'AB',
   '未婚', '成都市武侯区', '本科', '学士', '四川大学', '人力资源管理', '2018-06-30',
   NULL, NULL, '正常', NULL);

INSERT INTO transfer (id, staff_id, sname, beforepost_id, afterpost_id, ttype, tdate, opdate) VALUES
  (1, 3, '王强', 4, 5, '晋升', '2021-01-10', '2021-01-10');

INSERT INTO quit (id, staff_id, sname, qtype, qdate, opdate) VALUES
  (1, 1, '张伟', '主动离职', '2023-11-30', '2023-11-30');
