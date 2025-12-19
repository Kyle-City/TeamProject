package com.example.team.services.impl;

import com.example.team.mapper.FoodMaterialMapper;
import com.example.team.pojo.DTO.IngredientDTO;
import com.example.team.pojo.Result;
import com.example.team.services.FoodMaterialService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class FoodMaterialServiceImpl implements FoodMaterialService {
    @Resource
    FoodMaterialMapper foodMaterialMapper;

    @Override
    public Result add(IngredientDTO ingredientDTO) {
        foodMaterialMapper.add(ingredientDTO.getIngredientName(),ingredientDTO.getCategory(),ingredientDTO.getNumber(),ingredientDTO.getExpirationPeriod(),ingredientDTO.getAvatar(),ingredientDTO.getComment(), LocalDateTime.now().toString());
        return Result.success();
    }

    @Override
    public Result get(Integer foodId) {

        return Result.success(foodMaterialMapper.get(foodId));
    }

    @Override
    public Result update(String name,String category,Integer quantity,String expirationTime,String avatar,String comment ,Integer id) {
        foodMaterialMapper.update(name,category,quantity,expirationTime,avatar,comment,id);
        return Result.success();
    }

    @Override
    public Result delete(Integer foodId) {
        foodMaterialMapper.delete(foodId);
        return Result.success();
    }

    @Override
    public Result getList(Integer pageNum, Integer pageSize) {
        Integer start =pageNum*pageSize;
        return Result.success(foodMaterialMapper.getList(start,pageSize));

    }
}
