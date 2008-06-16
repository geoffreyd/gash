class Actor
  
  
  def initialize
    
  end

  def Actor.children
    @children ||= []
  end

  def self.inherited(subclass)
    super
  ensure
    children << subclass.new()
  end

  # Return a hash of redex's that your actor will respond to.
  # ie. {"ecgho" => /^echo/, "google" => /g|google/ }
  def actions
    []
  end

end