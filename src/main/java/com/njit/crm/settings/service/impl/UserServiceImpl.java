package com.njit.crm.settings.service.impl;

import com.njit.crm.exception.loginException;
import com.njit.crm.settings.dao.UserDao;
import com.njit.crm.settings.domain.User;
import com.njit.crm.settings.service.UserService;
import com.njit.crm.utils.DateTimeUtil;
import com.njit.crm.utils.SqlSessionUtil;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {

    private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);


    public User login(String loginAct, String loginPwd, String ip) throws loginException {
        Map<String,String> map = new HashMap<String,String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user=userDao.login(map);

        if(user==null){

            throw new loginException("账号密码错误");
        }
        //如果程序能过成功的执行到该行，说明账号密码正确
        //需要继续向下验证其他3向信息
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if(expireTime.compareTo(currentTime)<0){
            throw new loginException("账号已失效");

        }
        //判断锁定状态
        String lockState = user.getLockState();
        if("0".equals(lockState)){
            throw new loginException("账号已锁定");
        }
        //判断ip地址
        String allowIps = user.getAllowIps();
        if(allowIps.contains(ip)){
            throw new loginException("ip地址受限，请练习管理员");
        }
        return user;
    }

    public List<User> getUserList() {

        List<User> ulist = userDao.getUserList();

        return ulist;
    }
}
