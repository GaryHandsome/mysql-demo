package org.mysql.dao;

import org.mysql.entity.Staff;

import java.util.List;

/**
 * 员工 DAO 接口 - 描述了 staff 表进行的相关数据库操作
 *
 * @Date 2023-03-06
 * @Author zqx
 */
public interface StaffDao {
    /**
     * 添加
     *
     * @param staff
     * @return
     */
    int insert(Staff staff);

    /**
     * 删除
     *
     * @param id
     * @return
     */
    int delete(int id);

    /**
     * 修改
     *
     * @param staff
     * @return
     */
    int update(Staff staff);

    /**
     * 查询所有
     *
     * @return
     */
    List<Staff> selectAll();

    /**
     * 根据ID查询
     *
     * @param id
     * @return
     */
    Staff selectById(int id);
}
