package com.njit.crm.workbench.service.impl;

import com.njit.crm.utils.SqlSessionUtil;
import com.njit.crm.workbench.dao.ClueActivityRelationDao;
import com.njit.crm.workbench.dao.ClueDao;
import com.njit.crm.workbench.domain.Clue;
import com.njit.crm.workbench.service.ClueService;

public class ClueServiceImpl implements ClueService {

    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);

    public boolean save(Clue c) {

        boolean flag = true;

        int count = clueDao.save(c);

        if (count!=1){
            flag=false;
        }

        return flag;
    }

    public Clue detail(String id) {

        Clue clue=clueDao.detail(id);
        return clue;
    }

    public boolean unbund(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.unbund(id);

        if(count!=1){
            flag = false;
        }

        return flag;
    }
}
