class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_locale_from_url 
  before_filter :authenticate_user!
  before_filter :save_referer



#  unless Rails.application.config.consider_all_requests_local
     rescue_from ActionController::RoutingError, :with => :render_404
     rescue_from ActionController::UnknownAction, :with => :render_404
     rescue_from ActiveRecord::RecordNotFound, :with => :render_404
     rescue_from Exception, :with => :render_500
    # rescue_from MyApp::CustomError, :with => :custom_error_resolution
#  end
    
  def render_404
     if /(jpe?g|png|gif)/i === request.path
       render :text => "404 Not Found", :status => 404
     else
       render :template => "errors/404", :layout => 'application', :status => 404
     end
   end  
   
   def render_500(exception = nil)
     if exception
         logger.error "**** ERROR **** Rendering 500: #{exception.message}"
     end
     
     render :template => "errors/500", :layout => 'application', :status => 500
    end
  # UsersController
#  rescue_from MyApp::SomeReallySpecificUserError, :with => :user_controller_resolution
  



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
  
  def save_referer
    unless current_user
      unless session[:referer]
        session[:referer] = request.env["HTTP_REFERER"] || 'none'
      end
    end
  end

end
