package com.njit.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        System.out.println("进入到字符编码的过滤器");
        //过滤post请求中文参数乱码的过滤器
        req.setCharacterEncoding("utf-8");
        //过滤响应流响应中文乱码问题
        resp.setContentType("text/html;charset=utf-8");
        //将请求放行
        chain.doFilter(req,resp);
    }
}
