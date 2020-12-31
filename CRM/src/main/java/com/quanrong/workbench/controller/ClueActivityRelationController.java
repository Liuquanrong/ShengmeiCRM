package com.quanrong.workbench.controller;

import com.github.pagehelper.Page;
import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.service.ClueActivityRelationService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("ClueActivityRelation")
public class ClueActivityRelationController {
    @Resource
    ClueActivityRelationService relationService;

    @RequestMapping("/addRelation.do")
    @ResponseBody
    public int doAddRelation(String[] ActivityIds,String clueId){
        int result = relationService.addRelation(ActivityIds,clueId);
        return result;
    }

    @RequestMapping("/delActivityBund.do")
    @ResponseBody
    public int doDelActivityBund(String id){
        int result = relationService.delActivityBund(id);
        return result;
    }

    @RequestMapping("/getBundActivity.do")
    @ResponseBody
    public List<Activity> doGetBundActivity(String clueId){
        List<Activity> activityList = relationService.getBundActivity(clueId);
        return activityList;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public PaginationVO<Activity> doPageList(HttpServletRequest request){
        Map<String,String> map = new HashMap<>();
        map.put("pageNo",request.getParameter("pageNo"));
        map.put("pageSize",request.getParameter("pageSize"));
        map.put("name",request.getParameter("name"));
        map.put("clueId",request.getParameter("clueId"));
        PaginationVO<Activity> vo = relationService.getPageList(map);
        return vo;
    }
}
