package com.example.team.controller;

import com.example.team.pojo.DTO.IngredientDTO;
import com.example.team.pojo.Result;
import com.example.team.services.FoodMaterialService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/food")

public class FoodMaterialController {
    @Resource
    FoodMaterialService foodMaterialService;




    @PostMapping("/add")
    public Result addIngredient(@RequestParam("ingredient_name") String ingredientName,
                                @RequestParam("expiration_period") String expirationPeriod,
                                @RequestParam String comment,
                                @RequestParam Integer number,
                                @RequestParam String avatar,
                                @RequestParam String category){
        IngredientDTO dto = new IngredientDTO();
        dto.setIngredientName(ingredientName);
        dto.setExpirationPeriod(expirationPeriod);
        dto.setComment(comment);
        dto.setNumber(number);
        dto.setAvatar(avatar);
        dto.setCategory(category);

        return foodMaterialService.add(dto);
    }
    @GetMapping("/get")
    public Result getIngredient(@RequestParam("food_id") Integer foodId){
        return foodMaterialService.get(foodId);
    }
    @PutMapping("/update")
    public  Result upadteIngredient(@RequestParam("ingredient_name") String ingredientName,
                                    @RequestParam("expiration_period") String expirationPeriod,
                                    @RequestParam String comment,
                                    @RequestParam Integer number,
                                    @RequestParam String avatar,
                                    @RequestParam String category,
    @RequestParam Integer id){

        return foodMaterialService.update(ingredientName,category,number,expirationPeriod,avatar,comment,id);
    }
    @GetMapping("/list")
    public Result getIngredientList(@RequestParam("page_size") Integer pageSize,@RequestParam("page_num") Integer pageNum){
        return foodMaterialService.getList(pageNum,pageSize);
    }
    @DeleteMapping("/delete")
    public Result deleteIngredient(@RequestParam("food_id") Integer foodId){
        return foodMaterialService.delete(foodId);
    }

}
