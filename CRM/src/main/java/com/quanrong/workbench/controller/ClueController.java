package com.quanrong.workbench.controller;

import com.quanrong.VO.PaginationVO;
import com.quanrong.settings.domain.User;
import com.quanrong.workbench.domian.Clue;
import com.quanrong.workbench.service.ActivityService;
import com.quanrong.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("clue")
public class ClueController {
    @Resource
    ClueService clueService;
    @Resource
    ActivityService activityService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> doGetUserList(){
        List<User> userList = activityService.getUserList();
        return userList;
    }

    @RequestMapping("/saveClue.do")
    @ResponseBody
    public int doSaveClue(Clue clue){
        int result = clueService.addClue(clue);
        return result;
    }

    @RequestMapping("pageList.do")
    @ResponseBody
    public PaginationVO<Clue> doPageList(HttpServletRequest request){
        Map<String,String> map = new HashMap<>();
        map.put("pageNo",request.getParameter("pageNo"));
        map.put("pageSize",request.getParameter("pageSize"));
        map.put("fullname",request.getParameter("fullname"));
        map.put("company",request.getParameter("company"));
        map.put("phone",request.getParameter("phone"));
        map.put("source",request.getParameter("source"));
        map.put("owner",request.getParameter("owner"));
        map.put("mphone",request.getParameter("mphone"));
        map.put("clueState",request.getParameter("cluState"));
        PaginationVO<Clue> vo = clueService.getPageList(map);
        return vo;
    }
}
