package com.sobey.cmop.mvc.dao.custom.imp;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.sobey.cmop.mvc.dao.custom.IpPoolDaoCustom;
import com.sobey.cmop.mvc.entity.Location;
import com.sobey.cmop.mvc.entity.Vlan;

@Component
public class IpPoolDaoCustomImp implements IpPoolDaoCustom {

	private static Logger logger = LoggerFactory.getLogger(IpPoolDaoCustomImp.class);

	@PersistenceContext
	private EntityManager em;

	@SuppressWarnings("unchecked")
	@Override
	public List<String> findAllIpAddressList(Location location, Vlan vlan) {
		String sql = "SELECT ip_address FROM ip_pool where vlan_id='" + vlan.getId() + "'";
		return em.createNativeQuery(sql).getResultList();
	}

	@Override
	public int updateIpPoolByStatus(int status) {
		String sql = "update ip_pool set status=" + status + ",host_server_id=null where host_server_id in (select id from host_server where server_type=1)";
		Query query = em.createNativeQuery(sql);
		int updateCount1 = query.executeUpdate();
		System.out.println("宿主机关联的虚拟机IP状态修改数：" + updateCount1);

		sql = "update ip_pool set status=" + status + ",host_server_id=null where ip_address in (select ip_address from host_server where server_type=1)";
		query = em.createNativeQuery(sql);
		int updateCount2 = query.executeUpdate();
		System.out.println("宿主机对应IP状态修改数：" + updateCount2);

		return updateCount1 + updateCount2;
	}

}