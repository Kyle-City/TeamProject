package com.example.team.mapper;

import com.example.team.pojo.DO.MenuDO;
import com.example.team.pojo.VO.MenuVO;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface MenuMapper {
    @Insert("INSERT INTO menu (user_id, title, description, avatar, comment, created_at, updated_at) " +
            "VALUES (#{user_id}, #{title}, #{description}, #{avatar}, #{comment}, #{created_at}, #{updated_at})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    public void add(MenuDO menuDO);

    public void addRelation(@Param("menuId") Integer menuId, @Param("foodId") List<Integer> foodId);

    @Select("select id,user_id, title, description, avatar, comment, created_at , updated_at from menu where id=#{id}")
    public MenuDO get(Integer id);
    @Select("select  id, title name,avatar from menu limit #{start},#{pageSize}")
    public MenuVO getList(Integer start ,Integer pageSize);
}
