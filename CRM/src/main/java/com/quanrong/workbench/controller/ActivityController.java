package com.quanrong.workbench.controller;

import com.quanrong.VO.PaginationVO;
import com.quanrong.settings.domain.User;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

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
    @RequestMapping("/pageList.do")
    @ResponseBody
    public PaginationVO<Activity> doPageList(HttpServletRequest request){
        System.out.println("进入市场活动信息列表查询！");
        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
        Map map = new HashMap();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("name",request.getParameter("name"));
        map.put("owner",request.getParameter("owner"));
        map.put("startDate",request.getParameter("startDate"));
        map.put("endDate",request.getParameter("endDate"));
        PaginationVO<Activity> vo = service.pageList(map);
        return vo;
    }
    @RequestMapping("/delActivity.do")
    @ResponseBody
    public int doDelActivity(HttpServletRequest request){
        String[] ids = request.getParameterValues("ids");
        int result = service.delActivity(ids);
        return result;
    }
    @RequestMapping("/getActivity.do")
    @ResponseBody
    public Map<String,Object> doGetActivity(String id){
        Map<String,Object> map = new HashMap<>();
        List<User> userList = service.getUserList();
        Activity activity = service.getActivity(id);
        map.put("userList",userList);
        map.put("activity",activity);
        return map;
    }
    @RequestMapping("/editActivity.do")
    @ResponseBody
    public int doEditActivity(Activity activity){
        int result = service.editActivity(activity);
        return result;
    }
}
