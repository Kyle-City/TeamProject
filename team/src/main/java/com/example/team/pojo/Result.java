package com.example.team.pojo;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Result {
    private Base base;
    private Object data;

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Base {
        private Integer code;
        private String msg;

    }


    public  static  Result success(){
        return  new Result(new Base(10000,"success"),null);
    }
    public static Result success(Object data) {
        return new Result(new Base(10000, "success"), data);
    }

    public static Result error(String msg) {
        return new Result(new Base(-1, msg), null);
    }
}
