<!DOCTYPE html>
<html lang="zh-cn" xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3" >
<head>
    <meta charset="utf-8">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all"/>
    <script src="/layui/layui.js"></script>
    <script src="/layui/jquery-1.11.1.min.js"></script>

    <style type="text/css">
        body .demo-class .layui-layer-title{background:#c00; color:#fff; border: none;}
        body .demo-class .layui-layer-btn{border-top:1px solid #E9E7E7}
        body .demo-class .layui-layer-btn a{background:#333;}
        body .demo-class .layui-layer-btn .layui-layer-btn1{background:#999;}
    </style>
</head>

<body>
<div style="padding-top: 70px">
	<#list properties as property>
		<#if  property.isKey !=1>
			  <input  type="text" placeholder="${property.comment}" autocomplete="off"   class="layui-btn layui-btn-primary " id="${property.propertyName}" />
		</#if>
	</#list>
    <button class="layui-btn    layui-btn-normal " id="add"><i class="layui-icon">&#xe608;</i>新增</button>
    <button class="layui-btn    layui-btn-normal " id="query"><i class="layui-icon">&#xe615;</i>查询</button>
</div>

<table id="tableList" lay-filter ="test"></table>
<script >
    layui.use(['table','laydate'], function(){
        var table = layui.table;
        var laydate = layui.laydate;

        <#list properties as property>
            <#if  property.javaType == "Date">
              laydate.render({
               elem:'#${property.propertyName}',
              });
            </#if>
        </#list>

        var arr=[ //表头
                {type: 'numbers'},
				<#list properties as property>
                    <#if property.isKey!=1>
                        {field: '${property.propertyName}', title: '${property.comment}'},
                    </#if>
				</#list >
            {fixed: 'right', title: '操作',width:150, align:'center', toolbar: '#barDemo'}
        ];


        //第一个实例
        var tableIns = table.render({
            elem: '#tableList',
            height: 'full-150',
            even: true, //开启隔行背景
            url: '/${class?uncap_first}/getList', //数据接口
            page: true , //开启分页
            cols: [ //表头
                arr
            ]
        });

        <!--查询按钮-->
        $('#query').click(function(){
           search();
        });

        //编辑后刷新页面---编辑多少元素，就需要刷新多少数据
        window.search=function(){
            //执行重载--通过查询条件
            tableIns.reload({
                where: { //设定异步数据接口的额外参数，任意设
                    <#list properties as property>
						<#if  property.isKey != 1>
							${property.propertyName}:$('#${property.propertyName}').val(),
						</#if>
					</#list >
                }
                ,page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
        }

        //监听工具条
        table.on('tool(test)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的DOM对象
            if(layEvent === 'detail'){ //查看
                datail(data);
            } else if(layEvent === 'del'){ //删除
                layer.confirm('真的删除行么', function(index){
                    obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type : 'POST',
                        url : "/${class?uncap_first}/delete",
                        data : {<#list properties as property><#if  property.isKey == 1>${property.propertyName}:data.${property.propertyName}</#if></#list >},
                        success : function(data){
                            if(data.code==0){
                                layer.msg("删除成功！");
                            }else{
                                layer.msg("删除失败！");
                            }

                        },
                        error : function() {
                            layer.msg("删除失败！");
                        }
                    });
                });
            } else if(layEvent === 'edit'){ //编辑
                edits(data);
            }
        });
    });

    $('#add').click(function(){
        layui.use('layer', function(){
            var layer = layui.layer;
            layer.open({
                type: 2,
                content: '/${class?uncap_first}/toAdd', //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
                area: ['900px', '500px'],
                end: function () {
                    search();
                }
            });

        });

    });


    <!--查看按钮-->
    function datail(data){
        layui.use('layer', function(){
            var layer = layui.layer;
            layer.open({
                type: 2,
                content: '/${class?uncap_first}/toDetail?<#list properties as property><#if  property.isKey == 1>${property.propertyName}='+data.${property.propertyName}</#if></#list>, //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
                area: ['900px', '500px'],
                yes: function(index, layero){

                }
            });
        });
    }

    <!--编辑按钮  -->
    function edits(data){
        layui.use('layer', function(){
            var layer = layui.layer;
            var index=layer.open({
                type: 2,
                content: '/${class?uncap_first}/toEdit?<#list properties as property><#if  property.isKey == 1>${property.propertyName}='+data.${property.propertyName}</#if></#list>, //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
                area: ['900px', '500px'],
                end: function () {
                    search();
                }
            });
        });
    }

</script>

<script type="text/html" id="barDemo"  >
    <a class="layui-btn layui-btn-xs" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
</body>
</html>