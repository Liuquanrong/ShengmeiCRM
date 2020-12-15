package com.quanrong.workbench.controller;

import com.quanrong.VO.PaginationVO;
import com.quanrong.settings.domain.User;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("activity")
public class ActivityController {
    @Resource
    private ActivityService service;
    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> doGetUserList(){
        System.out.println("获取用户信息");
        List<User> userList = service.getUserList();
        return userList;
    }
    @RequestMapping("/saveActivity.do")
    @ResponseBody
    public int doSaveActivity(Activity activity){
        System.out.println("执行市场活动添加！");
        int result = service.saveActivity(activity);
        return result;
    }
//    @RequestMapping("/pageList.do")
//    @ResponseBody
//    public PaginationVO<Activity> doPageList(HttpServletRequest request){
//        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
//        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
//        Activity activity = new Activity();
//        Integer total = 0;
//        PaginationVO<Activity> vo = service.pageList(map);
//        return vo;
//    }
}
