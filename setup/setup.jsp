<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.io.*,
				 cn.js.fan.db.*,
				 cn.js.fan.util.*,
				 cn.js.fan.web.*,
				 com.redmoon.forum.*,
				 org.jdom.*,
                 java.util.*"
%>
<%@ page import="java.io.*,
                 java.util.*,
                 java.lang.reflect.*"
%>
<%
String op = ParamUtil.get(request, "op");
if(op.equals("select")){
	String db = ParamUtil.get(request, "db");
	if(db.equals("mysql"))
		response.sendRedirect("setup2_mysql.jsp");
	else if(db.equals("oracle"))
		response.sendRedirect("setup2_oracle.jsp");
	else if(db.equals("mssql"))
		response.sendRedirect("setup2_mssql.jsp");
	else
		out.print(StrUtil.Alert_Redirect("请选择数据库类型!", "setup.jsp"));
}
%>

<%
XMLConfig cfg = new XMLConfig("config_cws.xml", false, "utf-8");
%>
<title>云网社区安装</title>
<link rel="stylesheet" type="text/css" href="../common.css">
<table cellpadding="6" cellspacing="0" border="0" width="100%">
<tr>
<td width="1%" valign="top"></td>
<td width="99%" valign="top">

    <b>欢迎您使用云网社区 版本<%=cfg.get("Application.version")%></b>
    <hr size="0">

    <font size="-1">
     在安装继续进行前，你的服务器环境必须通过以下所有检查: </font>
    <ul>
    <table border="0">
    <tr><td valign=top><img src="images/check.gif" width="13" height="13"></td>
        <td>
        <font size="-1">
        安装工具检测到你正运行在
        <%= application.getServerInfo() %>        </font>	    </td>
    </tr>

<%  // JDK check. See if they have Java2 or later installed by trying to
    // load java.util.HashMap.
    boolean isJDK1_2 = true;
    try {
        Class.forName("java.util.HashMap");
    }
    catch (ClassNotFoundException cnfe) {
        isJDK1_2 = false;
    }
    if (isJDK1_2) {
%>
	<tr><td valign=top><img src="images/check.gif" width="13" height="13"></td>
        <td>
		<font size="-1">
            你的JDK版本为1.2或者更新。		 </font>	    </td>
    </tr>
<%  }
    else {
%>
	<tr><td valign=top><img src="images/x.gif" width="13" height="13"></td>
        <td>
		<font size="-1">
            你的JDK版本好像低于JDK 1.2。因此安装不能继续。如果可能，请更新JDK版本并重新开始这个过程。     </font>	    </td>
    </tr>
<%  }

    // Servlet version check. The appserver must support at least support
    // the Servlet API 2.2.
    boolean servlet2_2 = true;
    try {
        Class sessionClass = session.getClass();
        Class[] setAttributeParams = new Class[1];
        setAttributeParams[0] = Class.forName("java.lang.String");
        Method getAttributeMethod = sessionClass.getMethod("getAttribute", setAttributeParams);
    }
    catch (SecurityException se) {
        // some class loaders might not let us do the reflection above, so use
        // the old method of finding the appserver version:
        servlet2_2 = application.getMajorVersion() >= 2
                        && application.getMinorVersion() >= 2;
    }
    catch (Exception e) {
        // ClassNotFoundException & MethodNotFoundException end up here.
        servlet2_2 = false;
    }
    if (servlet2_2) {
%>
	<tr><td valign=top><img src="images/check.gif" width="13" height="13"></td>
        <td>
		<font size="-1">
            你的应用服务器支持servlet 2.2或者更新。        </font>	    </td>
    </tr>
<%  }
    else {
%>
	<tr><td valign=top><img src="images/x.gif" width="13" height="13"></td><td>
		<font size="-1">     你的应用服务器不支持servlet 2.2或者更新。</font>
	</td></tr>
	<%
		}
	%>

	<%
		// cloudwebsoft
		boolean cloudInstalled = true;
		try {  Class.forName("com.redmoon.forum.MsgDb");  }
		catch (ClassNotFoundException cnfe) {  cloudInstalled = false;  }

		// Lucene
		boolean luceneInstalled = true;
		try {  Class.forName("org.apache.lucene.document.Document");  }
		catch (ClassNotFoundException cnfe) {  luceneInstalled = false;  }

		// Lucene Chinese support
		boolean luceneChineseInstalled = true;
		try {  Class.forName("org.apache.lucene.analysis.cn.ChineseAnalyzer");  }
		catch (ClassNotFoundException cnfe) {  luceneChineseInstalled = false;  }

		// JavaMail
		boolean javaMailInstalled = true;
		try {
			Class.forName("javax.mail.Address");  // mail.jar
			Class.forName("javax.activation.DataHandler"); // activation.jar
			// Class.forName("dog.mail.nntp.Newsgroup"); // nntp.jar
		}
		catch (ClassNotFoundException cnfe) {  javaMailInstalled = false;  }

		// JDBC std ext
		boolean jdbcExtInstalled = true;
		try {  Class.forName("javax.sql.DataSource");  }
		catch (ClassNotFoundException cnfe) {  jdbcExtInstalled = false;  }

		boolean filesOK = cloudInstalled && luceneInstalled && javaMailInstalled &&
				jdbcExtInstalled;
		if (filesOK) {
	%>
	<tr><td valign=top><img src="images/check.gif" width="13" height="13"></td><td>
		<font size="-1"> 所有的应用程序包都安装正确。
	<%  }
		else {
	%>
	<tr><td valign=top><img src="images/x.gif" width="13" height="13"></td><td>
		<font size="-1">一个或者多个应用程序包没有被安装。
	<%  }  %>
	<tr><td colspan="2" valign=top><ul>
		  <font size="-1"><img src="images/<%= cloudInstalled?"check.gif":"x.gif" %>" width="13" height="13">
		    云网论坛内核 (forum.jar)
		    <br> <img src="images/<%= luceneInstalled?"check.gif":"x.gif" %>" width="13" height="13">
		    文本搜索引擎Lucene (lucene.jar)（中文支持）
		    <br> <img src="images/<%= javaMailInstalled?"check.gif":"x.gif" %>" width="13" height="13">
		    JavaMail支持 (mail.jar, activation.jar,)
		    <br> <img src="images/<%= jdbcExtInstalled?"check.gif":"x.gif" %>" width="13" height="13">
		    JDBC 2.0 扩展 (jdbc2_0-stdext.jar)		    </font>
		  </ul></td></tr>

