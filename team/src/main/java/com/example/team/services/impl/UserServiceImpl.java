package com.example.team.services.impl;

import com.example.team.pojo.DTO.RegisterDTO;
import com.example.team.pojo.Result;
import com.example.team.services.UserService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
@Service
public class UserServiceImpl implements UserService {
    @Override
    public void register(RegisterDTO registerDTO) {

    }

    @Override
    public Result login(RegisterDTO registerDTO) {
        return null;
    }

    @Override
    public Result getUserInfo(Integer id) {
        return null;
    }

    @Override
    public Result updateAvatar(MultipartFile file, Integer id) throws IOException {
        return null;
    }
}
