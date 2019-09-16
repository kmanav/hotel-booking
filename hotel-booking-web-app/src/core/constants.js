/* *
  Application Constants
 */
const constants = {
  authenticate_url : 'http://customer-service-hotel-booking-customer.apps.rhpds311.openshift.opentlc.com/customer/authenticate?email='
  , get_customerdetails_url : 'http://customer-service-hotel-booking-customer.apps.rhpds311.openshift.opentlc.com/customer/details?customerid='
  , get_bookingstate_url : 'http://booking-state-service-hotel-booking-state.apps.rhpds311.openshift.opentlc.com/getbookingstate'
  , set_search_url : 'http://booking-state-service-hotel-booking-state.apps.rhpds311.openshift.opentlc.com/bookingstate/setsearch'
  , find_hotels_url : 'http://inventory-service-hotel-booking-inventory.apps.rhpds311.openshift.opentlc.com/hotel/findbyuserid?userid='
  , find_rooms_url : 'http://inventory-service-hotel-booking-inventory.apps.rhpds311.openshift.opentlc.com/room/findbyuserid?userid='
  , find_reservations_url : 'http://reservation-service-hotel-booking-reservation.apps.rhpds311.openshift.opentlc.com/reservation/findbycustomerid?customerid='
  , confirm_reservation_url : 'http://reservation-service-hotel-booking-reservation.apps.rhpds311.openshift.opentlc.com/reservation/confirm?customerid='

};

export default constants;
