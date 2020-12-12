package com.quanrong.settings.service.Impl;

import com.quanrong.settings.dao.UserDao;
import com.quanrong.settings.domain.User;
import com.quanrong.settings.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;
    @Override
    public User findUser(String loginAct,String loginPwd) {
        User user = userDao.findUser(loginAct, loginPwd);
        return user;
    }
}
