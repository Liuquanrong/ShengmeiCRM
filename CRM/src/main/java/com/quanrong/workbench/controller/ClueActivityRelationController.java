package com.quanrong.workbench.controller;

import com.quanrong.workbench.service.ClueActivityRelationService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
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
}
