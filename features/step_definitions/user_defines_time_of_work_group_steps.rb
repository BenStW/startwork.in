
Given /^a work group$/ do 
  # Capybara.javascript_driver is selenium

  @work_session = WorkSession.new
  @work_session.tokbox_session_id="asdf"
#  @work_session.generate_tokbox_session
  @work_session.save
end

When /^he visits the page of the work group$/ do 
  visit work_session_calendar_en_path :work_session_id => @work_session.id
  
 # locator = "$('.wc-full-height-column.wc-day-column-inner.day-2')"


 # find("#calendar").click_at(10,10) 
# find("body").click_at(10,10)
  

  
  
 # print page.html
#  t = page.execute_script("return document.title;")
#  puts "title = "+t 
#  $("$('.day-2')).position(); ")
 # //div[@id='calendar']/div/div[2]/table/tbody/tr[2]/td[3]/div
#  p = page.execute_script("$('div[@id='calendar']/div/div[2]/table/tbody/tr[2]/td[3]/div/div[2]/div').trigger('click')")

#  locator = "$('.wc-full-height-column.wc-day-column-inner.day-2')"
 # clickAt(locator, "0,100")
  #ChromeDriver driver = new ChromeDriver();
  # driver.findElement(By.id("someID")).clickAt("25, 25")  
    
#  p = page.execute_script("$('.brand').trigger('click')")
#  print page.html
#  puts "P = "+p  
#  print page.html
end

When /^he selects the day "([^"]*)"$/ do |arg1|
 # @day = DateTime.current + 1.day
end

When /^he selects the hour "([^"]*)"$/ do |arg1|
  #p = page.execute_script("return document.title;")
  #$('.day-2').position(); ")
  #puts "P = "+p

#  puts p
#  @day = DateTime.new(@day.year, @day.month, @day.day, 10,0,0)
#  result = page.evaluate_script('4 + 4')
#  result.should == 8
#  print page.html  
#  page.execute_script("$('body').empty()")  
  #selenium_session.fireEvent("field", "blur")
  #page.execute_script("$('.image_grid').trigger('mouseenter');")
  #page.driver.browser.fireEvent("asdf", "mouseover") 
 # page.execute_script("$('#a').click();")
end

Then /^this definition is saved successfully$/ do
  pending # express the regexp above with the code you wish you had
end