package com.lsx.code.generate;


import lombok.Data;

import java.util.List;

@Data
public class TableProperty {

    private List<Property> properties;

    private String tableComment;
    
}
