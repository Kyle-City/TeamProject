package com.example.team.services.impl;

import com.alibaba.fastjson.JSON;
import com.example.team.coze.CozeService;
import com.example.team.mapper.FoodMaterialMapper;
import com.example.team.mapper.MenuMapper;
import com.example.team.pojo.DO.MenuDO;
import com.example.team.pojo.DTO.MenuAddDTO;
import com.example.team.pojo.Result;
import com.example.team.pojo.VO.IngredientVO;
import com.example.team.pojo.VO.MenuVO;
import com.example.team.pojo.VO.Recipe;
import com.example.team.services.MenuService;
import com.example.team.utility.MenuConvertUtil;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
@Slf4j
@Service
public class MenuServiceImpl implements MenuService {
    @Resource
    MenuMapper menuMapper;
    @Resource
    FoodMaterialMapper foodMaterialMapper;
    @Resource
    private CozeService cozeService;
    @Transactional
    @Override
    public Result addMenu(MenuAddDTO menuAddDTO) {
        MenuDO menuDO= MenuConvertUtil.convertAddDtoToDo(menuAddDTO);

        menuMapper.add(menuDO);
        menuMapper.addRelation(menuDO.getId(),menuAddDTO.getFood());
        return Result.success();
    }

    @Override
    public Result getMenu(Integer menuId) {
        return Result.success(menuMapper.get(menuId));
    }

    @Override
    public Result getMenuList(Integer pageNum, Integer pageSize) {
        Integer start=pageNum*pageSize;
        MenuVO menuVO=menuMapper.getList(start,pageSize);
        return Result.success(menuVO);
    }

    @Override
    public Result getMenuByAI(String userNeed, String like) {

        List<IngredientVO> ingredientVOList=foodMaterialMapper.getAllFood();
        StringBuilder inventoryPrompt = new StringBuilder();
        inventoryPrompt.append("Inventory list: ");

        if (ingredientVOList != null && !ingredientVOList.isEmpty()) {
            for (int i = 0; i < ingredientVOList.size(); i++) {
                IngredientVO vo = ingredientVOList.get(i);
                log.info(vo.getIngredient_name());

                String name = vo.getName() == null ? "Unknown ingredient" : vo.getName();
                Integer number = vo.getNumber() == null ? 0 : vo.getNumber();
                String expiration =vo.getIngredient_name() == null ? "No expiration date" : vo.getIngredient_name();


                inventoryPrompt.append(name)
                        .append(" (")
                        .append(number)
                        .append("g, Expiration: ")
                        .append(expiration)
                        .append(")");


                if (i != ingredientVOList.size() - 1) {
                    inventoryPrompt.append(", ");
                }
            }
        } else {
            inventoryPrompt.append("No ingredients in stock");
        }


        String existFood = inventoryPrompt.toString();
        String rawThirdPartyData = cozeService.callCozeWorkflow(userNeed, existFood, like);
        log.info(existFood);
        try {
            // 2. 基础判空
            if (!StringUtils.hasText(rawThirdPartyData)) {
                return Result.error("第三方接口返回数据为空");
            }

            // 3. 解析JSON为实体类
            Recipe recipe = JSON.parseObject(rawThirdPartyData, Recipe.class);

            // 4. 核心数据校验（业务规则）
            // 4.1 校验第三方返回的成功状态
            if (recipe.getThirdPartySuccess() == null || !recipe.getThirdPartySuccess()) {
                return Result.error("食谱生成失败");
            }
            // 4.2 校验食谱名称
            if (!StringUtils.hasText(recipe.getRecipeName())) {
                return Result.error( "食谱名称不能为空");
            }
            // 4.3 校验食材列表
            List<String> ingredients = recipe.getRequiredIngredients();
            if (ingredients == null || ingredients.isEmpty()) {
                return Result.error("所需食材列表不能为空");
            }
            // 4.4 校验步骤列表
            List<String> steps = recipe.getSteps();
            if (steps == null || steps.isEmpty()) {
                return Result.error( "制作步骤列表不能为空");
            }

            // 5. 数据处理（可选：比如格式化食材/步骤、脱敏等）
            // 示例：给食谱名称加前缀
            recipe.setRecipeName("【家常菜】" + recipe.getRecipeName());

            // 6. 校验通过，返回成功结果（只返回前端需要的字段）
            return Result.success(recipe);

        } catch (Exception e) {
            // 7. 异常捕获（JSON解析失败、空指针等）
            // 生产环境中建议用日志框架（如SLF4J）记录异常详情
            log.info(rawThirdPartyData);
            e.printStackTrace();
            return Result.error("食谱数据解析失败：" + e.getMessage());
        }

    }


}
