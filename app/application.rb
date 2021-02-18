require 'pry'
class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env) 
    #new instance of Request

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write "Your cart is empty"
      else 
        @@cart.each {|item| resp.write "#{item}\n"}
      end 
    elsif req.path.match(/add/)
      wanted_item = req.params["item"]
      #params is an attribute of the request object
      #calling on the value of the 'item' key
      if @@items.include?(wanted_item)
        @@cart << wanted_item
        resp.write "added #{wanted_item}"
      else 
        resp.write "We don't have that item"
      end

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
