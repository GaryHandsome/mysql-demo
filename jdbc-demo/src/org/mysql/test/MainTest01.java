package org.mysql.test;

import org.mysql.dao.StaffDao;
import org.mysql.dao.impl.StaffDaoImpl;
import org.mysql.entity.Staff;

/**
 * @Date 2023-03-06
 * @Author zqx
 */
public class MainTest01 {
    public static void main(String[] args) {

        StaffDao staffDao = new StaffDaoImpl();

        Staff staff = new Staff();
        staff.setName("张三");
        staff.setAge(18);
        staff.setPhone("110");
        staff.setPos("教授");

        int row = staffDao.insert(staff);
        System.out.println(row);
    }
}
