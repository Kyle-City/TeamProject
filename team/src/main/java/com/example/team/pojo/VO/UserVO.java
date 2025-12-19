package com.example.team.pojo.VO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserVO {
    private String id;
    private String username;
    private String avatar;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private LocalDateTime deletedTime;
}
