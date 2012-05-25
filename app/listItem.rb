class ListItem
  attr_reader :title, :description
  
  def initialize(dict)
   @title = dict['title'] 
   @description = dict['url_title']
  end
end