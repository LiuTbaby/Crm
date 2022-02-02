package com.njit.settings.test;

import com.njit.crm.utils.DateTimeUtil;
import com.njit.crm.utils.MD5Util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class test1 {
    public static void main(String[] args) {
        //验证失效时间
//        String expriTime = "2018-10-10 10:10:10";
//        String currrentTime = DateTimeUtil.getSysTime();
//        int count= expriTime.compareTo(currrentTime);
//        System.out.println(count);


//        String lockState = "0";
//        if("0".equals(lockState)){
//            System.out.println("账号已锁定");
//        }

        //判断ip地址
//        String ip="192.168.1.4";
//        String allow = "192.168.1.1,192.168.1.2";
//        if(allow.contains(ip)){
//            System.out.println("有效的ip地址，允许访问系统");
//        }else{
//            System.out.println("ip地址受限，请练习管理员");
//        }


        String pwd="123";
        pwd = MD5Util.getMD5(pwd);
        System.out.println(pwd);
    }
}
