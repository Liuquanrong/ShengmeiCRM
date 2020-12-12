package com.quanrong.settings.dao;

import com.quanrong.settings.domain.User;

public interface UserDao {
    User findUser(String loginAct,String loginPwd);
}
