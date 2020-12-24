package com.quanrong.workbench.service.Impl;

import com.quanrong.workbench.dao.DicTypeDao;
import com.quanrong.workbench.dao.DicValueDao;
import com.quanrong.workbench.domian.DicType;
import com.quanrong.workbench.domian.DicValue;
import com.quanrong.workbench.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {
    @Resource
    DicTypeDao typeDao;
    @Resource
    DicValueDao valueDao;

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String,List<DicValue>> map = new HashMap<>();
        List<DicType> dicTypes = typeDao.getTypes();
        //遍历字典类型，根据字典类型获取类型对应的值
        for (DicType dicType : dicTypes){
            String typeCode = dicType.getCode();
            List<DicValue>  dicValues = valueDao.getValues(typeCode);
            map.put(typeCode,dicValues);
        }
        return map;
    }

    @Override
    public List<DicType> getDicTypes() {
        List<DicType> dicTypes = typeDao.getTypes();
        return dicTypes;
    }

    @Override
    public List<DicValue> getDicValueList() {
        List<DicValue> valueList = valueDao.getValueList();
        return valueList;
    }
}
