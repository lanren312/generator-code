package com.lsx.code.generate;

import lombok.Data;

import java.util.List;

@Data
public class Pojo {
    // 实体所在的包名
    private String javaPackage;
    // 实体类名
    private String className;
    // 父类名
    private String superclass;
    // 属性集合
    List<Property> properties;
    // 是否有构造函数
    private boolean constructors;

}
