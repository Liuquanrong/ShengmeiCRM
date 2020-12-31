package com.quanrong.workbench.service.Impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.quanrong.VO.PaginationVO;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ClueActivityRelationDao;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.service.ClueActivityRelationService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Resource
    ClueActivityRelationDao relationDao;


    @Override
    public int addRelation(String[] ActivityIds, String clueId) {
        int result = 0;
        for (int i = 0; i < ActivityIds.length; i ++){
            Map<String,String> map = new HashMap<>();
            map.put("id",UUIDUtil.getUUID());
            map.put("activityId",ActivityIds[i]);
            map.put("clueId",clueId);
            relationDao.addRelation(map);
            result ++;
        }
        return result;
    }

    @Override
    public int delActivityBund(String id) {
        int result = relationDao.delRelation(id);
        return result;
    }

    @Override
    public List<Activity> getBundActivity(String clueId) {
        List<Activity> activityList = relationDao.getBundActivity(clueId);
        return activityList;
    }

    @Override
    public PaginationVO<Activity> getPageList(Map<String, String> map) {
        PaginationVO<Activity> vo = new PaginationVO<>();
        Integer pageNo = Integer.valueOf(map.get("pageNo"));
        Integer pageSize = Integer.valueOf(map.get("pageSize"));
        Page page = PageHelper.startPage(pageNo,pageSize);
        List<Activity> activityList = relationDao.getActivityList(map);
        vo.setTotal((int) page.getTotal());
        vo.setDataList(activityList);
        return vo;
    }
}
