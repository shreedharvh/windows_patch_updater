require 'csv'

class WinrmOps
  def initialize(hostname, userid, pwd)
    @hostname = hostname
    @userid = userid
    @pwd = pwd
  end

  def connection
    opts = {
      endpoint: "http://#{@hostname}:5985/wsman",
      user: "cernerasp\\#{@userid}",
      password: @pwd
    }
    conn = WinRM::Connection.new(opts)
  end

  def get_patch_details
    conn = connection
    str = []
    conn.shell(:powershell) do |shell|
      output = shell.run('get-hotfix | select HotFixID,installedon,Description,Caption|ConvertTo-Csv') do |stdout|
        str << stdout.compact
      end
      puts "The script exited with exit code #{output.exitcode}"
    end
    File.open("#{@hostname}_output.csv", 'a') { |f| f.puts str[1..-1] }
  end

  def get_patch_repo
    conn = connection

    file_manager = WinRM::FS::FileManager.new(conn)
    file_manager.upload('./lib/patche_code_repo/PSWindowsUpdate', 'C:\Temp\patche_code_repo\PSWindowsUpdate')
    file_manager.upload('./lib/patche_code_repo/updates_available.ps1', 'C:\Temp\patche_code_repo\updates_available.ps1')

    conn.shell(:powershell) do |shell|
      output = shell.run('C:\Temp\patche_code_repo\updates_available.ps1') do |stdout|
        puts stdout
      end
      puts "The script exited with exit code #{output.exitcode}"
    end
    file_manager.download('C:\Temp\patche_code_repo\output_files\available.csv', 'available.csv')
  end

  def install_patch(inputs)
    conn = connection

    file_manager = WinRM::FS::FileManager.new(conn)
    file_manager.upload('./patche_code_repo/install.ps1', 'C:\Temp\patche_code_repo\install.ps1')

    inputs.each do |node|
      conn.shell(:powershell) do |shell|
        output = shell.run("C:\\Temp\\patche_code_repo\\install.ps1 #{node}") do |stdout|
          puts stdout
        end
        puts "The script exited with exit code #{output.exitcode}"
      end
    end
  end
end