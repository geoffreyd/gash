require 'appscript'

class AddressBook < Actor
  include Appscript
  attr :justify, true
  attr :filter, true
  
  def initialize 
    @justify = 20
    @filter = false
  end

  def actions
    {:person => /^([A-Z][a-z\-_]* [A-z][a-z\-_]*) ?([\w ]*)$/}
  end
  
  def person(args)
    initialize
    puts "Searching Address Book for #{args[0]}"
    
    @filter = args[1].length > 0 ? args[1] : false
    
    ab = app("Address Book")
    ab.people[its.name.contains(args[0])].get.each {|person| 
      puts "Details for: #{person.name.get}" + 
        (person.nickname.get.to_s != "missing_value" ? " (#{person.nickname.get})" : "")
      
      # output phone details
      # TODO - make this work:
      # output_values(person, :phone, /phone/, "Phone")
      person.phones.get.each do |phone|
        puts "Phone (#{phone.label.get}):".ljust(@justify) + phone.value.get
      end if @filter == false or @filter =~ /phone|Phone|ph/
      
      
      # output email details
      person.emails.get.each do |email|
        puts "Email (#{email.label.get}):".ljust(@justify) + email.value.get
      end if @filter == false or @filter =~ /email/
      
      # output addresses details
      person.addresses.get.each do |addr|
        puts "Address (#{addr.label.get}):".ljust(@justify) + 
          addr.formatted_address.get.gsub(/\n/, "\n"+ " "*@justify)
      end if @filter == false or @filter =~ /addr/
      
    }
  end
  
  def output_values(person, attrName, filter, outname)
    person.__send__(attrName).get.each do |attr|
      puts "#{outname} (#{attr.label.get}):".ljust(@justify) + attr.value.get
    end if @filter == false or @filter =~ filter
  end
  
end
