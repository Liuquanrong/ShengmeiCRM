package com.quanrong.settings.service;

import com.quanrong.Exception.LoginException;
import com.quanrong.settings.domain.User;


public interface UserService {
    User login(String loginAct,String loginPwd,String ip) throws LoginException;
}
