package com.njit.crm.workbench.dao;


import com.njit.crm.workbench.domain.Clue;

public interface ClueDao {


    int save(Clue c);

    Clue detail(String id);


}
