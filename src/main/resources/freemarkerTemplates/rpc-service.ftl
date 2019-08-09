package com.kb.rpc.${projectName};

import java.util.List;
import com.kb.common.PageDTO;
import com.kb.common.${projectName}.DO.${class}DO;
import com.kb.common.${projectName}.Query.${class}Query;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * ${tableDesc} RPC服务
 */
@FeignClient("/${applicationName}")
public interface ${class}Service {

    /**
     * 查询${tableDesc}列表
     * @param query
     * @return List<${class}DO>
     */
    @PostMapping("/${projectName}/${class?uncap_first}/getList")
    List<${class}DO> getList(@RequestBody ${class}Query query);

   /**
    * 查询${tableDesc}列表
    * @param query
    * @return Page<${class}DTO>
    */
    @PostMapping("/${projectName}/${class?uncap_first}/getPageList")
     PageDTO<${class}DO> getPageList(@RequestBody ${class}Query query);

    /**
     * 新增${tableDesc}
     */
    @PostMapping("/${projectName}/${class?uncap_first}/insertData")
     void insert(@RequestBody ${class}DO ${class?uncap_first});

    /**
     * 删除${tableDesc}
     */
    @GetMapping("/${projectName}/${class?uncap_first}/deleteById/{<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>}")
     void deleteById( @PathVariable("<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>") <#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>);

    /**
     * 通过id查询${tableDesc}
     * @param <#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>
     * @return ${class}DO
     */
    @GetMapping("/${projectName}/${class?uncap_first}/getById/{<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>}")
     ${class}DO getById(@PathVariable("<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>") <#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>);

    /**
     * 修改${tableDesc}
     */
    @PostMapping("/${projectName}/${class?uncap_first}/updateData")
     void update(@RequestBody ${class}DO ${class?uncap_first});

}