=begin
Raimbo, the Ruby AIM Bot Object.
Copyright (C) 2003 Kurt M. Dresner (kdresner@rubyforge.org)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
=end

require 'net/http'
require 'uri/common'
require 'cgi'
Net::HTTP.version_1_2
module Google
  def Google.search(inputterms, numresults=1)
    unless inputterms.length > 0
      return "What should I search for?"
    end
    searchterms = URI.escape inputterms
    
    query = "/search?q=#{searchterms}&btnG=Google+Search"
    result = "no results found."
    
    proxy_host = nil
    proxy_port = nil
    
    if(ENV['http_proxy'])
      if(ENV['http_proxy'] =~ /^http:\/\/(.+):(\d+)$/)
        proxy_host = $1
        proxy_port = $2
      end
    end
    http = Net::HTTP.new("www.google.com", 80, proxy_host, proxy_port)
    
    http.start do |http|
      begin
        resp = http.get(query)
        if resp.code.to_i == 200
	  didyoumean = nil
	  results = []
	  resp.body.each("Similar pages</a>") do |l|
	    if not didyoumean and l =~ /Did you mean:.*?<i>(.*?)<\/i>.*?<\/a>/
	      didyoumean = $1
	    end
	    if (l =~ /(<p class="?g"?>)(<a.*?<\/a>)/) and (results.size < numresults)
	      results.push("Hit #{results.size + 1}: #{$2}")
	    end
	  end
	  unless results.empty?
	    result = results.join("\n")
	    if (results.size < numresults) and didyoumean
	      result += " (Did you mean <i>#{didyoumean}</i>?)." 
	    else
	      result += "."
	    end
            # comment out the line below to leave the search terms bolded
            result.gsub!(/<b>|<\/b>/, "")
	  else
	    if didyoumean
	      result += "\n(Did you mean <i>#{didyoumean}</i>?)." 
	    end
	  end
	end
      rescue => e
	result = "Error encountered while talking to Google."
      end
    end
    CGI.unescapeHTML result
  end
end