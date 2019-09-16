package com.redhat.hotelbooking.service;

import java.io.IOException;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.redhat.hotelbooking.bean.Hotel;
import com.redhat.hotelbooking.repository.HotelRepository;

@Service
@Transactional
class HotelServiceImpl implements HotelService {
	private final Logger logger = Logger.getLogger(HotelServiceImpl.class.getName());
	
	@Autowired
	private HotelRepository hotelRepository;

	@Value("${BOOKING_STATE_SERVICE_GET_ENDPOINT:http://booking-state-service:8080/getbookingstate}")
	private String BOOKING_STATE_SERVICE_GET_ENDPOINT;

	public Page<Hotel> listAllByPage(Pageable pageable) {
		return hotelRepository.findAll(pageable);
	}

	public Page<Hotel> findByUserID(Pageable pageable, String userid) throws IOException {		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response
				= restTemplate.getForEntity(BOOKING_STATE_SERVICE_GET_ENDPOINT + "/" + userid, String.class);
		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(response.getBody());
		JsonNode city = root.path("search").path("city_name");
		logger.info("hotelservice: looking for bookings for user with id = " + userid +" in city = " + city.asText());
		return hotelRepository.findByCity(pageable, city.asText());
	}
}
