package com.quanrong.workbench.service.Impl;

import com.quanrong.workbench.dao.ClueDao;
import com.quanrong.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    ClueDao clueDao;
}
