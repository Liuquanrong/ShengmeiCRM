package com.quanrong.settings.service.Impl;

import com.quanrong.Exception.LoginException;
import com.quanrong.settings.dao.UserDao;
import com.quanrong.settings.domain.User;
import com.quanrong.settings.service.UserService;
import com.quanrong.utils.DateUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;
    @Override
    public User login(String loginAct,String loginPwd,String ip) throws LoginException {
        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);
        if (user==null){
            throw new LoginException("账号密码错误！");
        }else if (DateUtil.getSystemTime().compareTo(user.getExpireTime())>=0){
            throw new LoginException("账号超时，已失效！");
        }else if ("0".equals(user.getLockState())){
            throw new LoginException("账号已锁定！");
        }else if (!user.getAllowIps().contains(ip)){
            throw new LoginException("非法的IP地址访问！");
        }
        return user;
    }
}
