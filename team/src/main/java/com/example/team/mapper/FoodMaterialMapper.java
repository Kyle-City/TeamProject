package com.example.team.mapper;


import com.example.team.pojo.VO.FoodVO;
import com.example.team.pojo.VO.IngredientVO;
import org.apache.ibatis.annotations.*;
import org.springframework.web.bind.annotation.DeleteMapping;

import java.util.List;

@Mapper
public interface FoodMaterialMapper {
    @Insert("INSERT INTO food_material (name, category, quantity, expiration_time, avatar,comment,add_time) " +
            "VALUES (#{name}, #{category}, #{quantity}, #{expirationTime}, #{avatar},#{comment},#{addTime})")
    public void add(String name,String category,Integer quantity,String expirationTime,String avatar,String comment ,String addTime);

    @Select("select id,name ingredient_name, category, quantity number, expiration_time expiration_period, avatar,comment,add_time addTime from food_material where id=#{id}")
    public IngredientVO get(Integer id);

    @Delete("delete from food_material where id=#{id}")
    public  void  delete(Integer id);
    @Select("select  id,name, quantity number, avatar from food_material limit #{start} ,#{pageSize}")
    public List<FoodVO>  getList(Integer start, Integer pageSize);

    @Select("select id,name ingredient_name, category, quantity number, expiration_time expiration_period, avatar,comment,add_time addTime from food_material ")
    public List<IngredientVO> getAllFood();
    @Update("update food_material set name= #{name}, category=#{category}, quantity=#{quantity}, expiration_time=#{expirationTime}, avatar=#{avatar},comment=#{comment}where id=#{id}")
    public void update(String name,String category,Integer quantity,String expirationTime,String avatar,String comment ,Integer id);
}
