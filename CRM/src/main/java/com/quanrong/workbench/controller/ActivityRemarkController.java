package com.quanrong.workbench.controller;

import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.ActivityRemark;
import com.quanrong.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

@Controller
@RequestMapping("activityRemark")
public class ActivityRemarkController {
    @Resource
    ActivityRemarkService service;
    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public int doSaveActivityRemark(ActivityRemark remark){
        int result = service.saveRemark(remark);
        return result;
    }
    @RequestMapping("pageList.do")
    @ResponseBody
    public PaginationVO doPageList(String activityId, String pageNo, String pageSize){
        PaginationVO vo = service.getPageList(activityId,pageNo,pageSize);
        return vo;
    }
}
