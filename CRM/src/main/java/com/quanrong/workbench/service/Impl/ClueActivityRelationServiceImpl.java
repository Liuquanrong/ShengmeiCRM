package com.quanrong.workbench.service.Impl;

import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ClueActivityRelationDao;
import com.quanrong.workbench.service.ClueActivityRelationService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
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
}