<%
		String cloudHome = application.getRealPath("/");
		if (cloudHome.lastIndexOf(File.separator)!=cloudHome.length()-1)
			cloudHome += File.separator;
		
		String CacheTemp = "";
		boolean propError = false;
		String errorMessage = "";
		String rightMessage = "";
		boolean cacheError = false;
		String errorCacheMessage = "";
		
		PropertiesUtil pu = new PropertiesUtil(cloudHome + "WEB-INF" + File.separator + "log4j.properties");
		pu.setValue("log4j.appender.R.File", cloudHome.replaceAll("\\\\","/") + "log/community.log");
		pu.saveFile(cloudHome + "WEB-INF" + File.separator + "log4j.properties");
		
		java.net.URL cfgURL = getClass().getClassLoader().getResource("cache.ccf");
		PropertiesUtil pucache = new PropertiesUtil(java.net.URLDecoder.decode(cfgURL.getFile()));
		pucache.setValue("jcs.auxiliary.DC.attributes.DiskPath", cloudHome.replaceAll("\\\\","/") + "CacheTemp");
		pucache.saveFile(java.net.URLDecoder.decode(cfgURL.getFile()));

		String cachepath = pucache.getValue("jcs.auxiliary.DC.attributes.DiskPath");
		String FileUploadTmp = cloudHome + "FileUploadTmp" + File.separator;
		String doc = cloudHome + "doc" + File.separator;
		String forumupfiledir = cloudHome + "forum" + File.separator + "upfile" + File.separator;
		String upfiledir = cloudHome + "upfile" + File.separator;
		String classesdir = cloudHome + "WEB-INF"  + File.separator + "classes" + File.separator;
		String bakdir = cloudHome + "bak" + File.separator;
		String themedir = cloudHome + "forum" + File.separator + "images" + File.separator + "theme" + File.separator;
		
		File cachefile = new File(cachepath);
		File fileUpload = new File(FileUploadTmp);
		File docfile = new File(doc);
		File upfile = new File(upfiledir);
		File forumupfile = new File(forumupfiledir);
		File classesfile = new File(classesdir);
		File bakfile = new File(bakdir);
		File themefile = new File(themedir);
		try {
			if (cloudHome != null) {
                try {
                    File file = new File(cloudHome);
                    if (!file.exists()) {
                        propError = true;
                        errorMessage = "" + cloudHome + "</tt> " + "不存在。请指定正确的cloudHome目录。" + "<br>";
                    }
                }
                catch (Exception e) {}
                if (!propError) {
					boolean readable = (new File(cloudHome)).canRead();
    				if (!readable) {
    					propError = true;
    					errorMessage += "目录" + cloudHome + "无法读入" + "<br>";
    				}
					boolean writable = false;
					if (readable) {
					    rightMessage += "目录" + cloudHome + "   读权限正确<br>";
					}
					// 检查CacheTemp是否有读写权限					
					readable = cachefile.canRead();
					if (!readable) {
						errorCacheMessage += "目录" + cachepath + "无法读入,缓存已停用！CacheTemp目录权限改为可读！" + "<br>";
					}
					writable = cachefile.canWrite();
					if (!writable) {
						errorCacheMessage +=  "目录" + cachepath + "无法写入,缓存已停用！CacheTemp目录权限改为可写！" + "<br>";
					}	
					if (readable && writable) {
						cfg.set("Application.useCache", "true");
						cfg.writemodify();
						Global.init();	
					}	
					else {
					   	cfg.set("Application.useCache", "true");
						cfg.writemodify();
						Global.init();	
					}						
					// 检查FileUploadTmp目录上传是否有读写权限					
					readable = fileUpload.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + FileUploadTmp + "无法读入"+ "<br>";
					}
					writable = fileUpload.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + FileUploadTmp + "无法写入" + "<br>";
					}																
					// 检查doc目录上传是否有读写权限					
					readable = docfile.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + doc + "无法读入" + "<br>";
					}
					writable = docfile.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + doc + "无法写入" + "<br>";
					}
