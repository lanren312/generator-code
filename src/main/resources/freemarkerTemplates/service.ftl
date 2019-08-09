<#if  pack == "">
package ${pack}.service;

<#else >
package ${pack}.service;
import com.kb.common.PageDTO;
import com.kb.common.${projectName}.DO.${class}DO;
import com.kb.common.${projectName}.Query.${class}Query;
</#if>

import java.util.List;

public interface I${class}Service{

    /**
     * 新增${tableDesc}
     */
     int insertData(${class}DO ${class?uncap_first});

     /**
      * 删除${tableDesc}
      * @param <#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>
      * @return int
      */

     int deleteById(<#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>);

     /**
      * 修改${tableDesc}
      * @param ${class?uncap_first}
      * @return int
      */
     int updateData(${class}DO ${class?uncap_first});
     /**
      * 查询${tableDesc}列表
      * @param query
      * @return Page<${class}DO>
      */
     PageDTO<${class}DO> getPageList(${class}Query query);

     /**
      * 查询${tableDesc}列表
      * @param query
      * @return List<${class}DO>
      */
     List<${class}DO> getList(${class}Query query);

     /**
      * 通过id查询${tableDesc}
      * @param <#list properties as property><#if  property.isKey == 1>${property.propertyName}</#if></#list>
      * @return ${class}DO
      */
     ${class}DO getById(<#list properties as property><#if  property.isKey == 1>${property.javaType} ${property.propertyName}</#if></#list>);

}