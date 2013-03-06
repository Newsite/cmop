<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/layouts/taglib.jsp"%>

<html>
<head>

	<title>实例变更</title>
	
	<script>
		$(document).ready(function() {
			
			$("ul#navbar li#resource").addClass("active");
			
			$("#inputForm").validate({
				errorClass: "help-inline",
				errorElement: "span",
				highlight: function(element, errorClass, validClass) {
					$(element).closest('.control-group').addClass('error');
				},
				unhighlight: function(element, errorClass, validClass) {
					$(element).closest('.control-group').removeClass('error');
				}
			});
			
			$.ajax({
				type: "GET",
				url: "${ctx}/ajax/getResourcesComputeByElbIsNullList",
				dataType: "json",
				success: function(data){
					
					var html = '';
					
					for ( var i = 0; i < data.length; i++) {
						
						html += '<tr>';
						html += '<td><input type="checkbox" value="'+data[i].id+'"></td>';
						html += '<td>'+data[i].identifier+'</td>';
						html += '<td>'+data[i].osType+'&nbsp;&nbsp;&nbsp;'+data[i].osBit+'&nbsp;&nbsp;&nbsp;'+data[i].serverType+'</td>';
						html += '<td>'+data[i].remark+'</td>';
						html += '<td>'+ (data[i].innerIp == null ? "" : data[i].innerIp ) +'</td>';
						html += '</tr> ';
						
					}
					
					$("#resources-tbody").append(html);
					
 				}		
			});
			
		});
		
		 /*点击弹出窗口保存时,生成Compute标识符信息HTML代码插入页面.*/
	  	 
		$(document).on("click", "#ModalSave", function() {
			
			var selectedArray = [];
			var $ModalDiv = $(this).parent().parent();
			var $CheckedIds = $ModalDiv.find("tbody input:checked");
			
			//Step.1
			$("div.resources").each(function(){
				selectedArray.push($(this).find("#computeIds").val());
			});
			
			var html = '';
			
			//遍历挂载Compute的Id 
			
			$CheckedIds.each(function(){
				
				var $this = $(this);
		    	var computeIdentifier = $this.closest("tr").find("td").eq(1).text()+"&nbsp;";
		    	
		    	if($.inArray($this.val(),selectedArray) == -1){
		    		
		    		//拼装HTML文本
					
					html +='<div class="resources alert alert-block alert-info fade in">';
					html +='<button type="button" class="close" data-dismiss="alert">×</button>';
					html +='<input type="hidden" value="'+$this.val()+'" id="computeIds" name="computeIds">';
					html +='<dd><em>挂载实例</em>&nbsp;&nbsp;<strong>'+computeIdentifier+'</strong></dd>';
					html +='</div> ';
					
				}
				
			});
			
			
			//初始化
			selectedArray = [];
			$CheckedIds.removeAttr('checked');
			$ModalDiv.find(".checker > span").removeClass("checked");
			 
			
			//插入HTML文本
			
			$("#resourcesDIV dl").append(html);
			
		}); 
	</script>
	
</head>

