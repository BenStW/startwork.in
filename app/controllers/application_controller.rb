class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_locale_from_url 
  before_filter :authenticate_user!


 private
 
  def set_locale
  #  logger.debug "**********************"
  #  logger.debug "params[:locale] = #{params[:locale]}"
  #  logger.debug " ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/]) = #{((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])}"
  #  logger.debug "I18n.default_locale = #{I18n.default_locale}" 
    I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/]) || I18n.default_locale 
    logger.debug "set I18n.locale to #{I18n.locale}"
  #  logger.debug "**********************"    
  end
  


end
