class ChatEntriesController < ApplicationController
  def latest
    @chat_entry = ChatEntry.where("connection_id=?", params[:connection_id]).last
    render :json => @chat_entry
  end
  
  def add
    @chat_entry = ChatEntry.new
    @chat_entry.connection_id = params[:connection_id]
    @chat_entry.body = params[:body]
    @chat_entry.save
    
    render :json => @chat_entry
  end
end
