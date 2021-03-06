recipe :code_injection do

  process do |potential_files|
    files = potential_files.take_and_map do |file|
        if file =~ %r{^.*\.(swift|m|xib|storyboard|strings|png|jpeg|jpg|plist|json|html|css|js)$}
          cmd = ['/usr/bin/python']
          cmd << File.expand_path('~/.dyci/scripts/dyci-recompile.py').safe_shell_path
          cmd << File.expand_path(file).safe_shell_path

          command = cmd.join(' ')
          puts "Executing #{command}"
          execute(command)
          puts "DYCI: Recompiled #{file}"
          file
        end
      end
  end


  process do |remaining_files|
    remaining_files.take_and_map do |file|
        puts "DYCI: Ignored #{file}"
      file
    end
  end

  startup do
    log "DYCI: Kicker watching for file changes to recompile!"
  end

end

class String
  def safe_shell_path
    "\"#{self}\""
  end
end
