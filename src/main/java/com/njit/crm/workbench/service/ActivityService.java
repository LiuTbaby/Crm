package com.njit.crm.workbench.service;

import com.njit.crm.vo.PaginationVO;
import com.njit.crm.workbench.domain.Activity;

import java.util.Map;

public interface ActivityService {

    boolean save(Activity a);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity a);
}
