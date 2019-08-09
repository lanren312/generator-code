<#if  pack == "">
package com.kb.org.mapper;

import com.kb.org.entity.${class}DO;
import com.kb.common.pojo.query.${projectName}.${class}Query;
<#else >
package ${pack}.mapper;

import com.kb.common.${projectName}.DO.${class}DO;
import com.kb.common.${projectName}.Query.${class}Query;
</#if>
import java.util.List;
import org.apache.ibatis.annotations.Param;


public interface ${class}Mapper{

    /**
     * 新增${tableDesc}
     * @param ${class?uncap_first}
     * @return int
     */
     int insertData (${class}DO ${class?uncap_first});

     /**
      * 删除${tableDesc}
      * @param <#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>
      * @return int
      */
     int deleteById(@Param("<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>") <#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>);

     /**
      * 修改${tableDesc}
      * @param ${class?uncap_first}
      * @return int
      */
     int updateData (${class}DO ${class?uncap_first});

     /**
      * 查询${tableDesc}列表
      * @param query
      * @return List<${class}DO>
      */
     List<${class}DO> getPageList(@Param("query")${class}Query query);

     /**
      * 查询${tableDesc}列表
      * @param query
      * @return List<${class}DO>
      */
     List<${class}DO> getList(@Param("query")${class}Query query);

     /**
      * 通过id查询${tableDesc}
      * @param <#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>
      * @return ${class}
      */
     ${class}DO getById(@Param("<#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>") <#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>);

     /**
      * 查询${tableDesc}列表总条数
      * @param query
      * @return long
      */
     long getListCount(@Param("query")${class}Query query);

}