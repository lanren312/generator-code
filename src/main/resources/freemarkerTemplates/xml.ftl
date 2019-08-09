<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
 <#macro mapperEl value >${r"#{"}${value}}</#macro>

<#if  pack == "">
<mapper namespace="com.kb.mapper.${class?cap_first}Mapper">
<#else >
<mapper namespace="${pack}.mapper.${class?cap_first}Mapper">
</#if>
	<!--插入数据-->
     <#if  pack == "">
     <insert id="insertData" parameterType="com.kb.common.${projectName}.DO.${class}DO">
     <#else >
     <insert id="insertData" parameterType="com.kb.common.${projectName}.DO.${class}DO">
     </#if>
	 	insert into ${tableName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
			<#list properties as property>
				<#if  property.isKey != 1>
                <if test="${property.propertyName} != null">
					${property.columnName},
                </if>
				</#if>

			</#list>
		</trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
			<#list properties as property>
				<#if  property.isKey != 1>
                <if test="${property.propertyName} != null">
					<@mapperEl property.propertyName/>,
				</if>
				</#if>
			</#list>
		</trim>
	 </insert>

	<!--修改数据-->
     <#if  pack == "">
     <update id="updateData" parameterType="com.kb.common.${projectName}.DO.${class}DO">
	 <#else >
     <update id="updateData" parameterType="com.kb.common.${projectName}.DO.${class}DO">
     </#if>
		<!--属性为id时不set-->
		update ${tableName} <set>
	 <#list properties as property>
		<#if  property.isKey != 1>
		     <if test="${property.propertyName} != null">
				 ${property.columnName}= <@mapperEl property.propertyName/>,
			 </if>
		</#if>
  	 </#list>
	</set>
  	 where
	<#list properties as property>
		<#if  property.isKey == 1>
			${property.columnName}=<@mapperEl property.propertyName/>
		</#if>
	</#list>
	</update>

    <!--删除数据-->
    <delete id="deleteById" parameterType="<#list properties as property><#if  property.isKey == 1>${property.javaType}</#if></#list>">
        delete from ${tableName} where
		<#list properties as property>
			<#if  property.isKey == 1>
				${property.columnName}=<@mapperEl property.propertyName/>
			</#if>
		</#list>
    </delete>

    <#--基础查询sql-->
    <sql id="baseSql_${class}">
        SELECT
		 <#list properties as property>
			 ${property.columnName}<#if property_has_next>, </#if>
		 </#list>
        FROM ${tableName}
    </sql>

	<#--基础查询条件-->
	<sql id="sqlWhere_${class}" >
		<where>
            <!--String类型需要过滤'',其他包装类型不需要,Integer为0时比较!=''会为false-->
            <!--数据类型为Date时 比较!=''会报错-->
			<#list properties as property>
				<#if property.javaType=="String">
				<if test="query.${property.propertyName} !=null and query.${property.propertyName} !=''">
				<#else>
				<if test="query.${property.propertyName} !=null">
				</#if >
				<#if property.javaType="String" >
					AND ${property.columnName} like CONCAT('%',${r"#{query."}${property.propertyName}},'%')
				<#elseif property.javaType="Date">
					AND date(${property.columnName})=date(${r"#{query."}${property.propertyName}})
				<#else>
					AND ${property.columnName}=${r"#{query."}${property.propertyName}}
				</#if>
				</if>
			</#list>
		</where>
	</sql>

    <!--查询一条数据-->
     <#if  pack == "">
     <select id="getById" resultType = "com.kb.common.${projectName}.DO.${class}DO"
     <#else >
     <select id="getById" resultType = "com.kb.common.${projectName}.DO.${class}DO"
    </#if>
		parameterType="<#list properties as property><#if  property.isKey == 1>${property.javaType}</#if></#list>" >
		<include refid="baseSql_${class}" ></include>
		WHERE
	<#list properties as property>
		<#if  property.isKey == 1>
			${property.columnName}=<@mapperEl property.propertyName/>
		</#if>
	</#list>
    </select>


	 <!--查询list数据(不带分页)-->
	 <select id="getList"
             <#if  pack == "">
             resultType = "com.kb.common.${projectName}.DO.${class}DO"
             parameterType = "com.kb.common.${projectName}.Query.${class}Query"

             <#else >
             resultType = "com.kb.common.${projectName}.DO.${class}DO"
             parameterType = "com.kb.common.${projectName}.Query.${class}Query"
             </#if>
		 >
         <include refid="baseSql_${class}" ></include>
         <include refid="sqlWhere_${class}" ></include>
	</select>

    <!--查询list数据(带分页)-->
    <select id="getPageList"
            <#if  pack == "">
             resultType = "com.kb.common.${projectName}.DO.${class}DO"
             parameterType = "com.kb.common.${projectName}.Query.${class}Query"
			<#else >
             resultType = "com.kb.common.${projectName}.DO.${class}DO"
             parameterType = "com.kb.common.${projectName}.Query.${class}Query"
			</#if>
		>
        <include refid="baseSql_${class}" ></include>
        <include refid="sqlWhere_${class}" ></include>
		LIMIT <@mapperEl "query.page"/>,<@mapperEl "query.limit"/>
    </select>

    <!--查询数据总条数-->
    <select id="getListCount"
			<#if  pack == "">
             parameterType = "com.kb.common.${projectName}.Query.${class}Query"
			<#else >
             parameterType = "com.kb.common.${projectName}.Query.${class}Query"
			</#if>
			resultType="java.lang.Long">
        SELECT count(1)
        FROM
		(
        <include refid="baseSql_${class}" ></include>
        <include refid="sqlWhere_${class}" ></include>
		)
		t
    </select>

</mapper>