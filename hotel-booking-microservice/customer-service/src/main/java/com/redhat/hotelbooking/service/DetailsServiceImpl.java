package com.redhat.hotelbooking.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.redhat.hotelbooking.bean.Details;
import com.redhat.hotelbooking.repository.DetailsRepository;

@Service
@Transactional
class DetailsServiceImpl implements DetailsService {

	@Autowired
	private DetailsRepository detailsRepository;

	public Details get(Integer customerid) {
		return detailsRepository.findById(customerid).get();
	}
}
