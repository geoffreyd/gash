class Echo < Actor
  def actions
    {:echo => /^(e|E) (.*)/}
  end
  
  def echo(args)
    if args[0][/e/]
      puts args[1]
    else
      puts "Args are:" + args.join(", ")
    end
  end
end