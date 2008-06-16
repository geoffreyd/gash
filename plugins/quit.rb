class Quit < Actor
  def actions
    {:quit_app => /^([qQ]|quit) ?(.*)$/}
  end
  
  def quit_app(args)
    exit
  end
  
end