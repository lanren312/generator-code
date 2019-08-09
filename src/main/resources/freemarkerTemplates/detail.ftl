<!doctype html>
<html lang="zh-cn" xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3" >
<head>
    <meta charset="utf-8">

    <title>layui.form小例子</title>
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
</head>
<body>

<form class="layui-form"  th:action="${r"@{"}/${class?uncap_first}/add}" method="post"> <!-- 提示：如果你不想用form，你可以换成div等任何一个普通元素 -->
    <#list properties as property>
    <#if  property.isKey != 1>
    <div class="layui-form-item">
        <label class="layui-form-label">${property.comment}</label>
        <div class="layui-inline">
            <input type="text" readonly  th:value="${r"${"}${class?uncap_first}.${property.propertyName}}" id="${property.propertyName}"  name="${property.propertyName}" autocomplete="off" class="layui-input">
        </div>
    </div>
    </#if>
    </#list>
    <!-- <button class="layui-btn" lay-submit lay-filter="*">立即提交</button> -->
</form>
<script src="/layui/layui.js"></script>
<script src="/layui/jquery-1.11.1.min.js"></script>
<#list properties as property>
    <#if  property.javaType == "Date">
 <script src="/util/xhhUtil.js"></script>
     <#break>
    </#if >
</#list >
<script type="text/javascript">
    layui.use([ 'form', 'layer' ], function() {
        $ = layui.jquery;
        var form = layui.form
            , layer = layui.layer;
    });
 <#list properties as property>
   <#if  property.javaType == "Date">
            $(function(){
    <#list properties as property>
        <#if  property.javaType == "Date">
              if($("#${property.propertyName}").val()!=""){
                  $("#${property.propertyName}").val(FormatDate($("#${property.propertyName}").val()));
              }
         </#if >
    </#list >
            })
       <#break>
   </#if >
 </#list >


</script>
</body>
</html>