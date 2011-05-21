#!/usr/bin/env ruby

begin

  if ARGV.length == 0
    puts "filename is missing!"
    exit
    return
  else
    infile=ARGV[0]
  end

  file = File.new(ARGV[0], "r")
  content = file.read

  counts= {
      :cr => 0,
      :lf => 0,
      :crlf => 0,
      :other => 0
  }

  new=''

  while content.length>0
    tmp = content.partition(/(\r\n|\r|\n)/)
    content = tmp[2]

    if tmp[1] == "\r\n"
      x ="[CRLF]"
      counts[:crlf]=counts[:crlf]+1
    elsif tmp[1] == "\r"
      x ="[CR]"
      counts[:cr]=counts[:cr]+1
    elsif tmp[1] == "\n"
      x = "[LF]"
      counts[:lf]=counts[:lf]+1
    elsif tmp[1] == ""
      x = "[]"
      counts[:other]=counts[:other]+1
    else
      puts "Damn!"
      exit
      return # make pycharm happy
    end

    new=new+"#{tmp[0]}\n"

    #puts "#{tmp[0]}#{x}"

  end
  file.close

  puts "Found: "
  puts " CRLF's: #{counts[:crlf]}"
  puts " LF's  : #{counts[:lf]}"
  puts " CR's  : #{counts[:cr]}"

  if ARGV.length == 2
    outfile = ARGV[1]
    if outfile == '!'
      outfile = infile
    end
    file = File.new(outfile, "wb")
    file.write(new)
    file.close
  end

end
