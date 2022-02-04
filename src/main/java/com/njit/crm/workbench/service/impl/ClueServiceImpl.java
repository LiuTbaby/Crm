package com.njit.crm.workbench.service.impl;

import com.njit.crm.utils.SqlSessionUtil;
import com.njit.crm.workbench.dao.ClueDao;
import com.njit.crm.workbench.service.ClueService;

public class ClueServiceImpl implements ClueService {

    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);

}
