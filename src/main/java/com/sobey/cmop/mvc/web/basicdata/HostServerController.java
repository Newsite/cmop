package com.sobey.cmop.mvc.web.basicdata;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sobey.cmop.mvc.comm.BaseController;
import com.sobey.cmop.mvc.entity.ServerModel;
import com.sobey.cmop.mvc.service.onecmdb.OneCmdbService;
import com.sobey.framework.utils.Servlets;

/**
 * HostServerController负责服务器主机的管理
 * 
 * @author liukai
 * 
 */
@Controller
@RequestMapping(value = "/basicdata/host")
public class HostServerController extends BaseController {

	private static final String REDIRECT_SUCCESS_URL = "redirect:/basicdata/host/";

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam(value = "page", defaultValue = "1") int pageNumber, @RequestParam(value = "page.size", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "serverType", required = false, defaultValue = "") String serverType, Model model, ServletRequest request) {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, REQUEST_PREFIX);
		// 将搜索条件编码成字符串,分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, REQUEST_PREFIX));
		model.addAttribute("page", comm.hostServerService.getHostServerPageable(searchParams, pageNumber, pageSize));
		return "basicdata/host/hostList";
	}

	/**
	 * 跳转到新增页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.GET)
	public String createForm(Model model) {
		return "basicdata/host/hostForm";
	}

	/**
	 * 新增HostServer
	 * 
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(@RequestParam(value = "serverModelId") Integer serverModelId, @RequestParam(value = "rack") String rack, @RequestParam(value = "site") String site,
			@RequestParam(value = "height") String height, @RequestParam(value = "locationAlias") String locationAlias, @RequestParam(value = "ipAddress") String ipAddress,
			@RequestParam(value = "serverType") Integer serverType, @RequestParam(value = "description") String description, RedirectAttributes redirectAttributes) {

		boolean flag = comm.hostServerService.addHostServer(serverType, serverModelId, rack, site, height, locationAlias, ipAddress, description);

		redirectAttributes.addFlashAttribute("message", flag ? "创建服务器成功！" : "服务器名称已存在,请按照格式 Company Model Rack-Site 正确输入.");

		return REDIRECT_SUCCESS_URL;
	}

	/**
	 * 跳转至修改页面
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/update/{id}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("id") Integer id, Model model) {
		model.addAttribute("hostServer", comm.hostServerService.getHostServer(id));
		return "basicdata/host/hostForm";
	}

	/**
	 * 修改HostServer
	 * 
	 * @param hostServer
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(@RequestParam(value = "id") Integer id, @RequestParam(value = "serverModelId") Integer serverModelId, @RequestParam(value = "rack") String rack,
			@RequestParam(value = "site") String site, @RequestParam(value = "height") String height, @RequestParam(value = "locationAlias") String locationAlias,
			@RequestParam(value = "ipAddress") String ipAddress, @RequestParam(value = "serverType") Integer serverType, @RequestParam(value = "description") String description,
			@RequestParam(value = "oldDisplayName") String oldDisplayName, RedirectAttributes redirectAttributes) {

		boolean flag = comm.hostServerService.updateHostServer(id, serverType, serverModelId, rack, site, height, locationAlias, ipAddress, description, oldDisplayName);
		redirectAttributes.addFlashAttribute("message", flag ? "修改服务器成功！" : "服务器名称已存在,请按照格式 Company Model Rack-Site 正确输入.");

		return REDIRECT_SUCCESS_URL;
	}

	@RequestMapping(value = "delete/{id}")
	public String delete(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {

		boolean flag = comm.hostServerService.delete(id);

		redirectAttributes.addFlashAttribute("message", flag ? "删除服务器成功！" : "删除服务器失败！");

		return REDIRECT_SUCCESS_URL;
	}

	@RequestMapping(value = { "ecs/{id}" })
	public String ecs(@PathVariable("id") Integer id, Model model) {
		model.addAttribute("hostServer", comm.hostServerService.getHostServer(id));
		model.addAttribute("ecsList", comm.hostServerService.getEcsByHost(id));
		return "basicdata/host/ecsList";
	}

	@RequestMapping(value = { "syn" })
	public String syn(Model model, RedirectAttributes redirectAttributes) {
		String rtn = comm.hostServerService.syn();
		String[] rtnArr = rtn.split("-");
		if (rtnArr[0].equals("true")) {
			redirectAttributes.addFlashAttribute("message", "同步宿主机和虚拟机成功！共计：宿主机（" + rtnArr[1] + "），虚拟机（" + rtnArr[2] + "）");
		}
		return REDIRECT_SUCCESS_URL;
	}

	@RequestMapping(value = { "export" })
	public String export(Model model, RedirectAttributes redirectAttributes) {
		boolean flag = comm.hostServerService.export();
		if (flag) {
			redirectAttributes.addFlashAttribute("message", "导出宿主机及其虚拟机关系成功！D:\\Host_Vm.xls");
		}
		return REDIRECT_SUCCESS_URL;
	}

	/**
	 * 获得oneCMDB中的Rack.
	 * 
	 * @return
	 */
	@ModelAttribute("rackMap")
	public Map getRackFromOnecmdb() {
		return OneCmdbService.findCiByText("Rack");
	}

	/**
	 * 服务器型号getServerModel list
	 * 
	 * @return
	 */
	@ModelAttribute("serverModelList")
	public List<ServerModel> getServerModelList() {
		return comm.serverModelService.getServerModelList();
	}

}