<body>
	
	<style>body{background-color: #f5f5f5;}</style>
	
	<form id="inputForm" action="${ctx}/resources/update/elb/" method="post" class="input-form form-horizontal" >
		
		<input type="hidden" name="id" value="${resources.id }">
		
		<fieldset>
			<legend><small>变更负载均衡器ELB</small></legend>
			
			<div class="control-group">
				<label class="control-label" for="title">所属服务申请</label>
				<div class="controls">
					<p class="help-inline plain-text">${elb.apply.title}</p>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="identifier">标识符</label>
				<div class="controls">
					<p class="help-inline plain-text">${elb.identifier}</p>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="keepSession">是否保持会话</label>
				<div class="controls">
					<c:forEach var="map" items="${keepSessionMap}">
						<label class="radio inline"> 
							<input type="radio" name="keepSession" value="${map.key}" <c:if test="${elb.keepSession == map.key }"> checked="checked"</c:if>>${map.value}
						</label>
					</c:forEach>
				</div>
			</div>
			
			<table class="table table-bordered table-condensed"  >
				<thead><tr><th>Protocol</th><th>Load Balance Port</th><th>Instance Port</th><th></th></tr></thead>
				<tbody>
					<c:forEach var="item" items="${elb.elbPortItems}">
						<tr class="clone">
							<td>
								<select id="protocol" name="protocols" class="input-small required">
									<c:forEach var="map" items="${protocolMap}">
										<option value="${map.key }" <c:if test="${item.protocol == map.value }">selected="selected"</c:if>	
										>${map.value }</option>
									</c:forEach>
								</select>
							</td>
							<td><input type="text" id="sourcePort" name="sourcePorts" value="${item.sourcePort }" class="input-small " maxlength="45" placeholder="...SourcePort"></td>
							<td><input type="text" id="targetPort" name="targetPorts" value="${item.targetPort }" class="input-small " maxlength="45" placeholder="...TargetPort"></td>
							<td><a class="btn clone">添加</a>&nbsp;<a class="btn clone disabled" >删除</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
			<div class="control-group">
				<div class="controls">
					 <a id="addComputeBtn" class="btn" data-toggle="modal" href="#computeModal" >实例相关资源</a>
				</div>
			</div>
			
			<!-- 生成的资源 -->
			<div id="resourcesDIV"><dl class="dl-horizontal">
				<c:forEach var="compute" items="${relationComputes }">
					<div class="resources alert alert-block alert-info fade in">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<input type="hidden" name="computeIds" id="computeIds" value="${compute.id }">
						<dd>
							<em>挂载实例</em>&nbsp;&nbsp;<strong>${compute.identifier }&nbsp;</strong>
						</dd>
					</div>
				</c:forEach>
			</dl></div>
			
			<hr>
			
			<div class="control-group">
				<label class="control-label" for="serviceTagId">服务标签</label>
				<div class="controls">
					<select id="serviceTagId" name="serviceTagId" class="required">
						<c:forEach var="item" items="${tags}">
							<option value="${item.id }" 
								<c:if test="${item.id == resources.serviceTag.id }">
									selected="selected"
								</c:if>
							>${item.name}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="usedby">运维人</label>
				<div class="controls">
					<select id="usedby" name="usedby" class="required">
						<c:forEach var="map" items="${assigneeMap}">
							<option value="${map.key}" 
								<c:if test="${map.key == resources.usedby }">
									selected="selected"
								</c:if>
							>${map.value}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="changeDescription">变更描述</label>
				<div class="controls">
					<textarea rows="3" id="changeDescription" name="changeDescription" placeholder="...变更描述"
						maxlength="200" class="required">${change.description}</textarea>
				</div>
			</div>
				 
			<div class="form-actions">
				<input class="btn" type="button" value="返回" onclick="history.back()">
				<input class="btn btn-primary" type="submit" value="提交">
			</div>
			
		</fieldset>
		
	</form>
	
	<!-- 实例选择的Modal -->
	<form id="modalForm" action="#" >
		<div id="computeModal" class="modal container hide fade" tabindex="-1">
	
			<div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button><h4>实例</h4></div>
				
			<div class="modal-body">
				<table class="table table-striped table-bordered table-condensed">
					<thead><tr>
						<th><input type="checkbox"></th>
						<th>实例标识符</th>
						<th>基本信息(操作系统,位数,规格)</th>
						<th>用途信息</th>
						<th>IP地址</th>
					</tr></thead>
					<tbody id="resources-tbody"></tbody>
				</table>
			</div>
				
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
				<a id="ModalSave" href="#" class="btn btn-primary" data-dismiss="modal" >确定</a>
			</div>
		</div>
	</form><!-- 实例规格选择的Modal End -->
	
</body>
</html>