package com.example.team.controller;

import com.example.team.pojo.DTO.IngredientDTO;
import com.example.team.pojo.DTO.MenuAddDTO;
import com.example.team.pojo.Result;
import com.example.team.services.MenuService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/menu")
public class MenuController {
    @Resource
    MenuService menuService;
    @PostMapping("/add")
    public Result addMenu(@RequestBody MenuAddDTO menuAddDTO) {

        return menuService.addMenu(menuAddDTO);
    }
    @GetMapping("/get")
    public Result getMenu(@RequestParam("menu_id") Integer menuId){
        return menuService.getMenu(menuId);
    }

    @GetMapping("/list")
    public Result getMenuList(@RequestParam("page_size") Integer pageSize,@RequestParam("page_num") Integer pageNum){
        return menuService.getMenuList(pageNum,pageSize);
    }
    @GetMapping("/ai")
    public  Result getMenuByAI(String userNeed, String like){
        return menuService.getMenuByAI(userNeed,like);
    }

}
