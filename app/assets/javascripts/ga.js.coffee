$(document).ready ->
  if $("body").data("env")=="Production"
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

    $('#video_modal_button').click ->
      _gaq.push(['_trackEvent', 'frontpage', 'Play Video'])


    $('#facebook_link').click ->
      console.log "test"
      _gaq.push(['_trackEvent', 'frontpage', 'Facebook Login'])
