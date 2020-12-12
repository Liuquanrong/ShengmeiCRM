package com.quanrong.settings.service;

import com.quanrong.settings.domain.User;


public interface UserService {
    User findUser(String loginAct,String loginPwd);
}
