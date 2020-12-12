package com.quanrong.settings.controller;

import com.quanrong.settings.domain.User;
import com.quanrong.settings.service.UserService;
import com.quanrong.utils.DateUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("user")
public class UserController {
    @Resource
    private UserService service;
    @RequestMapping(value = "/login.do",produces = "text/plain;charset=utf-8")
    @ResponseBody
    public String doLogin(String loginAct, String loginPwd, HttpServletRequest request){

        User user = service.findUser(loginAct,loginPwd);
        if (user==null){
            return "{\"success\":false,\"msg\":\"错误的用户名或密码！\"}";
        }else if ("0".equals(user.getLockState())){
            return "{\"success\":false,\"msg\":\"账户被锁定！\"}";
        }else if (user.getExpireTime().compareTo(DateUtil.getSystemTime())<=0){
            return "{\"success\":false,\"msg\":\"账户已超时失效！\"}";
        }else if (user.getAllowIps().contains(request.getHeader("X-Real-IP"))){
            return "{\"success\":false,\"msg\":\"非法ip地址！\"}";
        }
        return "{\"success\":true}";
    }
}
