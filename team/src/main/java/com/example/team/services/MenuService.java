package com.example.team.services;

import com.example.team.pojo.DTO.MenuAddDTO;
import com.example.team.pojo.Result;

public interface MenuService {
    Result addMenu(MenuAddDTO menuAddDTO);

    Result getMenu(Integer menu_id);

    Result getMenuList(Integer pageNum,Integer pageSize);

    Result getMenuByAI(String userNeed,String like);
}
