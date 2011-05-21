#!/usr/bin/env ruby

#$KCODE = 'UTF-8'

begin

  if ARGV.length == 0
    puts "filename is missing!"
    exit
    return
  else
    infile=ARGV[0]
  end

  file = File.new(ARGV[0], "rb")
  content = file.read

  counts= {
      :cr => 0,
      :lf => 0,
      :crlf => 0,
      :other => 0
  }

  new=''

  ion=[0x3c,0x3f,0x70,0x68,0x70,0x20].pack('UUUUUU')

  if content[0..5] == ion
    puts "File: "+infile
    puts "Ioncube Encoded PHP"
    puts
    exit
  end
  
  if content =~ /\\0/
    puts "File: "+infile
    puts "Binary File!? (NUL)"
    puts
    exit
  end

  while content.length>0
    tmp = content.partition(/(\r\n|\r|\n)/)
    content = tmp[2]

    omitlf = false

    if tmp[1] == "\r\n"
      #x ="[CRLF]"
      counts[:crlf]=counts[:crlf]+1
    elsif tmp[1] == "\r"
      #x ="[CR]"
      counts[:cr]=counts[:cr]+1
    elsif tmp[1] == "\n"
      #x = "[LF]"
      counts[:lf]=counts[:lf]+1
    elsif tmp[1] == ""
      #x = "[]"
      omitlf = true
      counts[:other]=counts[:other]+1
    else
      puts "Damn!"
      exit
      return # make pycharm happy
    end

    if not omitlf
      new="#{new}#{tmp[0]}\n"
    else
      new="#{new}#{tmp[0]}"
    end

    #puts "#{tmp[0]}#{x}"

  end
  file.close

  if counts[:lf] != 0 and counts[:cr] != 0
    puts "File: "+infile
    puts "Binary File!? (MIX)"
    puts

  elsif counts[:crlf] != 0 or counts[:cr] != 0
    puts "File: "+infile
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
    puts
  else
    #puts "File: "+infile
    #puts "File is clean LF!"
    #puts
  end

end
