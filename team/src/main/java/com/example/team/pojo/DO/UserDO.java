package com.example.team.pojo.DO;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDO {

    private Integer id;
    private String username;
    private String password;
    private String avatar;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private LocalDateTime deletedTime;
    private String role;
}