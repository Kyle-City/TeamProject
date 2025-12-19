package com.example.team.pojo.DO;



import lombok.Data;
import java.util.Date;


@Data
public class MenuDO {
    private Integer id;
    private Integer user_id;
    private String title;
    private String description;
    private String avatar;
    private String comment;
    private Date created_at;
    private Date updated_at;
}
