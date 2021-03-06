package com.sobey.cmop.mvc.web.apply.iaas;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sobey.cmop.mvc.comm.BaseController;

/**
 * 负责手机监控列表MonitorPhone 的管理
 * 
 * @author liukai
 * 
 */
@Controller
@RequestMapping(value = "/apply/monitorPhone")
public class MonitorPhoneController extends BaseController {

	/**
	 * 从服务申请表页面跳转到手机监控列表的修改页面.
	 */
	@RequestMapping(value = "/update/applyId/{applyId}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("applyId") Integer applyId, Model model) {

		model.addAttribute("apply", comm.applyService.getApply(applyId));

		return "apply/monitor/monitorPhoneUpateForm";
	}

	/**
	 * 修改手机监控列表.完成后跳转到applyId的服务申请修改页面
	 */
	@RequestMapping(value = "/update/applyId", method = RequestMethod.POST)
	public String update(@RequestParam("applyId") Integer applyId,
			@RequestParam(value = "monitorPhones") String[] monitorPhones, RedirectAttributes redirectAttributes) {

		comm.monitorPhoneService.updateMonitorPhoneToApply(applyId, monitorPhones);

		redirectAttributes.addFlashAttribute("message", "修改手机监控列表成功");

		return "redirect:/apply/update/" + applyId;
	}

}
