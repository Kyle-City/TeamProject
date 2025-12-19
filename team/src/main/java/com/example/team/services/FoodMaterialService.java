package com.example.team.services;

import com.example.team.pojo.DTO.IngredientDTO;
import com.example.team.pojo.Result;

public interface FoodMaterialService {
    Result add(IngredientDTO ingredientDTO);
    Result get(Integer foodId);

    Result update(String name,String category,Integer quantity,String expirationTime,String avatar,String comment ,Integer id);

    Result delete(Integer foodId);

    Result getList(Integer pageNum, Integer pageSize);
}
