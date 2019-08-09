package com.lsx.code.generate;

import lombok.Data;

@Data
public class Property {
	 // 属性数据类型
    private String javaType;
    // 属性名称
    private String propertyName;
    // 属性注释
    private String comment;
    //字段名称
    private String columnName;

    //是否主键(1:主键 0：非主键)
    private int isKey = 0;

}
