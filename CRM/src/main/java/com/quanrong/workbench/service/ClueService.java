package com.quanrong.workbench.service;

import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.Clue;

import java.util.Map;

public interface ClueService {
    int addClue(Clue clue);

    PaginationVO<Clue> getPageList(Map<String, String> map);
}
