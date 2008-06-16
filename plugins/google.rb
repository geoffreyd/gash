require "lib/google"

class GoogleSearch < Actor
  include Google
  
  def actions
    {:google_web => /^g (.*)/}
  end
  
  def google_web(args)
    search = Google.search(args[0])
    puts search
  end
end

