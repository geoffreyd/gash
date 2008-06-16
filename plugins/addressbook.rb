class AddressBook < Action
  require 'appscript'
  
  def actions
    {:person => /^([A-Z][a-z\-_]+ [A-z][a-z\-_]+) ?(\w*)$/}
  end
  
  def person(args)
    
  end
end
