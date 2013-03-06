package com.sobey.cmop.mvc.web.apply.iaas;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sobey.cmop.mvc.comm.BaseController;
import com.sobey.cmop.mvc.entity.ComputeItem;
import com.sobey.cmop.mvc.entity.StorageItem;

/**
 * 负责公网IPNetworkEipItem的管理
 * 
 * @author liukai
 * 
 */
@Controller
@RequestMapping(value = "/apply/eip")
public class EIPController extends BaseController {

	private static final String REDIRECT_SUCCESS_URL = "redirect:/apply/";

	/**
	 * 跳转到新增页面
	 */
	@RequestMapping(value = "/save", method = RequestMethod.GET)
	public String createForm(Model model) {
		return "apply/eip/eipForm";
	}

	/**
	 * 新增
	 * 
	 * @param applyId
	 * @param ispTypes
	 *            ISP运营商的ID
	 * @param linkTypes
	 *            关联类型,区分关联的是ELB还是实例. 0:ELB ; 1: 实例
	 * @param linkIds
	 *            关联ID
	 * @param protocols
	 *            协议数组 格式{1-2-3,4-5-6}下同
	 * @param sourcePorts
	 *            源端口数组
	 * @param targetPorts
	 *            目标端口数组
	 * @param redirectAttributes
	 *            关联实例数组
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(@RequestParam(value = "applyId") Integer applyId, @RequestParam(value = "ispTypes") String[] ispTypes, @RequestParam(value = "linkTypes") String[] linkTypes,
			@RequestParam(value = "linkIds") String[] linkIds,

			@RequestParam(value = "protocols") String[] protocols, @RequestParam(value = "sourcePorts") String[] sourcePorts, @RequestParam(value = "targetPorts") String[] targetPorts,

			RedirectAttributes redirectAttributes) {

		comm.eipService.saveEIPToApply(applyId, ispTypes, linkTypes, linkIds, protocols, sourcePorts, targetPorts);

		redirectAttributes.addFlashAttribute("message", "创建实例成功.");

		return REDIRECT_SUCCESS_URL;
	}

	/**
	 * 从服务申请表页面跳转到实例的修改页面.
	 */
	@RequestMapping(value = "/update/{id}/applyId/{applyId}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("id") Integer id, @PathVariable("applyId") Integer applyId, Model model) {
		model.addAttribute("storage", comm.es3Service.getStorageItem(id));
		return "apply/eip/eipUpateForm";
	}

	/**
	 * 修改实例信息后,跳转到applyId的服务申请修改页面
	 */
	@RequestMapping(value = "/update/{id}/applyId", method = RequestMethod.POST)
	public String update(@PathVariable("id") Integer id, @RequestParam("applyId") Integer applyId, @RequestParam(value = "space") Integer space,
			@RequestParam(value = "storageType") Integer storageType, @RequestParam(value = "computeIds") String[] computeIds, RedirectAttributes redirectAttributes) {

		List<ComputeItem> computeItemList = new ArrayList<ComputeItem>();

		for (String computeId : computeIds) {
			computeItemList.add(comm.computeService.getComputeItem(Integer.valueOf(computeId)));
		}

		StorageItem storageItem = comm.es3Service.getStorageItem(id);
		storageItem.setSpace(space);
		storageItem.setStorageType(storageType);
		storageItem.setComputeItemList(computeItemList);
		comm.es3Service.saveOrUpdate(storageItem);

		redirectAttributes.addFlashAttribute("message", "修改EIP " + storageItem.getIdentifier() + " 成功");

		return "redirect:/apply/update/" + applyId;
	}

	/**
	 * 删除实例后,跳转到applyId的服务申请修改页面
	 */
	@RequestMapping(value = "/delete/{id}/applyId/{applyId}")
	public String delete(@PathVariable("id") Integer id, @PathVariable("applyId") Integer applyId, RedirectAttributes redirectAttributes) {

		comm.es3Service.deleteStorageItem(id);

		redirectAttributes.addFlashAttribute("message", "删除EIP成功");

		return "redirect:/apply/update/" + applyId;
	}

}