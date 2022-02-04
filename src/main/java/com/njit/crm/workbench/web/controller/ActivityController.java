package com.njit.crm.workbench.web.controller;

import com.njit.crm.settings.domain.User;
import com.njit.crm.settings.service.UserService;
import com.njit.crm.settings.service.impl.UserServiceImpl;
import com.njit.crm.utils.*;
import com.njit.crm.vo.PaginationVO;
import com.njit.crm.workbench.domain.Activity;
import com.njit.crm.workbench.domain.ActivityRemark;
import com.njit.crm.workbench.service.ActivityService;
import com.njit.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {

    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到市场活动控制器");

        String path = request.getServletPath();

        if ("/workbench/activity/getUserList.do".equals(path)) {
            getUserList(request, response);
        } else if ("/workbench/activity/save.do".equals(path)) {

            save(request,response);
        }else if ("/workbench/activity/pageList.do".equals(path)) {

            pageList(request,response);
        }else if ("/workbench/activity/delete.do".equals(path)) {

            delete(request,response);
        }else if ("/workbench/activity/getUserListAndActivity.do".equals(path)) {

            getUserListAndActivity(request,response);
        }else if ("/workbench/activity/update.do".equals(path)) {

            update(request,response);
        }else if ("/workbench/activity/detail.do".equals(path)) {

            detail(request,response);
        }else if ("/workbench/activity/getRemarkListByAid.do".equals(path)) {

            getRemarkListByAid(request,response);
        }else if ("/workbench/activity/deleteRemark.do".equals(path)) {

            deleteRemark(request,response);
        }else if ("/workbench/activity/saveRemark.do".equals(path)) {

            saveRemark(request,response);
        }else if ("/workbench/activity/updateRemark.do".equals(path)) {

            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行修改备注操作");

        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ActivityRemark ar = new ActivityRemark();
        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ar.setEditTime(editTime);
        ar.setEditBy(editBy);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = as.updateRemark(ar);

        Map<String,Object> map = new HashMap<>();

        map.put("success",flag);
        map.put("ar",ar);

        PrintJson.printJsonObj(response,map);


    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行添加备注操作");

        String noteContent = request.getParameter("noteContent");
        String activityId = request.getParameter("activityId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ActivityRemark ar = new ActivityRemark();
        ar.setActivityId(activityId);
        ar.setNoteContent(noteContent);
        ar.setCreateBy(createBy);
        ar.setEditFlag(editFlag);
        ar.setId(id);
        ar.setCreateTime(createTime);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.saveRemark(ar);

        Map<String,Object> map = new HashMap<>();

        map.put("success",flag);
        map.put("ar",ar);

        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除备注操作");

        String id = request.getParameter("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.deleteRemark(id);

        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByAid(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据市场活动id取得备注信息列表");

        String activityId = request.getParameter("activityId");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<ActivityRemark>arList = as.getRemarkListByAid(activityId);

        PrintJson.printJsonObj(response,arList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到跳转到详细信息页的操作");

        String id = request.getParameter("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        Activity a = as.detail(id);

        request.setAttribute("a",a);

        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);

    }

    private void update(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动修改操作");
        String id = request.getParameter("id");
        String owner =request.getParameter("owner");
        String name =request.getParameter("name");
        String startDate =request.getParameter("startDate");
        String endDate =request.getParameter("endDate");
        System.out.println(endDate);
        String cost =request.getParameter("cost");
        String description =request.getParameter("description");
        //修改时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人
        String editBy =((User)request.getSession().getAttribute("user")).getName();

        Activity a = new Activity();
        a.setId(id);
        a.setOwner(owner);
        a.setName(name);
        a.setStartDate(startDate);
        a.setEndDate(endDate);
        a.setCost(cost);
        a.setDescription(description);
        a.setEditBy(editBy);
        a.setEditTime(editTime);


        ActivityService as= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag=as.update(a);

        PrintJson.printJsonFlag(response,flag);

    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到查询用户信息列表和根据市场活动查询单条记录的操作");

        String id = request.getParameter("id");
        System.out.println(id);
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
            返回是什么主要看前端要什么，复用率不高就使用map即可
         */
        Map<String,Object> map= as.getUserListAndActivity(id);

        PrintJson.printJsonObj(response,map);

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动的删除操作");
        String ids[] = request.getParameterValues("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

         boolean flag = as.delete(ids);

         PrintJson.printJsonFlag(response,flag);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动信息列表操作（结合条件查询+分页查询）");

        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo=Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
        //计算略过的记录数
        int skipCount=(pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<String,Object>();
                map.put("name",name);
                map.put("owner",owner);
                map.put("startDate",startDate);
                map.put("endDate",endDate);
                map.put("skipCount",skipCount);
                map.put("pageSize",pageSize);

                ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

                /*
                    前端要，市场活动信息列表
                           查询的总条数

                           业务层拿到以上两条信息之后，如何做返回
                           map
                           map.put("dataList":dataList)
                           map.put("total" : total)
                           PrintJSON map
                            {"total" : 100,"datalist":[{市场活动1}，{市场活动2}，{3}]}


                           vo
                           PaginationVO<T>
                                private int total;
                                private List<T> dataList;


                           PaginationVO<Activity> vo = new PaginationVO<>;
                           vo.setTotal(total)
                           vo.setDataList(tataList)
                           PrintJSON vo -->json

                           将来分页查询，每个模块都有，所以选择使用通用VO操作起来比较方便
                           {"total" : 100,"datalist":[{市场活动1}，{市场活动2}，{3}]}

                 */

                PaginationVO<Activity> vo = as.pageList(map);

                PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动添加操作");
        String id = UUIDUtil.getUUID();
        String owner =request.getParameter("owner");
        String name =request.getParameter("name");
        String startDate =request.getParameter("startDate");
        String endDate =request.getParameter("endDate");
        String cost =request.getParameter("cost");
        String description =request.getParameter("description");
        //创建时间
        String createTime = DateTimeUtil.getSysTime();
        //创建人
        String createBy =((User)request.getSession().getAttribute("user")).getName();

        Activity a = new Activity();
        a.setId(id);
        a.setOwner(owner);
        a.setName(name);
        a.setStartDate(startDate);
        a.setEndDate(endDate);
        a.setCost(cost);
        a.setDescription(description);
        a.setCreateBy(createBy);
        a.setCreateTime(createTime);

        ActivityService as= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag=as.save(a);

        PrintJson.printJsonFlag(response,flag);


    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得用户信息列表");

        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> ulist = us.getUserList();

        PrintJson.printJsonObj(response,ulist);

    }


}
