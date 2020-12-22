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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js" charset="UTF-8"></script>


	<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarkDivs").on("mouseover",".remarkDiv",function (){
            $(this).children("div").children("div").show();
        })


        $("#remarkDivs").on("mouseout",".remarkDiv",function (){
            $(this).children("div").children("div").hide();
        })

        $("#remarkDivs").on("mouseover",".myHref",function (){
            $(this).children("span").css("color","red");
        })

        $("#remarkDivs").on("mouseout",".myHref",function (){
            $(this).children("span").css("color","#E6E6E6");
        })

		//当前活动加载完毕后获取当前活动的备注信息
		getActivity();
		pageList(1,2);

		//点击编辑按钮打开修改模态窗口
		$("#editBtn").click(function (){
			//导入时间时区器
			$(".time").datetimepicker({
				minView:"month",
				language:"zh-CN",
				format:"yyyy-mm-dd",
				autoclose:true,
				todayBtn:true,
				pickerPosition:"botton-left"
			});
			//打开修改界面窗口的时候修改文本框中的内容
			$("#edit-marketActivityOwner").empty();
			$.each(userList,function (index,element){
				if (element.name==currentActivity.owner){
					$("#edit-marketActivityOwner")
							.append("<option value="+element.id+" selected>"+element.name+"</option>")
				}else{
					$("#edit-marketActivityOwner")
							.append("<option value="+element.id+">"+element.name+"</option>")
				}
			})
			$("#edit-marketActivityName").val(currentActivity.name);
			$("#edit-startTime").val(currentActivity.startDate);
			$("#edit-endTime").val(currentActivity.endDate);
			$("#edit-cost").val(currentActivity.cost);
			$("#edit-describe").val(currentActivity.description)
			$("#editActivityModal").modal("show");
		})

		//点击更新按钮，更新数据，并更新界面中的数据
		$("#editActivity").click(function (){
			var owner = $("#edit-marketActivityOwner").val();
			var name = $("#edit-marketActivityName").val();
			if (owner=="" || name==""){
				alert("请至少输入所有者和名称！");
				return false;
			}
			$.ajax({
				url:"activity/editActivity.do",
				type:"post",
				data:{
					"id":currentActivity.id,
					"owner":owner,
					"name":name,
					"startDate":$.trim($("#edit-startTime").val()),
					"endDate":$.trim($("#edit-endTime").val()),
					"cost":$.trim($("#edit-cost").val()),
					"description":$("#edit-describe").val(),
					"editBy":"${user.name}"
				},
				success(data){
					if (data==1){
						alert("修改成功！");
						getActivity();
						$("#editActivityModal").modal("hide");
					}else{
						alert("修改失败！请稍后重试！");
					}
				}
			})
		})

		//点击删除按钮，删除本条活动记录，并返回列表界面
		$("#deleteBtn").click(function (){
			var a = confirm("确定要删除本条市场活动吗？");
			if (!a){
				return false;
			}
			$.ajax({
				url:"activity/delActivity.do",
				type: "post",
				data: {
					"ids":[currentActivity.id]
				},
				traditional: true,
				success(data) {
					if (data==1){
						alert("删除成功！");
						window.location.href="workbench/activity/index.jsp";
					}else{
						alert("删除失败！")
					}
				}
			})
		})

		//点击备注的保存按键，向后台保存数据
		$("#addRemark").click(function (){
			var noteContent = $.trim($("#remark").val());
			if (noteContent==""){
				alert("请输入备注信息！");
				return false;
			}
			$.ajax({
				url:"activityRemark/saveRemark.do",
				type:"post",
				data:{
					"noteContent":noteContent,
					"createBy":"${user.name}",
					"activityId":currentActivity.id,
					"editFlag":'0'
				},
				success(data){
					if (data==1){
						alert("提交成功！");
						$("#remark").val("");
						pageList(1,2);
					}else{
						alert("提交失败，请稍后重试！");
					}
				}
			})
		})

		//点击备注修改模态窗口的更新按钮，更新备注信息
		$("#updateRemarkBtn").click(function (){
			//从隐藏域中获取当前备注的id值
			var id = $("#remarkId").val();
			var noteContent = $("#noteContent").val();
			$.ajax({
				url:"activityRemark/editRemark.do",
				type:"post",
				data:{
					"id":id,
					"noteContent": noteContent,
					"editFlag":'1',
					"editBy":'${user.name}'
				},
				success(data){
					if (data==1){
						alert("修改成功！");
						pageList(1,2);
						$("#editRemarkModal").modal('hide');
					}else{
						alert("修改失败，请稍后重试！");
					}
				}
			})
		})
	});

	//定义一个方法，加载当前页面对应的活动信息
	function getActivity(){
		$.ajax({
			url:"activity/getActivity.do",
			type:"get",
			async:false,
			data:{
				//从请求连接中获取请求的活动的id
				"id":"${param.id}"
			},
			success(data){
				userList = data.userList;
				currentActivity = data.activity;
				//对顶部信息的处理
				$(".name").html(currentActivity.name);
				$("#date").html(currentActivity.startDate+'~'+currentActivity.endDate);
				activityMessage = $(".activityMessage");
				//将所有的放活动信息的标签放入一个类中，获取这个类的JQuery数组对象
				$.each(activityMessage,function (index,element) {
					$.each(currentActivity,function (key,values){
						//当JQuery数组中的对象的id的值和获取的活动JSON对象的属性名一致的时候进行赋值
						if (element.id==key){
							$(element).html(values);
						}
					})
				})
			}
		})
	}

	//定义分页方法
	function pageList(pageNo,pageSize){
		$.ajax({
			url:"activityRemark/pageList.do",
			type:"get",
			data:{
				"activityId":currentActivity.id,
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			success(data){
				var html = "";
				$.each(data.dataList,function (index,element){
					html += '<div class="remarkDiv"  style="height: 60px;">';
					if (element.editFlag=='0'){
						html += '<img title='+element.createBy+' src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					}else{
						html += '<img title='+element.editBy+' src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					}
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+element.noteContent+'</h5>';
					html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>'+currentActivity.name+'</b>';
					if (element.editFlag=='0'){
						html += '<small style="color: gray;"> '+element.createTime+' create by '+element.createBy+'</small>';
					}else{
						html += '<small style="color: gray;"> '+element.editTime+' edit by '+element.editBy+'</small>';
					}
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					//动态生成的元素绑定事件传入参数需要以字符的形式传入('传入参数<字符串形式>')
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="delRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div></div></div>';
				})
				$("#remarkDivs").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件对前端展现分页信息
				$("#activityRemarkPage").bs_pagination({
					currentPage: pageNo,
					rowsPerPage: pageSize,
					maxRowsPerPage: 20,
					totalPages: totalPages,
					totalRows: data.total,
					visiblePageLinks: 3,
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数是我们在调用分页组件的时候触发
					onChangePage: function (event,data) {
						pageList(data.currentPage,data.rowsPerPage);
					}
				});
			}
		})
	}

	//定义删除备注的方法
	function delRemark(id){
		$.ajax({
			url:"activityRemark/delRemark.do",
			type:"post",
			data:{
				"id":id
			},
			success(data){
				if (data==1){
					pageList(1,2);
				}else{
					alert("删除失败，请稍后重试！");
				}
			}
		})
	}

	//点击修改图标打开修改备注的模态窗口
	function editRemark(id){
		//将当前备注的id值放入隐藏域当中
		$("#remarkId").val(id);
		$.ajax({
			url:"activityRemark/getRemark.do",
			type:"get",
			data:{
				"id":id
			},
			success(data){
				$("#noteContent").val(data.noteContent);
			}
		})
		$("#editRemarkModal").modal("show");
	}


	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal"  role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startTime" readonly>
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endTime" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="editActivity">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-<span class="name"></span> <small id="date"></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: #808080;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b class="activityMessage" id="owner"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b class="activityMessage" id="name"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b class="activityMessage" id="startDate"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b class="activityMessage" id="endDate"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b class="activityMessage" id="cost"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b class="activityMessage" id="createBy"></b>&nbsp;&nbsp;<small style="font-size: 10px; color: gray;" class="activityMessage" id="createTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b class="activityMessage" id="editBy"></b>&nbsp;&nbsp;<small style="font-size: 10px; color: gray;" class="activityMessage" id="editTime"></small>&nbsp;</div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b class="activityMessage" id="description"></b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkDivs"></div>
		<div style="height: 50px; position: relative;top: 30px;">
			<div id="activityRemarkPage"></div>
		</div>
		<div id="remarkDiv" style="background-color: white; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 80px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="addRemark">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>