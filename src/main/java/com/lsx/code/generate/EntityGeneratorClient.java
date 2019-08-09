package com.lsx.code.generate;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

import java.io.File;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.*;
import java.util.*;


public class EntityGeneratorClient  {

    //模板路径
    private static String templatesPath = "D:\\workspace\\generator-code\\generator-code-kb\\src\\main\\resources\\freemarkerTemplates";

    //文件输出基本路径
    private static String basePath = "D:\\AutoCode\\";

    private static long seconds = System.currentTimeMillis();
	
	/**
	 * 生成代码的文件目录
	 *
     */
	public static void generateFile(String[] templateName,Configuration cfg,Map map,String pack){
		for (int i = 0; i < templateName.length; i++) {
			//文件后缀名，默认为.java
			String suffix=new String(".java");
			//默认路径业务代码存放位置
			String filePath=new String("src/main");
			String string = templateName[i];
			//截取模板名称，创建对应名称的包(dao、service等)
			String packType=string.substring(0,string.indexOf("."));
			//类名
			String className=(String) map.get("class");
			//项目简称
            String projectName = (String) map.get("projectName");
            //设置类型前缀
            String prefix = "";
            //类名后缀类型(mapperEntity、controller)
            String classType="";
			//获取mybatisXml模板，xml放在
			if("xml".equals(packType)){
                filePath="/"+projectName+"/resources/mapper";
                classType="Mapper";
				suffix=".xml";
			}else if("add".equals(packType)||"edit".equals(packType)||"list".equals(packType)||"detail".equals(packType)){
				//html文件名后缀第一个字母大写
				String htmlSuffix=packType.substring(0,1).toUpperCase()+packType.substring(1,packType.length());
				//包名为类名首字母小写
				packType=className.substring(0,1).toLowerCase()+className.substring(1, className.length());
				//html文件首字母小写
				className=packType+htmlSuffix;
				filePath="/"+projectName+"/resources/templates";
				suffix=".html";
			}else if("pojo".equals(packType)){
                filePath="/"+projectName+"/com/entity";
                classType="DO";
            }else if("query".equals(packType)){
                filePath="/"+projectName+"/com/query/"+ projectName ;
                classType="Query";
            }else if("mapper".equals(packType)){
                filePath="/"+projectName+"/com/mapper";
                classType="Mapper";
            }else if("controller".equals(packType)){
                filePath="/"+projectName+"/com/controller";
                classType="Controller";
            }else if("service".equals(packType)){
                prefix = "I";
                filePath="/"+projectName+"/com/service";
                classType="Service";
            }else if("serviceImpl".equals(packType)){
                filePath="/"+projectName+"/com/service/impl";
                classType="ServiceImpl";
            }else if("dto".equals(packType)){
                filePath="/"+projectName+"/com/dto/" ;
                classType="DTO";
            }else if("rpc-service".equals(packType)){
                filePath="/"+projectName+"/rpc/"+ projectName ;
                classType="Service";
            }

			try {
				Template template=cfg.getTemplate(string);
				 Writer out = new OutputStreamWriter(System.out);  
		         template.process(map, out);
		         out.flush();
		         //
		         //File fileDir = new File(genPackStr(filePath,pack));
                 File fileDir = new File(basePath+"/"+className+"-"+seconds);
		         // 创建文件夹，不存在则创建  +System.currentTimeMillis()
		         if(!fileDir.exists()){
		            	fileDir.mkdirs();
		          }
		         File output = new File(fileDir + "/"+prefix+className+classType+suffix);
		         Writer writer = new FileWriter(output);  
		            template.process(map, writer);  
		            writer.close();
			} catch (Exception e ) {
				e.printStackTrace();
			} 
		}
	}

    
    /**
     * 根据表名和包名生成代码主入口
     * */
    public static void generateCode(String dataBase,String dbURL,String dbPort,String username,String password,String pack,String tableName,String projectName,String applicationName){
        if ( "null".equals(pack)){
            pack = "";
        }
        System.out.println("获取参数:dataBase="+dataBase);
        System.out.println("获取参数:dbURL="+dbURL);
        System.out.println("获取参数:dbPort="+dbPort);
        System.out.println("获取参数:username="+username);
        System.out.println("获取参数:password="+password);
        System.out.println("获取参数:pack="+pack);
        System.out.println("获取参数:tableName="+tableName);
        System.out.println("获取参数:projectName="+projectName);
        System.out.println("获取参数:applicationName="+applicationName);

    	try {  
            // 获取数据库表结构数据
            TableProperty tableProperty = readData(dataBase,dbURL,dbPort, username, password, tableName);
        	List<Property>  properties = tableProperty.getProperties();
        	//创建Configuration对象
        	  Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);  
        	//设置模板基本路径


            cfg.setDirectoryForTemplateLoading(new File(templatesPath));
            cfg.setObjectWrapper(new DefaultObjectWrapper(Configuration.VERSION_2_3_23));
              if(properties.size()>0){
            	  //组装数据
            	  Map<String, Object> map = new HashMap<String, Object>();
                  map.put("class", getClassName(tableName));  
                  map.put("pack", pack);
                  map.put("tableDesc",tableProperty.getTableComment());
                  map.put("properties", properties);
                  map.put("tableName", tableName);
                  map.put("projectName",projectName);
                  map.put("applicationName",applicationName);
//                  String[] templateName=new String[]{"pojo.ftl","mapper.ftl","service.ftl","serviceImpl.ftl","controller.ftl",
//                          "xml.ftl","add.ftl","edit.ftl","detail.ftl","list.ftl"};
                  String[] templateName=new String[]{"pojo.ftl","dto.ftl","query.ftl","mapper.ftl","service.ftl","serviceImpl.ftl","controller.ftl", "xml.ftl","rpc-service.ftl"};
                  //String[] templateName=new String[]{"rpc-service.ftl"};
                  EntityGeneratorClient.generateFile(templateName,cfg,map,pack);
                  System.out.println("");
                  System.out.println("---------------------------------");
                  System.out.println("生成代码成功！");
              }else{
            	  System.err.println("");
                  System.err.println("---------------------------------");
                  System.err.println("请检查填写的数据库相关信息！");
                  System.err.println("生成代码失败！");
              }
             
        } catch (Exception e) {  
            e.printStackTrace();
            System.err.println("");
            System.err.println("---------------------------------");
            System.err.println("发生异常！");
            System.err.println("生成代码失败！");
        }  
    }
    
    /** 
     * 读取表数据 
     * @param dataBase 数据库名 
     * @param tableName 表名 
     * @return 
     */  
    public static TableProperty readData(String dataBase, String dbURL ,String dbPort,String username, String password, String tableName){
        Connection conn = null;  
        ResultSet rs = null;  
        List<Property> properties=new ArrayList<Property>();
        TableProperty tableProperty = new TableProperty();
        try {  
            Class.forName("com.alibaba.druid.pool.DruidDataSource");
            Properties props =new Properties();
            props.setProperty("remarks", "true"); //设置可以获取remarks信息
            props.setProperty("user", username);
            props.setProperty("password", password);
            props.setProperty("useInformationSchema", "true");//设置可以获取tables remarks信息
            String url = "jdbc:mysql://"+dbURL+":"+dbPort+"/"+dataBase+"?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&serverTimezone=UTC";
            conn = DriverManager.getConnection(url,props);
            DatabaseMetaData dbmd = conn.getMetaData();
            //获取表
            ResultSet  tableRs =  dbmd.getTables(conn.getCatalog(),username,tableName,new String[]{"TABLE"});
            while(tableRs.next()) {
                System.out.println("table注释:"+tableRs.getString("REMARKS"));
                //获取表注释
                tableProperty.setTableComment(tableRs.getString("REMARKS"));
            }
            //获取主键
            ResultSet pkRs = dbmd.getPrimaryKeys(null,null,tableName);
            String pkName = "";
            while(pkRs.next()) {
                System.out.println("table主键名:"+pkRs.getObject(4));
                //获取表注释
                pkName = (String) pkRs.getObject(4);
            }
            //获取字段
            rs = dbmd.getColumns(dataBase, null, tableName, null);//需要重新指定数据库名，否则会查询所有数据库相同的表名
        	ResultSetMetaData md = (ResultSetMetaData) rs.getMetaData();// 得到结果集列的属性
        /*	int column = md.getColumnCount(); // 得到记录有多少列
        	//获取列字段--start--
        	for(int i=0;i<column;i++){
        		System.out.println(md.getColumnName(i+1));
        	}*/
            while (rs.next()) {  
            	Property property=new Property(); 
            	property.setPropertyName(genFieldName(rs.getString("COLUMN_NAME")));//获取字段名并去掉下划线生成属性名
            	property.setJavaType(genFieldType(rs.getString("TYPE_NAME")));//获取字段的类型
            	property.setComment(rs.getString("REMARKS"));//获取字段的备注
            	property.setColumnName(rs.getString("COLUMN_NAME"));//获取字段名
                if (rs.getString("COLUMN_NAME").equals(pkName)){
                    property.setIsKey(1);
                }
                properties.add(property);  
            }  
        } catch (Exception e) {  
            e.printStackTrace();  
        }finally{  
            try {  
                if(conn != null){  
                    conn.close();  
                }  
                if(rs != null){  
                    rs.close();  
                }  
            } catch (Exception e2) {  
                e2.printStackTrace();  
            }  
        }
        tableProperty.setProperties(properties);
        return tableProperty;
    }  
  
    /** 
     * 根据包名获取对应的路径名 
     * @param root 根路径 
     * @param pack 包名 
     * @return 
     */  
    public static String genPackStr(String root,String pack){
        String result = root;
        //设置具体包加入路径
        if (!isEmpty(pack)){
            String [] dirs = pack.split("\\.");
            for(String dir : dirs){
                result += "/"+dir;
            }
        }
        return result;  
    }

    public static boolean isEmpty(Object str) {
        return (str == null || "".equals(str));
    }
      
    /**
     * 根据表名获取类名
     * @param tableName 表名 
     * @return 
     */  
    public static String getClassName(String tableName){  
        String result = "";  
        String lowerFeild = tableName.toLowerCase();  
        String[] fields = lowerFeild.split("_");  
        if (fields.length > 1) {  
            for(int i=0;i<fields.length;i++){  
                result += fields[i].substring(0,1).toUpperCase() + fields[i].substring(1, fields[i].length());  
            }  
        }else{
        	result +=lowerFeild.substring(0,1).toUpperCase()+lowerFeild.substring(1, lowerFeild.length());
        }

        return result.substring(2);
    }  
      
    /** 
     * 根据表字段名获取java中的字段名 
     * @param field 字段名 
     * @return 
     */  
    public static String genFieldName(String field) {  
        String result = "";  
        String lowerFeild = field.toLowerCase();  
        String[] fields = lowerFeild.split("_");  
        result += fields[0];  
        if (fields.length > 1) {  
            for(int i=1;i<fields.length;i++){  
                result += fields[i].substring(0,1).toUpperCase() + fields[i].substring(1, fields[i].length()); 
            }  
        }  
        return result;  
    }  
      
    /** 
     * 根据表字段的类型生成对应的java的属性类型 
     * @param type 字段类型 
     * @return 
     */  
    public static String genFieldType(String type){  
        String result = "String";  
        if(type.toLowerCase().equals("varchar")){  
            result = "String";  
        }else if(type.toLowerCase().equals("int")){  
            result = "Integer";
        }else if(type.toLowerCase().equals("decimal")){
            result = "BigDecimal";
        }else if(type.toLowerCase().equals("double")){
            result = "Double";
        }else if(type.toLowerCase().equals("float")){
            result = "Float";
        }else if(type.toLowerCase().contains("date")){
            result = "Date";
        }
        return result;  
    }  
}
