module WorkSessionsHelper
  
  def place_size_in_html
    "<span id=size 
    data-stream_width=#{StartWork::Application.config.stream_width.to_s} 
    data-stream_height=#{StartWork::Application.config.stream_height.to_s} 
    data-stream_padding=#{StartWork::Application.config.stream_padding.to_s}></span>" 
  end
  
end
