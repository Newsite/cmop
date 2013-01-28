
$(document).ready(function() {
	
	// === uniform === //
	
	 $("input:radio,input:checkbox,input:file").uniform();
	
	 
	// === Tooltips === //
	 
	$('.tip').tooltip();	
	$('.tip-left').tooltip({ placement: 'left' });	
	$('.tip-right').tooltip({ placement: 'right' });	
	$('.tip-top').tooltip({ placement: 'top' });	
	$('.tip-bottom').tooltip({ placement: 'bottom' });	
	
	
	// === datepicker === //
	
 	$('.datepicker').datepicker();
 	
 	// === Reset 点击reset按钮,form里的输入框情况,并提交form执行一次查询. ===//
 	
 	$("button.reset").on('click', function(){
 		var $form = $(this).closest("form"); 
 		$form.find("input[type=text]").val('');
 		$form.find("select option:first").prop('selected', true);
 		$form.submit();
 	});
 	
 	
 	// === option 点击More,得到更多的搜索条件===//
 	
 	$("button.options").on('click', function(){
 		
 		//图标切换
 		
 		$(this).find("i").toggleClass("icon-resize-small icon-resize-full");
 		
 		//搜索框切换+清空文本.
 		
 		var $options =$("div.options"); 
 		$options.find("select option:first").prop('selected', true);
 		$options.toggle(300).find("input[type=text]").val('');
 		
 	});
 	
 	
 	// === 所有input:submit的控件点击后,将其设置为disabled不可用,页面弹出遮罩层===//
 	
	$("input[type=submit]").on('click', function(){
		var $this = $(this);
		$this.closest("form").valid() && $this.button('loading').addClass("disabled").closest("body").modalmanager('loading');
	});
	
	
});

/**
 * 获得当前年月份加上参数月的日期.
 * 如:
 * <pre>
 * getDatePlusMonthNum(0) 当前的时间 2013-01-28
 * getDatePlusMonthNum(3) 三月后的时间 2013-04-28
 * </pre>
 * @param monthNum  月期数
 * @returns {String}
 */
function getDatePlusMonthNum(monthNum) {
	var CurrentDate = new Date();
	CurrentDate.setMonth(CurrentDate.getMonth() + monthNum);
	var year = CurrentDate.getFullYear();
	var month = CurrentDate.getMonth() + 1;
	var day = CurrentDate.getDate();
	if (month <= 9) {
		month = "0" + month;
	}
	if (month == "00") {
		month = "01";
	}
	if (day <= 9) {
		day = "0" + day;
	}
	return year + "-" + month + "-" + day;
}


