<#if  pack == "">
package service.impl;

import com.kb.common.PageDTO;
import com.kb.common.${projectName}.DO.${class}DO;
import com.kb.common.${projectName}.Query.${class}Query;

import ${pack}.mapper.${class}Mapper;
import ${pack}.service.I${class}Service;

<#else >
package ${pack}.service.impl;

import com.kb.common.PageDTO;
import com.kb.common.${projectName}.DO.${class}DO;
import com.kb.common.${projectName}.Query.${class}Query;

import ${pack}.mapper.${class}Mapper;
import ${pack}.service.I${class}Service;

</#if>
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;


@Slf4j
@Service
public class ${class}ServiceImpl implements I${class}Service {

	@Autowired
	private ${class}Mapper ${class?uncap_first}Mapper;

    /**
     * 新增${tableDesc}
     * @param ${class?uncap_first}
     * @return int
     */

    @Override
    public int insertData(${class}DO ${class?uncap_first}){
        log.info("新增${class}DO,传入参数为:{}",${class?uncap_first});
        return	${class?uncap_first}Mapper.insertData(${class?uncap_first});
    }

     /**
      * 删除${tableDesc}
      */
    @Override
    public int deleteById(<#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>){
        log.info("通过ID删除${class}DO,传入参数为:{}",<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>);
        return ${class?uncap_first}Mapper.deleteById(<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>);
    }

    /**
      * 修改${tableDesc}
      */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public int updateData(${class}DO ${class?uncap_first}){
        log.info("修改${class}DO,传入参数为:{}",${class?uncap_first});
        return ${class?uncap_first}Mapper.updateData(${class?uncap_first});
    }

    /**
      * 查询${tableDesc}分页列表
      * @return Page<${class}>
      */
    @Override
    public PageDTO<${class}DO> getPageList(${class}Query query){
        log.info("查询${class}分页集合,传入参数为:{}",query);
        //分页信息,查询是以0开始，页面是以1开始
        query.setPage((query.getPage() - 1) * query.getLimit());
		List<${class}DO> ${class?uncap_first}List = ${class?uncap_first}Mapper.getPageList(query);
        long total = ${class?uncap_first}Mapper.getListCount(query);
        return new PageDTO(${class?uncap_first}List, total);
    }

    /**
      * 查询${tableDesc}列表
      */
    @Override
    public List<${class}DO> getList(${class}Query query){
        log.info("查询${class}list集合,传入参数为:{}",query);
        List<${class}DO> ${class?uncap_first}List = ${class?uncap_first}Mapper.getList(query);
    	return ${class?uncap_first}List;
    }

    /**
      * 通过Id查询${tableDesc}
      */
    @Override
    public ${class}DO getById(<#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>){
        log.info("通过ID查询${class}DO对象,传入参数为:{}",<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>);
        ${class}DO  ${class?uncap_first}DO = ${class?uncap_first}Mapper.getById(<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>);
        return ${class?uncap_first}DO;
    }

}