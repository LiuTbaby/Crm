package com.njit.crm.settings.web.controller;

import com.njit.crm.settings.domain.User;
import com.njit.crm.settings.service.UserService;
import com.njit.crm.settings.service.impl.UserServiceImpl;
import com.njit.crm.utils.MD5Util;
import com.njit.crm.utils.PrintJson;
import com.njit.crm.utils.ServiceFactory;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {

    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到用户控制器");

        String path = request.getServletPath();

        if ("/settings/user/login.do".equals(path)) {
            login(request, response);
        } else if ("/settings/user/xxx.do".equals(path)) {

            //xxx(request,response);
        }
    }


    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到登录验证操作");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码明文形式转化为MD5的密文形式
        loginPwd = (String) MD5Util.getMD5(loginPwd);
        //接收浏览器端ip地址
        String ip = request.getRemoteAddr();
        System.out.println("-----------------ip:" + ip);
        //未来的业务层开发，统一使用代理态的接口对象
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());


        try {
            User user = us.login(loginAct, loginPwd, ip);

            request.getSession().setAttribute("user", user);

            //如果程序执行到此处，说明业务层没有为controller抛出任何异常
            //表示登录成功
            /*
            {"sucess" : true}
             */

            PrintJson.printJsonFlag(response, true);
        } catch (Exception e) {
            e.printStackTrace();
            //一旦程序了catch块的信息，说明业务层为我们验证失败，为controller抛出了异常
            /*
            {"sucess" : false,"msg" : ?}
             */
            String msg = e.getMessage();
            /*

             */
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("success", false);
            map.put("msg", msg);
            PrintJson.printJsonObj(response, map);
        }
    }
}
