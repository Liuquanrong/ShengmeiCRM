package com.quanrong.workbench.dao;

import com.quanrong.workbench.domian.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getValues(String code);

    List<DicValue> getValueList();
}
