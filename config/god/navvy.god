God.watch do |w|
  w.name     = "navvy"
  w.interval = 30.seconds # default
  w.start    = "rake navvy:work"
  w.dir      = File.dirname(__FILE__)
  w.log      = File.join(File.dirname(__FILE__), '..', '..', 'log', 'navvy.log')

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end
  
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.notify = {:contacts => ['developers'], :priority => 1, :category => 'photostre.am'}
      c.running = false
    end
  end
end