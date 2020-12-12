<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"
			+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>"/>
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function (){
		//页面加载完毕清空页面中的内容
		$(":text").val("");
		//页面加载完毕，让用户的文本框自动选中
		$(":text").focus();
		//为登陆按钮绑定事件，执行表单提交
		$(":button").click(function(){
			login();
		})
		//步骤回车键执行登陆
		$(window).keydown(function (event){
			if (event.keyCode==13){
				login();
			}
		})
	})
	//封装登陆验证方法
	function login(){
		//获取账号密码，将文本中的左右空格去除
		let loginAct = $.trim($(":text").val());
		let loginPwd = $.trim($(":password").val());
		if (loginAct=="" || loginPwd==""){
			$("#msg").html("用户名和密码不能为空！");
			//账号密码为空终止方法
			return false;
		}
		//去后端验证登陆相关操作
		$.ajax({
			url:"user/login.do",
			date:{
				"loginAct":loginAct,
				"loginPwd":loginPwd
			},
			type:"post",
			dataType:"json",
			success(date){
				//返回的data中包含success属性true/fasle用来判断登陆是否成功
				if (date.seccess){
					//登陆成功，跳转界面
					window.location.href = "workbench/index.html";
				}else{
					//登陆失败提示失败原因
					//从后台中返回登陆失败的原因msg属性记录详细原因
					$("#msg").html(date.msg);
				}
			}
		})
	}
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2020 升美集团</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<!--按钮放在表单中默认为提交功能，将按钮设置类型为button，提交表单的操作由js代码实现-->
					<button type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>