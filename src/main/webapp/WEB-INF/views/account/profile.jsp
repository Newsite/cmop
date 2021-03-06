<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/layouts/taglib.jsp"%>

<html>
<head>

	<title>个人信息修改</title>
	
	<script>
		$(document).ready(function() {
			
			$("#email").focus();
			
			$("#inputForm").validate({
				rules: {
					email: {
						remote: "${ctx}/ajax/checkEmail?oldEmail=${user.email}"
					}
				},
				messages: {
					email: {
						remote: "邮箱已存在"
					}
				}
			});
			
		});
	</script>
	
</head>

<body>

	<style>body{background-color: #f5f5f5;}</style>

	<form id="inputForm" action="${ctx}/profile" method="post" class="form-horizontal input-form">
	
		<input type="hidden" name="id" value="${user.id}">
		<input type="hidden" name="groupId" value="${group.id}">
		
		<fieldset>
		
			<legend><small>个人信息修改</small></legend>
			
			<div class="control-group">
				<label class="control-label" for="loginName">登录名</label>	 
				<div class="controls">
					<input type="text" id="loginName" name="loginName" value="${user.loginName }" readonly="readonly" class="required" maxlength="45" placeholder="...Login name">
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="email">Email地址</label>
				<div class="controls">
					<input type="text" id="email" name="email" value="${user.email }"  class="required email" maxlength="45"  placeholder="...Email address">
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="plainPassword">密码</label>
				<div class="controls">
					<input type="password" id="plainPassword" name="plainPassword" class="required" minlength="6" maxlength="16" placeholder="...Password">
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="email">确认密码</label>
				<div class="controls">
					<input type="password" id="confirmPassword"  class="required" minlength="6" maxlength="16" equalTo="#plainPassword" placeholder="...Confirm password">
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="phonenum">联系电话</label>
				<div class="controls">
					<input type="text" id="phonenum" name="phonenum" value="${user.phonenum }"  class="required" maxlength="45" placeholder="...联系电话">
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="name">真实姓名</label>
				<div class="controls">
					<input type="text" id="name" name="name" value="${user.name }" class="required" maxlength="45" placeholder="...真实姓名">
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="departmentId">所属部门</label>
				<div class="controls">
					<select id="departmentId" name="departmentId" class="required">
						<c:forEach var="item" items="${allDepartments}">
							<option value="${item.id }" <c:if test="${user.department.id == item.id}">selected="selected"</c:if> >${item.name }</option>							
						</c:forEach>
					</select>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="leaderId">预算审批领导</label>
				<div class="controls">
					<select id="leaderId" name="leaderId" class="required">
						<c:forEach var="item" items="${leaders}">
							<option value="${item.id }" <c:if test="${user.leaderId == item.id}">selected="selected"</c:if> >${item.name }</option>							
						</c:forEach>
					</select>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="createTime">权限角色</label>
				<div class="controls">
					<p class="help-inline plain-text">${group.name }</p>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="createTime">注册日期</label>
				<div class="controls">
					<p class="help-inline plain-text"><fmt:formatDate value="${user.createTime}" pattern="yyyy年MM月dd日  HH时mm分ss秒" /></p>
				</div>
			</div>
			
			<div class="form-actions">
				<input class="btn" type="button" value="返回" onclick="history.back()">
				<input class="btn btn-primary" type="submit" value="提交">
			</div>
			
		</fieldset>
	</form>
</body>
</html>
