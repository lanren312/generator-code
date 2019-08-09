package com.kb.common.${projectName}.DTO;

import lombok.Data;
import java.io.Serializable;
<#list properties as property>
    <#if property.javaType=="Date">
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
    </#if>
    <#if property.javaType=="BigDecimal">
import java.math.BigDecimal;
    </#if>
</#list>
/**
 * ${tableDesc}
 */
@Data
public class ${class}DTO implements Serializable{
<#list properties as property>
    /**
     * ${property.comment}
     */
    <#if property.javaType=="Date">
    @JsonFormat(timezone = "GMT+8", pattern="yyyy-MM-dd HH:mm:ss")
    </#if>
    private ${property.javaType} ${property.propertyName};
</#list>

}