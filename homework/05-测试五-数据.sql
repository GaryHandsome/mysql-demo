-- 创建数据库
DROP DATABASE IF EXISTS nfitjavadb ;
CREATE DATABASE IF NOT EXISTS nfitjavadb DEFAULT CHARACTER SET = 'utf8';

-- 进入数据库
USE nfitjavadb;

-- 创建Student 学生表
DROP TABLE IF EXISTS `Student`;
CREATE TABLE IF NOT EXISTS `Student`(
    `Sno` CHAR(3) NOT NULL COMMENT '学号(主码)',
    `Sname` CHAR(8) NOT NULL COMMENT '学生姓名',
    `Ssex` CHAR(2) NOT NULL  COMMENT '学生性别',
    `Sbirthday` DATETIME NULL COMMENT '学生出生年月',
    `Class` CHAR(5) NULL COMMENT '学生所在班级',
    PRIMARY KEY (`Sno`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Student`(`Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class`) VALUES ('108','曾华','男','1977-09-01','95033') ;
INSERT INTO `Student`(`Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class`) VALUES ('105','匡明','男','1975-10-02','95031') ;
INSERT INTO `Student`(`Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class`) VALUES ('107','王丽','女','1976-01-23','95033') ;
INSERT INTO `Student`(`Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class`) VALUES ('101','李军','男','1976-02-20','95033') ;
INSERT INTO `Student`(`Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class`) VALUES ('109','王芳','女','1975-02-10','95031') ;
INSERT INTO `Student`(`Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class`) VALUES ('103','陆君','男','1974-06-03','95031') ;

-- 创建教师表
DROP TABLE IF EXISTS `Teacher`;
CREATE TABLE IF NOT EXISTS `Teacher`(
    `Tno` CHAR(3) NOT NULL COMMENT '教工编号(主码)',
    `Tname` CHAR(4) NOT NULL COMMENT '教工姓名',
    `Tsex` CHAR(2) NOT NULL COMMENT '教工性别',
    `Tbirthday` DATETIME NULL COMMENT '教工出生年月',
    `Prof` CHAR(6) NULL COMMENT '职称',
    `Depart` VARCHAR(10) NOT NULL COMMENT '教工所在部门',
    PRIMARY KEY (`Tno`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Teacher`(`Tno`,`Tname`,`Tsex`,`Tbirthday`,`Prof`,`Depart`) VALUES ('804','李诚','男','1958-12-02','副教授','计算机系');
INSERT INTO `Teacher`(`Tno`,`Tname`,`Tsex`,`Tbirthday`,`Prof`,`Depart`) VALUES ('856','张旭','男','1969-03-12','讲师','电子工程系');
INSERT INTO `Teacher`(`Tno`,`Tname`,`Tsex`,`Tbirthday`,`Prof`,`Depart`) VALUES ('825','王萍','女','1972-05-05','助教','计算机系');
INSERT INTO `Teacher`(`Tno`,`Tname`,`Tsex`,`Tbirthday`,`Prof`,`Depart`) VALUES ('831','刘冰','女','1977-08-14','助教','电子工程系');



-- 创建课程表
DROP TABLE IF EXISTS `Course`;
CREATE TABLE IF NOT EXISTS `Course` (
    `Cno` CHAR(5) NOT NULL COMMENT '课程号(主码)',
    `Cname` VARCHAR(10) NOT NULL COMMENT '课程名称',
    `Tno` CHAR(3) NOT NULL COMMENT '教工编号(外码)',
    PRIMARY KEY (`Cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

-- 外键
ALTER TABLE `Course` ADD CONSTRAINT `FK_Course_Tno`
    FOREIGN KEY(`Tno`)
        REFERENCES `Teacher`(`Tno`);

INSERT INTO `Course` (`Cno`,`Cname`,`Tno`) VALUES ('3-105','计算机导论','825') ;
INSERT INTO `Course` (`Cno`,`Cname`,`Tno`) VALUES ('3-245','操作系统','804') ;
INSERT INTO `Course` (`Cno`,`Cname`,`Tno`) VALUES ('6-166','数字电路','856') ;
INSERT INTO `Course` (`Cno`,`Cname`,`Tno`) VALUES ('9-888','高等数学','831');


-- 创建成绩表
DROP TABLE IF EXISTS `Score`;
CREATE TABLE IF NOT EXISTS `Score`(
    `Sno` CHAR(3) NOT NULL COMMENT '学号(外码)',
    `Cno` CHAR(5) NOT NULL COMMENT '课程号(外码)',
    `Degree` DECIMAL(4,1) NULL COMMENT '成绩',

    -- 复合主键
    PRIMARY KEY(Sno,Cno),

    -- 外键
    CONSTRAINT `FK_Score_Sno` FOREIGN KEY(`Sno`) REFERENCES `Student`(Sno),
    CONSTRAINT `FK_Score_Cno` FOREIGN KEY(`Cno`) REFERENCES `Course` (Cno)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 ;


INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('103','3-245',86) ;
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('105','3-245',75);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('109','3-245',68);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('103','3-105',92);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('105','3-105',88);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('109','3-105',76);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('101','3-105',64);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('107','3-105',91);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('108','3-105',78);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('101','6-166',85);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('107','6-166',79);
INSERT INTO `Score`(`Sno`,`Cno`,`Degree`) VALUES ('108','6-166',81);



SELECT `Sno`,`Sname`,`Ssex`,`Sbirthday`,`Class` FROM `Student`;
SELECT `Tno`,`Tname`,`Tsex`,`Tbirthday`,`Prof`,`Depart` FROM `Teacher` ;
SELECT `Cno`,`Cname`,`Tno` FROM `Course` ;
SELECT `Sno`,`Cno`,`Degree` FROM `Score` ;



