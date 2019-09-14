/* *
  Application Constants
 */
const constants = {
  authenticate_url : 'http://customer-service-hotel-booking-customer.192.168.42.77.nip.io/customer/authenticate?email='
  , get_customerdetails_url : 'http://customer-service-hotel-booking-customer.192.168.42.77.nip.io/customer/details?customerid='
  , get_bookingstate_url : 'http://booking-state-service-hotel-booking-state.192.168.42.77.nip.io/getbookingstate'
  , set_search_url : 'http://booking-state-service-hotel-booking-state.192.168.42.77.nip.io/bookingstate/setsearch'
  , find_hotels_url : 'http://inventory-service-hotel-booking-inventory.192.168.42.77.nip.io/hotel/findbyuserid?userid='
  , find_rooms_url : 'http://inventory-service-hotel-booking-inventory.192.168.42.77.nip.io/room/findbyuserid?userid='
  , find_reservations_url : 'http://reservation-service-hotel-booking-reservation.192.168.42.77.nip.io/reservation/findbycustomerid?customerid='
  , confirm_reservation_url : 'http://reservation-service-hotel-booking-reservation.192.168.42.77.nip.io/reservation/confirm?customerid='

};

export default constants;
