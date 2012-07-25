$(document).ready ->
#  if $("body").data("env")=="Production"

    _gaq = _gaq || []
    _gaq.push(['_setAccount', 'UA-29880523-1'])
    _gaq.push(['_setCampSourceKey', 'utm_source'])
    _gaq.push(['_setCampMediumKey', 'utm_medium'])
    _gaq.push(['_setCampContentKey', 'utm_keyword'])
    _gaq.push(['_setCampTermKey', 'utm_keyword'])
    _gaq.push(['_setCampNameKey', 'utm_campaign'])
    _gaq.push(['_trackPageview'])

    (-> 
      ga = document.createElement('script')
      ga.type = 'text/javascript'
      ga.async = true
      ga.src = if 'http:' == document.location.protocol then 'http://' + 'google-analytics.com/ga.js' else 'https://' + 'google-analytics.com/ga.js'
      s = document.getElementsByTagName('script')[0]
      s.parentNode.insertBefore(ga, s))()

     # GA Tracking Events
     #
     # Facebook Actions:  
     #    Appointment
     #    CancelAppointment
     #    Invite
     #    CancelInvite

    $("body").bind("fb_event", (event, action) -> 
       console.log "GA tracking event: "+ action
       _gaq.push(['_trackEvent', 'Facebook', action]))

    $('#video_modal_button').click ->
      _gaq.push(['_trackEvent', 'Frontpage', 'Play Video'])

    $('#facebook_link').click ->
      _gaq.push(['_trackEvent', 'Facebook', 'Login'])

    $('#skip_appointment').click ->
      _gaq.push(['_trackEvent', 'Welcome', 'Skip Appointment'])


	# static_pages/home_not_logged_in
	# id=login_button

    # appointments/_main_modal
	# id="main_modal_delete"
	# id="main_modal_save"  (unter "Jetzt verabreden" und "Termin bearbeiten")
	# id="main_modal_join"  ("Die nächsten Arbeitssessions deiner Freunde")
	# id="main_modal_accept" ("Erhaltene Einladungen")
	# id="main_modal_close"
	
	# appointments/show
	# id="appointment_rejected"
	# id="appointment_accepted_current_user"
	# id="appointment_accepted_not_logged_in"
	
	# appointments/show_and_welcome
	# id=show_and_welcome_save_continue
	
	# static_pages/home_logged_in:
	# id=start_work_button
	# id=send_dialogue_button_right_block (Facebook Freunde einladen auf Dashboard)
	# id=send_dialogue_after_start_work (Facebook Freunde einladen, nachdem man auf "start working" geclickt hat)
	
	# static_pages/login_to_accept_appointment:
	# id=facebook_link
	
	# cameras/show:
	# id=join_work_session_after_camera_test ("Ja, alles hat funktioniert.")
	# id=session_start_problems
	# id=camera_problems
	
	# static_pages/welcome
	# id=skip_appointment
	# id=save_appointment_on_welcomepage
	
