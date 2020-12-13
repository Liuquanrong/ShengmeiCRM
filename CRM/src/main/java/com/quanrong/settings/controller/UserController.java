package com.quanrong.settings.controller;

import com.quanrong.Exception.LoginException;
import com.quanrong.settings.domain.User;
import com.quanrong.settings.service.UserService;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("user")
public class UserController {
    @Resource
    private UserService service;
    @RequestMapping("/login.do")
    @ResponseBody
    public Map doLogin(String loginAct, String loginPwd, HttpServletRequest request){
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        System.out.println(ip);
        Map map = new HashMap<>();
        map.put("success",false);
        try {
            User user = service.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            map.replace("success",true);
        } catch (LoginException e) {
            map.put("msg",e.getMessage());
        }
        return map;
    }
}
