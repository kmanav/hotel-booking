package com.redhat.hotelbooking.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.redhat.hotelbooking.bean.Room;
import com.redhat.hotelbooking.service.RoomService;


@RestController
//specifying endpoint location
@RequestMapping("/room")
public class RoomController {

    @Autowired
    private RoomService roomService;

    /**
     the getAll method retrieves all food items in the database. This is mapped to hte GET rest action
     @return A List() of Hotel items
     **/
    @RequestMapping(method=RequestMethod.GET, value="/findbyuserid")
    public Page<Room> findByUserID(@RequestParam("userid") String userid, Pageable pageable) throws IOException {
        return roomService.findByUserID(pageable, userid);
    }
}