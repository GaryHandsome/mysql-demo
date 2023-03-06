package org.mysql.dao.impl;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.mysql.dao.StaffDao;
import org.mysql.entity.Staff;
import org.mysql.util.C3P0Util;

import java.sql.SQLException;
import java.util.List;

/**
 * StaffDAO接口的实现类 - 基于C3P0 + DbUtils实现的数据库的增、删、改、查操作
 * @Date 2023-03-06
 * @Author zqx
 */
public class StaffDaoImpl4C3P0 implements StaffDao {

    // 实例化 QueryRunner 对象 - DbUtils工具的核心对象，对原生JDBC操作做了封装，用于执行SQL语句
    private QueryRunner qr = new QueryRunner(C3P0Util.getDataSource()) ;


    @Override
    public int insert(Staff staff) {
        // 第一：定义要操作数据库的SQL语句
        String sql = "insert into staffs(name,age,phone,pos) values (?,?,?,?)" ;
        try {
            // 第二：填充数据，并执行
            return qr.update(sql,staff.getName(),staff.getAge(),staff.getPhone(),staff.getPos()) ;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int delete(int id) {
        return 0;
    }

    @Override
    public int update(Staff staff) {
        return 0;
    }

    @Override
    public List<Staff> selectAll() {
        // 第一：定义要操作数据库的SQL语句
        // 注意：使用别名解决实体对象属性名和数据表字段名不一致的问题
        String sql = "select id,name,age,phone,pos,add_time as addTime from staffs" ;

        // 第二：填充数据，并执行
        try {
            return qr.execute(sql,new BeanListHandler<Staff>(Staff.class));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Staff selectById(int id) {
        return null;
    }
}
