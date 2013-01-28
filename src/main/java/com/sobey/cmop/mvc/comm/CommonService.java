package com.sobey.cmop.mvc.comm;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sobey.cmop.mvc.service.account.AccountService;
import com.sobey.cmop.mvc.service.apply.ApplyService;
import com.sobey.cmop.mvc.service.email.SimpleMailService;
import com.sobey.cmop.mvc.service.email.TemplateMailService;
import com.sobey.cmop.mvc.service.servcieTag.ServiceTagService;

/**
 * Service公共类
 * 
 * @author liukai
 * 
 */
@Service
public class CommonService {

	@Autowired
	public AccountService accountService;

	@Autowired
	public ServiceTagService serviceTagService;

	@Autowired
	public ApplyService applyService;

	@Autowired
	public TemplateMailService templateMailService;

	@Autowired
	public SimpleMailService simpleMailService;

}
