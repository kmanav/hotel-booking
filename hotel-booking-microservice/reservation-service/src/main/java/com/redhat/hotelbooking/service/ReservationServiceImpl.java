package com.redhat.hotelbooking.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.redhat.hotelbooking.bean.Reservation;
import com.redhat.hotelbooking.bean.SourceReservation;
import com.redhat.hotelbooking.repository.ReservationRepository;
import com.redhat.hotelbooking.repository.SourceReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
@Transactional
class ReservationServiceImpl implements ReservationService {

	@Autowired
	private ReservationRepository reservationRepository;

    @Autowired
    private SourceReservationRepository sourceReservationRepository;

    @Value("${BOOKING_STATE_SERVICE_ENDPOINT:booking-state-service:8080}")
    private String BOOKING_STATE_SERVICE_ENDPOINT;

	@Override
	public Page<Reservation> findByCustomerId(Pageable pageable, Integer customerId) throws IOException {
		return reservationRepository.findByCustomerId(pageable, customerId);
	}

	@Override
	public boolean checkin(String reservationId){
		Reservation reservation2Update = reservationRepository.findById(reservationId).get();
		reservation2Update.setStatus(ReservationService.CHECKIN_STATUS);
		reservationRepository.save(reservation2Update);
		return true;
	}

    @Override
    public boolean checkout(String reservationId){
        Reservation reservation2Update = reservationRepository.findById(reservationId).get();
        reservation2Update.setStatus(ReservationService.CHECKOUT_STATUS);
        reservationRepository.save(reservation2Update);
        return true;
    }

    @Override
    public SourceReservation confirm(Integer customerId) throws IOException, ParseException{
        final String getbookingstate_url = "http://" + BOOKING_STATE_SERVICE_ENDPOINT + "/getbookingstate";
        final String deletebookingstate_url = "http://" + BOOKING_STATE_SERVICE_ENDPOINT + "/deletebookingstate";

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response
                = restTemplate.getForEntity(getbookingstate_url + "/" + customerId, String.class);
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(response.getBody());
        int roomId = root.path("selection").path("room").path("id").asInt();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date checkin = sdf.parse(root.path("search").path("date_in").asText());
        Date checkout = sdf.parse(root.path("search").path("date_out").asText());
        double dailyRate = root.path("selection").path("room").path("rate").asDouble();

        SourceReservation newSourceReservation =
                new SourceReservation("NA", customerId, roomId, checkin, checkout, dailyRate, "RESERVED");

        SourceReservation result = sourceReservationRepository.save(newSourceReservation);
        restTemplate.delete(deletebookingstate_url + "/" + customerId);
        return result;
    }
}
