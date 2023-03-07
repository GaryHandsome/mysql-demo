package org.mysql.dao.impl;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
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
            Object[] params = new Object[]{ staff.getName(),staff.getAge(),staff.getPhone(),staff.getPos()} ;
            // 第二：填充数据，并执行
            return qr.update(sql,params) ;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int delete(int id) {
        // 第一：定义要操作数据库的SQL语句
        String sql = "delete from staffs where id=?" ;
        try {
            // 第二：填充数据，并执行
            return qr.update(sql,id) ;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int update(Staff staff) {
        // 第一：定义要操作数据库的SQL语句
        String sql = "update staffs set name=?,age=?,phone=?,pos=? where id=?" ;
        try {
            Object[] params = new Object[]{ staff.getName(),staff.getAge(),staff.getPhone(),staff.getPos(),staff.getId()} ;
            // 第二：填充数据，并执行
            return qr.update(sql,params) ;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Staff> selectAll() {
        // 第一：定义要操作数据库的SQL语句
        // 注意：使用别名解决实体对象属性名和数据表字段名不一致的问题
        String sql = "select id,name,age,phone,pos,add_time as addTime from staffs" ;

        // 第二：填充数据，并执行
        // 查询是复杂 - 返回的结果是复杂多样的 - ResultSetHandler对象(接口) - 对查询的结果进行处理 - 根据查询的不同结果，定义相关实现类
        try {
            return qr.query(sql,new BeanListHandler<Staff>(Staff.class));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Staff selectById(int id) {
        // 第一：定义要操作数据库的SQL语句
        // 注意：使用别名解决实体对象属性名和数据表字段名不一致的问题
        String sql = "select id,name,age,phone,pos,add_time as addTime from staffs where id=?" ;

        // 第二：填充数据，并执行
        // 查询是复杂 - 返回的结果是复杂多样的 - ResultSetHandler对象(接口) - 对查询的结果进行处理 - 根据查询的不同结果，定义相关实现类
        try {
            // List<Staff> list = qr.query(sql,new BeanListHandler<Staff>(Staff.class));
            // return list!=null && list.size()==1?list.get(0):null ;
            return qr.query(sql,new BeanHandler<Staff>(Staff.class)) ;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
