package com.njit.crm.settings.service;

import com.njit.crm.exception.loginException;
import com.njit.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws loginException;

    List<User> getUserList();

}
