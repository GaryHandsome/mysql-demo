package org.mysql.test;

import org.mysql.dao.StaffDao;
import org.mysql.dao.impl.StaffDaoImpl;
import org.mysql.dao.impl.StaffDaoImpl4C3P0;
import org.mysql.entity.Staff;

import java.util.List;

/**
 * C3P0 + DbUtil的测试
 *
 * @Date 2023-03-06
 * @Author zqx
 */
public class MainTest02 {
    public static void main(String[] args) {

        // add();

        StaffDao staffDao = new StaffDaoImpl4C3P0();

        List<Staff> list = staffDao.selectAll();

        for (Staff staff : list) {
            System.out.println(staff);
        }
    }

    private static void add() {
        StaffDao staffDao = new StaffDaoImpl4C3P0();

        Staff staff = new Staff();
        staff.setName("李四");
        staff.setAge(28);
        staff.setPhone("120");
        staff.setPos("助理");

        int row = staffDao.insert(staff);
        System.out.println(row);
    }
}
