<html>
<head>

</head>
<body>

	<p><#if operateUrl?exists>${operateUrl}<#elseif operateDoneStr?exists>${operateDoneStr}<#else>你好,请审批以下内容.</#if></p>
	
	<ul>
		
		<#if serviceTag?exists ><!-- 服务标签 ServiceTag -->
			<li>
				<strong>服务标签基本信息</strong>
				<ul> 
					<li><em>申请人</em>&nbsp;: ${serviceTag.user.name} </li>
					<li><em>标签名</em>&nbsp;: ${serviceTag.name}</li>
					<li><em>申请时间</em>&nbsp;: ${serviceTag.createTime}</li>
					
					<li><em>优先级</em>&nbsp;: 
						<#list priorityMap?keys as k >
							<#if serviceTag.priority?string == k>
								${priorityMap[k]}
							</#if>
						</#list>
					</li>
					
					<li><em>服务起止日期</em>&nbsp;: ${serviceTag.serviceStart} <em>至</em>&nbsp; ${serviceTag.serviceEnd}</li>
					<li><em>用途描述</em>&nbsp;: ${serviceTag.description}</li>
				</ul>	
			</li>
		</#if> <!-- 服务标签 ServiceTag End -->
		
		<li>
			<!-- 实例Compute -->
			<#if (computes?exists) && (computes?size > 0) >
				<strong>计算资源(PCS,ECS)</strong>
				<#list computes as compute>
					<ul>
					
						<li><em>标识符</em>&nbsp;:${compute.identifier}</li>
						<li><em>用途信息</em>&nbsp;:${compute.remark}</li>
						<li><em>基本信息</em>&nbsp;:
						
							<#list osTypeMap?keys as k >
								<#if compute.osType?string == k>${osTypeMap[k]}</#if>
							</#list>
						
							<#list osBitMap?keys as k >
								<#if compute.osBit?string == k>${osBitMap[k]}</#if>
							</#list>
						
							<!-- 规格 1.PCS 2.ECS -->
							<#if compute.computeType == 1 >
								<#list pcsServerTypeMap?keys as k >
									<#if compute.serverType?string == k>${pcsServerTypeMap[k]}</#if>
								</#list>
							<#else>
								<#list ecsServerTypeMap?keys as k >
									<#if compute.serverType?string == k>${ecsServerTypeMap[k]}</#if>
								</#list>
							</#if>
						
					  </li>
						
						<li><em>关联ESG</em>&nbsp;:${compute.networkEsgItem.identifier}(${compute.networkEsgItem.description})</li>
						
						<br>
						
					</ul>
				</#list>
				
			</#if><!-- 实例Compute End-->
		
			<!-- 存储 storage  -->
			<#if (storages?exists) && (storages?size > 0) >
				<strong>ES3存储空间</strong>
				
				<#list storages as storage>
					<ul>
						<li><em>标识符</em>&nbsp;:${storage.identifier}</li>
						<li><em>存储类型</em>&nbsp;:
							<#list storageTypeMap?keys as k ><#if storage.storageType?string == k>${storageTypeMap[k]}</#if></#list>
						</li>
						<li><em>容量空间</em>&nbsp;:${storage.space}GB</li>
						<li><em>挂载实例</em>&nbsp;:${storage.mountComputes}</li>
						<br>
					</ul>
				</#list>
				
			</#if><!-- 存储 storage End-->
			
			<!-- 负载均衡器ELB -->
			<#if (elbs?exists) && (elbs?size > 0) >
				<strong>负载均衡器ELB</strong>
				
				<#list elbs as elb>
					<ul>
						<li><em>标识符</em>&nbsp;:${elb.identifier}</li>
						<li><em>是否保持会话</em>&nbsp;:
							<#list KeepSessionMap?keys as k ><#if elb.keepSession?string == k>${KeepSessionMap[k]}</#if></#list>
						</li>
						<li><em>关联实例</em>&nbsp;: 
							<#list allComputes as compute>
							
							<#if compute.networkElbItem?exists  && (compute.networkElbItem.id == elb.id ) >
								${compute.identifier}<#if compute.innerIp?exists >(${compute.innerIp})</#if> &nbsp;&nbsp;
								
							</#if>
							
							</#list>
						</li>
						
						<li><em>端口映射(协议、源端口、目标端口)</em></li>
						
						<#list elb.elbPortItems as port>
							<ul>
								<li>&nbsp;&nbsp;${port.protocol}&nbsp;,&nbsp;${port.sourcePort}&nbsp;,&nbsp;${port.targetPort}</li>
							</ul>
						</#list>
						
						<br>
					</ul>
				</#list>
				
			</#if><!-- 负载均衡器ELB End -->
			
			<!-- EIP -->
			<#if (eips?exists) && (eips?size > 0) >
				<strong>EIP</strong>
				
				<#list eips as eip>
					<ul>
						<li><em>标识符</em>&nbsp;:${eip.identifier}</li>
						
						<li><em>ISP运营商</em>&nbsp;:
							<#list ispTypeMap?keys as k ><#if eip.ispType?string == k>${ispTypeMap[k]}</#if></#list>
						</li>
						<li>
							<#if eip.computeItem?exists>
								<em>关联实例</em>&nbsp;:${eip.computeItem.identifier}<#if eip.computeItem.innerIp?exists>(${eip.computeItem.innerIp})</#if>
							</#if>
							<#if eip.networkElbItem?exists>
								<em>关联ELB</em>&nbsp;:${eip.networkElbItem.identifier}<#if eip.networkElbItem.virtualIp?exists>(${eip.networkElbItem.virtualIp})</#if>
							</#if>
						</li>
						
						<li><em>端口映射(协议、源端口、目标端口)</em></li>
						
						<#list eip.eipPortItems as port>
							<ul>
								<li>&nbsp;&nbsp;${port.protocol}&nbsp;,&nbsp;${port.sourcePort}&nbsp;,&nbsp;${port.targetPort}</li>
							</ul>
						</#list>
						
						<br>
					</ul>
				</#list>
				
			</#if><!-- EIP End -->
			
			<!-- DNS域名映射 -->
			<#if (dnses?exists) && (dnses?size > 0) >
				<strong>DNS域名映射</strong>
				
				<#list dnses as dns>
					<ul>
						<li><em>标识符</em>&nbsp;:${dns.identifier}</li>
						
						<li><em>域名</em>&nbsp;:${dns.domainName}</li>
						
						<li><em>域名类型</em>&nbsp;:
							<#list domainTypeMap?keys as k ><#if dns.domainType?string == k>${domainTypeMap[k]}</#if></#list>
						</li>
						
						<li>
							<#if dns.cnameDomain?exists>
								<em>CNAME域名</em>&nbsp;:${dns.cnameDomain}
							<#else>
								<em>目标IP</em>&nbsp;:${dns.mountElbs}
							</#if>
						</li>
						
						<br>
					</ul>
				</#list>
				
			</#if><!-- DNS域名映射 End -->
			
			<!-- ELB监控 -->
			<#if (monitorElbs?exists) && (monitorElbs?size > 0) >
				<strong>ELB监控</strong>
				
				 <#list monitorElbs as monitorElb>
				 	<ul>
					 	<li><em>标识符</em>&nbsp;:${monitorElb.identifier}</li>
						<li><em>监控ELB</em>&nbsp;:${monitorElb.networkElbItem.identifier}<#if monitorElb.networkElbItem.virtualIp?exists>(${monitorElb.networkElbItem.virtualIp})</#if></li>
						<br>
						
					</ul>
				</#list>
			
			</#if><!-- ELB监控 End -->
			
			<!-- 实例监控 -->
			<#if (monitorComputes?exists) && (monitorComputes?size > 0) >
				<strong>实例监控</strong>
				
				 
				 <#list monitorComputes as monitorCompute>
				 	<ul>
					 	<li><em>标识符</em>&nbsp;:${monitorCompute.identifier}</li>
						<li><em>IP地址</em>&nbsp;:<#if monitorCompute.ipAddress?exists>${monitorCompute.ipAddress}</#if></li>
						
						<li><em>CPU占用率</em>&nbsp;:
						报警阀值&nbsp;<#list thresholdGtMap?keys as k ><#if monitorCompute.cpuWarn?string == k>${thresholdGtMap[k]}</#if></#list>
						&nbsp;&nbsp;
						警告阀值&nbsp;<#list thresholdGtMap?keys as k ><#if monitorCompute.cpuCritical?string == k>${thresholdGtMap[k]}</#if></#list>
						</li>
						
						<li><em>内存占用率</em>&nbsp;:
						报警阀值&nbsp;<#list thresholdGtMap?keys as k ><#if monitorCompute.memoryWarn?string == k>${thresholdGtMap[k]}</#if></#list>
						&nbsp;&nbsp;
						警告阀值&nbsp;<#list thresholdGtMap?keys as k ><#if monitorCompute.memoryCritical?string == k>${thresholdGtMap[k]}</#if></#list>
						</li>
						
						<li><em>网络丢包率</em>&nbsp;:
						报警阀值&nbsp;<#list thresholdGtMap?keys as k ><#if monitorCompute.pingLossWarn?string == k>${thresholdGtMap[k]}</#if></#list>
						&nbsp;&nbsp;
						警告阀值&nbsp;<#list thresholdGtMap?keys as k ><#if monitorCompute.pingLossCritical?string == k>${thresholdGtMap[k]}</#if></#list>
						</li>
						
						<li><em>硬盘可用率</em>&nbsp;:
						报警阀值&nbsp;<#list thresholdLtMap?keys as k ><#if monitorCompute.diskWarn?string == k>${thresholdLtMap[k]}</#if></#list>
						&nbsp;&nbsp;
						警告阀值&nbsp;<#list thresholdLtMap?keys as k ><#if monitorCompute.diskCritical?string == k>${thresholdLtMap[k]}</#if></#list>
						</li>
						
						<li><em>网络延时率</em>&nbsp;:
						报警阀值&nbsp;<#list thresholdNetGtMap?keys as k ><#if monitorCompute.pingDelayWarn?string == k>${thresholdNetGtMap[k]}</#if></#list>
						&nbsp;&nbsp;
						警告阀值&nbsp;<#list thresholdNetGtMap?keys as k ><#if monitorCompute.pingDelayCritical?string == k>${thresholdNetGtMap[k]}</#if></#list>
						</li>
						
						<li><em>最大进程数</em>&nbsp;:
						报警阀值&nbsp;<#list maxProcessMap?keys as k ><#if monitorCompute.maxProcessWarn?string == k>${maxProcessMap[k]}</#if></#list>
						&nbsp;&nbsp;
						警告阀值&nbsp;<#list maxProcessMap?keys as k ><#if monitorCompute.maxProcessCritical?string == k>${maxProcessMap[k]}</#if></#list>
						</li>
						
						<li><em>监控端口</em>&nbsp;:${monitorCompute.port}</li>
						<li><em>监控进程</em>&nbsp;:${monitorCompute.process}</li>
						<li><em>挂载路径</em>&nbsp;:${monitorCompute.mountPoint}</li>
						
						<br>
					</ul>
				</#list>
			
			</#if><!-- 实例监控 End -->
			
		</li>
		
		<#if passUrl?exists>
			<li>
				<strong>审批操作</strong>
				<ul>
					<li><a href="${passUrl}">1.同意</a></li>
					<li><a href="${disagreeContinueUrl}">2.不通过但继续</a></li>
					<li><a href="${disagreeReturnUrl}">3.不通过且退回</a></li>
				</ul>
			</li>
		</#if>
	</ul>

</body>
</html>


