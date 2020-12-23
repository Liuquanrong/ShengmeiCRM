package com.quanrong.workbench.service.Impl;

import com.quanrong.workbench.dao.DicTypeDao;
import com.quanrong.workbench.dao.DicValueDao;
import com.quanrong.workbench.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class DicServiceImpl implements DicService {
    @Resource
    DicTypeDao typeDao;
    @Resource
    DicValueDao valueDao;
}
