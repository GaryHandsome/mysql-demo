package org.mysql.dao.impl;

import org.mysql.dao.StaffDao;
import org.mysql.entity.Staff;
import org.mysql.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

/**
 * StaffDAO接口的实现类
 *
 * @Date 2023-03-06
 * @Author zqx
 */
public class StaffDaoImpl implements StaffDao {
    @Override
    public int insert(Staff staff) {
        int r = 0 ;

        // 第一：定义要操作的SQL语句
        String sql = "insert into staffs(name,age,phone,pos) values (?,?,?,?)" ;

        // 第二：获取连接对象
        Connection conn = DbUtil.getConnection();

        PreparedStatement ps = null ;
        try {
            // 第三：预编译SQL语句
            ps = conn.prepareStatement(sql);

            // 第四：填充参数 - 语句对象.setXxx(索引,数据)
            ps.setString(1,staff.getName());
            ps.setInt(2,staff.getAge());
            ps.setString(3,staff.getPhone());
            ps.setString(4,staff.getPos());

            // 第五：执行SQL语句
            // 语句对象.executeQuery()：增、删、改
            // 语句对象.executeUpdate() ：查询
            r = ps.executeUpdate();

            // 第六：对象结果进行处理
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            // 第七：关闭对象
            DbUtil.close(null,ps,conn);
        }
        return r;
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
        return null;
    }

    @Override
    public Staff selectById(int id) {
        return null;
    }
}
