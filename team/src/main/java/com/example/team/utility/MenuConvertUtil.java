package com.example.team.utility;

import com.example.team.pojo.DO.MenuDO;
import com.example.team.pojo.DTO.MenuAddDTO;
import java.util.Date;

/**
 * 菜谱DTO转DO的工具类
 */
public class MenuConvertUtil {

    /**
     * 将新增菜谱的DTO转换为DO（适配下划线字段）
     * @param dto 前端传入的新增菜谱参数
     * @return 数据库映射的MenuDO
     */
    public static MenuDO convertAddDtoToDo(MenuAddDTO dto) {
        if (dto == null) {
            return null;
        }

        MenuDO menuDO = new MenuDO();

        menuDO.setUser_id(dto.getUserId());
        menuDO.setTitle(dto.getTitle());
        menuDO.setAvatar(dto.getAvatar());
        menuDO.setDescription(dto.getDescription());


        menuDO.setComment(dto.getComment());
        menuDO.setCreated_at(new Date());
        menuDO.setUpdated_at(new Date());

        return menuDO;
    }
}