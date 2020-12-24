package com.quanrong.workbench.service.Impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.quanrong.VO.PaginationVO;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ClueDao;
import com.quanrong.workbench.domian.Clue;
import com.quanrong.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    ClueDao clueDao;

    @Override
    public int addClue(Clue clue) {
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateUtil.getSystemTime());
        int result = clueDao.addClue(clue);
        return result;
    }

    @Override
    public PaginationVO<Clue> getPageList(Map<String, String> map) {
        PaginationVO<Clue> vo = new PaginationVO<>();
        Integer pageNo = Integer.valueOf(map.get("pageNo"));
        Integer pageSize = Integer.valueOf(map.get("pageSize"));
        Page page = PageHelper.startPage(pageNo,pageSize);
        vo.setTotal((int) page.getTotal());
        List<Clue> clueList = clueDao.getClueList(map);
        vo.setDataList(clueList);
        return null;
    }
}
