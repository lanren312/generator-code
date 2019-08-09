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
        <input type="text" lay-verify="required" id="${property.propertyName}"  name="${property.propertyName}" placeholder="请输入" autocomplete="off" class="layui-input">
        </div>
    </div>
    </#if>
    </#list>1
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="save">保存</button>
        </div>
    </div>
    <!-- <button class="layui-btn" lay-submit lay-filter="*">立即提交</button> -->
</form>
<script src="/layui/layui.js"></script>
<script src="/layui/jquery-1.11.1.min.js"></script>
<script type="text/javascript">
    layui.use([ 'form', 'layer','laydate' ], function() {
        $ = layui.jquery;
        var form = layui.form
            , layer = layui.layer, laydate = layui.laydate;
      <#list properties as property>
          <#if  property.javaType == "Date">
            laydate.render({
                elem: '#${property.propertyName}',
                type: 'datetime'
            });
          </#if>
      </#list>
        //监听提交
        form.on('submit(save)', function(params) {
            //发异步，把数据提交给后台
            $.ajax({
                type : "POST",
                url : "/${class?uncap_first}/add",
                data :  params.field, //当前容器的全部表单字段，名值对形式：{name: value}
                success : function(data) {
                    if (data.code == 0){
                        layer.msg("添加成功！");
                        setTimeout(function(){
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        },1000)
                    }else{
                        layer.msg("添加失败！");
                    }
                }
            });
            return false;
        });
    });

</script>
</body>
</html>