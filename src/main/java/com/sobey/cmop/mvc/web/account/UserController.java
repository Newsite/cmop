package com.sobey.cmop.mvc.web.account;

import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sobey.cmop.mvc.entity.User;
import com.sobey.cmop.mvc.service.account.AccountManager;

@Controller
@RequestMapping(value = "/account/user")
public class UserController {

	private static final int DEFAULT_PAGE_NUM = 0;
	private static final int DEFAULT_PAGE_SIZE = 8;
	private static final String REDIRECT_SUCCESS_URL = "redirect:/account/user/";

	@Autowired
	private AccountManager accountManager;

	@Autowired
	private GroupListEditor groupListEditor;

	@InitBinder
	public void initBinder(WebDataBinder b) {
		b.registerCustomEditor(List.class, "groupList", groupListEditor);
	}

	/**
	 * 显示所有的user list
	 * 
	 * @param page
	 * @param name
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user:view")
	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "name", required = false, defaultValue = "") String name, Model model) {

		int pageNum = page != null ? page : DEFAULT_PAGE_NUM;
		Page<User> users = accountManager.getAllUser(pageNum, DEFAULT_PAGE_SIZE, name);

		model.addAttribute("page", users);
		return "account/userList";
	}

	/**
	 * 跳转到新增页面
	 * 
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user:edit")
	@RequestMapping(value = "/save", method = RequestMethod.GET)
	public String createForm(Model model) {
		model.addAttribute("user", new User());
		model.addAttribute("allGroups", accountManager.getAllGroup());
		return "account/userForm";
	}

	/**
	 * 新增
	 * 
	 * @param user
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("user:edit")
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(User user, RedirectAttributes redirectAttributes) {

		accountManager.saveUser(user);
		redirectAttributes.addFlashAttribute("message", "创建用户 " + user.getName() + " 成功");
		return REDIRECT_SUCCESS_URL;
	}

	/**
	 * 跳转到修改页面
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user:edit")
	@RequestMapping(value = "/update/{id}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("id") Integer id, Model model) {
		model.addAttribute("allGroups", accountManager.getAllGroup());
		model.addAttribute("user", accountManager.getUser(id));
		return "account/userForm";
	}

	/**
	 * 修改
	 * 
	 * @param user
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("user:edit")
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(@ModelAttribute("user") User user, RedirectAttributes redirectAttributes) {

		accountManager.saveUser(user);

		redirectAttributes.addFlashAttribute("message", "修改用户 " + user.getName() + " 成功");
		return REDIRECT_SUCCESS_URL;
	}

	/**
	 * 删除用户
	 * 
	 * @param id
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("user:edit")
	@RequestMapping(value = "delete/{id}")
	public String delete(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
		boolean falg = accountManager.deleteUser(id);
		if (!falg) {
			redirectAttributes.addFlashAttribute("message", "不能删除超级管理员");
		} else {
			redirectAttributes.addFlashAttribute("message", "删除用户成功");
		}
		return REDIRECT_SUCCESS_URL;
	}

	/**
	 * 跳转到注册页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/regist", method = RequestMethod.GET)
	public String registForm() {
		return "regist";
	}

	/**
	 * 注册
	 * 
	 * @param user
	 *            用户信息
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "/regist", method = RequestMethod.POST)
	public String regist(User user, RedirectAttributes redirectAttributes) {

		// 保存用户信息
		accountManager.saveUser(user);

		// 用户登录
		Subject subject = SecurityUtils.getSubject();
		UsernamePasswordToken token = new UsernamePasswordToken(user.getEmail(), user.getPassword());
		token.setRememberMe(true);
		subject.login(token);

		redirectAttributes.addFlashAttribute("message", "注册成功!");

		return "redirect:/home/";
	}

	/**
	 * 验证登陆邮箱是否唯一
	 * 
	 * @param oldEmail
	 * @param email
	 * @return
	 */
	@RequestMapping(value = "checkEmail")
	@ResponseBody
	public String checkEmail(@RequestParam("oldEmail") String oldEmail, @RequestParam("email") String email) {

		if (email.equals(oldEmail) || accountManager.findUserByEmail(email) == null) {
			return "true";
		}
		return "false";
	}
}