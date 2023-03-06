package org.mysql.util;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * 给程序提供数据源对象
 *
 * @Date 2023-03-06
 * @Author zqx
 */
public class C3P0Util {
    /**
     * 定义C3P0数据源对象 - 使用默认配置创建ComboPooledDataSource对象
     */
    private static ComboPooledDataSource cpds = new ComboPooledDataSource();

    // 使用某配置创建ComboPooledDataSource对象
    // private static ComboPooledDataSource cpds = new ComboPooledDataSource("other");

    public static DataSource getDataSource() {
        return cpds;
    }

    public static Connection getConnection() {
        try {
            return cpds.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
