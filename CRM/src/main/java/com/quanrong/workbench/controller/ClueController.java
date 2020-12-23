package com.quanrong.workbench.controller;

import com.quanrong.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

@Controller
@RequestMapping("clue")
public class ClueController {
    @Resource
    ClueService clueService;
}
