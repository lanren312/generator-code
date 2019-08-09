<#if  pack == "">
package com.kb.org.controller;

import com.kb.common.pojo.dto.${projectName}.${class}DTO;
import com.kb.org.service.I${class}Service;
import com.kb.common.pojo.query.${projectName}.${class}Query;
<#else >
package ${pack}.controller;

import com.kb.common.PageDTO;
import com.kb.common.${projectName}.DO.${class}DO;
import com.kb.common.${projectName}.Query.${class}Query;

import ${pack}.service.I${class}Service;
</#if>

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/${projectName}/${class?uncap_first}")
public class ${class}Controller {
	@Autowired
	private I${class}Service ${class?uncap_first}Service;

    @PostMapping("/getList")
    public  List<${class}DO> getList(@RequestBody ${class}Query query){
        List<${class}DO> list = ${class?uncap_first}Service.getList(query);
        return list;
    }

    @PostMapping("/getPageList")
    public PageDTO<${class}DO> getPageList(@RequestBody ${class}Query query){
        PageDTO<${class}DO> pageData = ${class?uncap_first}Service.getPageList(query) ;
        return pageData;
    }

    @PostMapping("/insertData")
    public void insertData(@RequestBody ${class}DO ${class?uncap_first}){
        ${class?uncap_first}Service.insertData(${class?uncap_first});
    }

    @GetMapping("/deleteById/{<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>}")
    public void deleteById( @PathVariable("<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>")
                        <#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list> ){
            ${class?uncap_first}Service.deleteById(<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>);
    }

    @GetMapping("/getById/{<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>}")
    public ${class}DO getById(@PathVariable("<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>")<#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>){
        ${class}DO ${class?uncap_first} = ${class?uncap_first}Service.getById(<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>);
         return ${class?uncap_first};
    }

    @PostMapping("/updateData")
    public void updateData(@RequestBody ${class}DO ${class?uncap_first}){
        ${class?uncap_first}Service.updateData(${class?uncap_first});
    }

}