/*											
					// 检查forum/upfile目录上传是否有读写权限					
					readable = forumupfile.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + forumupfiledir + "无法读入" + "<br>";
					}
					writable = forumupfile.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + forumupfiledir + "无法写入" + "<br>";
					}												
					// 检查upfile目录上传是否有读写权限					
					readable = upfile.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + upfiledir +"无法读入" + "<br>";
					}
					writable = upfile.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + upfiledir + "无法写入" + "<br>";
					}
*/					
					// 检查WEB-INF/classes/目录上传是否有读写权限					
					readable = classesfile.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + classesdir + "无法读入" + "<br>";
					}
					writable = classesfile.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + classesdir + "无法写入" + "<br>";
					}	
					// 检查bak目录上传是否有读写权限					
					readable = bakfile.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + bakdir + "无法读入" + "<br>";
					}
					writable = bakfile.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + bakdir + "无法写入" + "<br>";
					}	
					// 检查themefile目录是否有读写权限
					readable = themefile.canRead();
					if (!readable) {
						propError = true;
						errorMessage += "目录" + themedir + "无法读入" + "<br>";
					}
					writable = themefile.canWrite();
					if (!writable) {
						propError = true;
						errorMessage +=  "目录" + themedir + "无法写入" + "<br>";
					}						
                }
	    	}
        	else {
           		propError = true;
           		errorMessage = "<tt>" + cloudHome + "</tt> 目录设置不正确。";
        	}
		}
		catch (Exception e) {
			e.printStackTrace();
			out.print(StrUtil.toHtml(StrUtil.trace(e)));
			propError = true;
           	errorMessage = "检查<tt>" + cloudHome + "</tt>目录时发生异常。" +
				"请确认你安装的是云网论坛程序是否完整！";
		}
		if (!propError) {
	%>
	<tr><td valign=top><img src="images/check.gif" width="13" height="13"></td>
	  <td>
		<tt>社区</tt> <font size="-1">目录正确配置于: </font><tt><%=cloudHome %></tt>
	</td></tr>
	<%
		}
		else {
	%>
	<tr><td valign=top><img src="images/x.gif" width="13" height="13"></td><td>
		<font size="-1"><%= errorMessage %><font>
	</td></tr>
	<%
		}
	   if(errorCacheMessage != "") {
	%>
	<tr><td valign=top><img src="images/x.gif" width="13" height="13"></td><td>
		<font size="-1" color="red"><%=errorCacheMessage%><font>
	</td></tr>
		<%}%>
</table>
</ul>
    <%
	if (propError || !filesOK || !isJDK1_2 || !servlet2_2) {
%>
	<font color="red" size="-1"><b>安装初始化检查过程中发现错误，请更正，然后重新启动服务器重新开始安装过程。</b></font>
<%
	}
	else {
%>
<br>
	<form method="post" action="setup.jsp?op=select">
    请选择数据库类型：&nbsp;&nbsp;&nbsp;
      <select name="db">
	  <option value="">请选择数据库类型</option>
	  <option value="mysql">MYSQL</option>
	  <option value="mssql">SQLServer2000</option>
	  <option value="oracle">Oracle</option>
      </select>
	<hr size="0">
    <div align="center">
    <input type="submit" value="下一步">
	</div>
    </form>
    <%
	}
%>
</td>
</tr>
</table>
