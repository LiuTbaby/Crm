package com.njit.crm.web.listener;

import com.njit.crm.settings.domain.DicValue;
import com.njit.crm.settings.service.DicService;
import com.njit.crm.settings.service.impl.DicServiceImpl;
import com.njit.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SysInitListener implements ServletContextListener {

/*
    该方法是用来监听上下文域对象的方法，当服务器启动，上下文域对象创建
    对象创建完毕后，马上执行该方法
 */
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("服务器缓存处理数据字典开始");
        ServletContext application= event.getServletContext();

        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());

        //取数据字典
        Map<String, List<DicValue>> map = ds.getAll();
        //将map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for(String key:set){

            application.setAttribute(key,map.get(key));

        }

        System.out.println("服务器缓存处理数据字典结束");

    }

}






















