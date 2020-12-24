package com.quanrong.workbench.service;

import com.quanrong.workbench.domian.DicType;
import com.quanrong.workbench.domian.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getAll();

    List<DicType> getDicTypes();

    List<DicValue> getDicValueList();
}
