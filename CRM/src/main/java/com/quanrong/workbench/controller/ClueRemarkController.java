package com.quanrong.workbench.controller;

import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.ClueRemark;
import com.quanrong.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("clueRemark")
public class ClueRemarkController {

    @Resource
    ClueRemarkService remarkService;

    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public int doSaveRemark(ClueRemark remark){
        int result = remarkService.addRemark(remark);
        return result;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public PaginationVO<ClueRemark> doPageList(HttpServletRequest request){
        Map<String,String> map = new HashMap<>();
        map.put("clueId",request.getParameter("clueId"));
        map.put("pageNo",request.getParameter("pageNo"));
        map.put("pageSize",request.getParameter("pageSize"));
        PaginationVO<ClueRemark> vo = remarkService.getPageList(map);
        return vo;
    }

    @RequestMapping("/delRemark.do")
    @ResponseBody
    public int doDelRemark(String id){
        int result = remarkService.delRemark(id);
        return result;
    }

    @RequestMapping("/getRemark.do")
    @ResponseBody
    public ClueRemark doGetRemark(String id){
        ClueRemark remark = remarkService.getRemark(id);
        return remark;
    }

    @RequestMapping("/editRemark.do")
    @ResponseBody
    public int doEditRemark(ClueRemark remark){
        int result = remarkService.editRemark(remark);
        return result;
    }
}
