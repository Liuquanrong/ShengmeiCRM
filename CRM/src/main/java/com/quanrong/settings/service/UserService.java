package com.quanrong.settings.service;

import com.quanrong.Exception.LoginException;
import com.quanrong.settings.domain.User;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;


public interface UserService {
    User login(String loginAct,String loginPwd,String ip) throws LoginException;

    Map editPwd(Map<String,String> data, HttpServletRequest request);
}
