package com.quanrong.workbench.controller;

import com.quanrong.workbench.domian.DicType;
import com.quanrong.workbench.domian.DicValue;
import com.quanrong.workbench.service.DicService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("dic")
public class DicController {
    @Resource
    private DicService dicService;
    @RequestMapping("/getDicTypes.do")
    @ResponseBody
    public List<DicType> doGetDicType(){
        List<DicType> dicTypes = dicService.getDicTypes();
        return dicTypes;
    }

    @RequestMapping("getDicValueList.do")
    @ResponseBody
    public List<DicValue> doGetDicValueList(){
        List<DicValue> dicValueList = dicService.getDicValueList();
        return dicValueList;
    }
}
