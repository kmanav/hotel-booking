package com.redhat.hotelbooking;

import java.io.IOException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class BookingStateRestAPI {

    private final Logger logger = Logger.getLogger(BookingStateRestAPI.class.getName());
    HashMap<String, String> defaultCache = new HashMap<String, String>();

    @RequestMapping(method = RequestMethod.GET, name = "/getbookingstate/{id}")
    public String handleGetorCreate(String id) {
        logger.info("Get by id Booking State id=" + id);
        String data = defaultCache.get(id);
        if (data == null) {
        	data = createEmptyBookingState(id);
        }
        return data;
    }

    @RequestMapping(method = RequestMethod.POST, name="/bookingstate/setsearch")
    public ResponseEntity<HttpStatus> handleSetSearch(@RequestBody String reservation) throws IOException {
    	logger.info("Set Search");
    	if (reservation != null) {
	    	ObjectMapper mapper = new ObjectMapper();
	    	JsonNode root = mapper.readTree(reservation);
	    	if (root.get("id") != null) {
			    defaultCache.put(root.get("id").asText(), reservation);
			    return new ResponseEntity<HttpStatus>(HttpStatus.ACCEPTED);
	    	}
    	} 
    	return new ResponseEntity<HttpStatus>(HttpStatus.BAD_REQUEST);
    }

    @RequestMapping(method = RequestMethod.DELETE, name = "/deletebookingstate/{id}")
    public ResponseEntity<HttpStatus> handleDelete(String id) {
        logger.info("DeleteBooking State id=" + id);
        String data = defaultCache.remove(id);
        if (data != null) {
        	logger.info(String.format("Booking State Updated for [%s]", id));
        	return new ResponseEntity<HttpStatus>(HttpStatus.OK);
        }
        logger.log(Level.SEVERE, String.format("Failed to delete Booking State [%s]", id));
        return new ResponseEntity<HttpStatus>(HttpStatus.BAD_REQUEST);
    }
    
    private String createEmptyBookingState (String id){
        JSONObject searchState = new JSONObject()
                .put("city_name", "")
                .put("date_in", "")
                .put("date_out", "");

        JSONObject selectionHotelState = new JSONObject()
                .put("id", "")
                .put("name", "");

        JSONObject selectionRoomState = new JSONObject()
                .put("id", "")
                .put("room_number", "");

        JSONObject selection = new JSONObject()
                .put("hotel", selectionHotelState)
                .put("room", selectionRoomState);

        JSONObject bookingState = new JSONObject()
                .put("id", id)
                .put("state", "/")
                .put("search", searchState)
                .put("selection", selection);
                
        return bookingState.toString();
    }    
}
