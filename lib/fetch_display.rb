# $LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'FileUtils'

class FetchDisplay
  def import_data_db(hostname, userid, password)
    file_path = "#{hostname}_output.csv"
    FileUtils.rm(file_path) if File.exist?(file_path)

    winrmops_obj = WinrmOps.new(hostname, userid, password)
    patch_details = winrmops_obj.get_patch_details

    monogo_obj = MongoOps.new(hostname)
    raise "The file #{file_path} doesnot exist" unless File.exist?(file_path)
    monogo_obj.import_data_collection("#{hostname}_patch_c", file_path)

    FileUtils.rm(file_path)
  end

  def display_host_patch(hostname)
    monogo_obj = MongoOps.new(hostname)
    monogo_obj.get_collection_data("#{hostname}_patch_c")
  end

  def display_install_patch_details(hostname, userid, password)
    file_path = 'available.csv'
    winrmops_obj = WinrmOps.new(hostname, userid, password)
    winrmops_obj.get_patch_repo
    monogo_obj = MongoOps.new(hostname)
    monogo_obj.import_data_collection("#{hostname}_available_patch_c", file_path)
    monogo_obj.get_collection_data("#{hostname}_available_patch_c")
  end

  def filter_on_fixid(hostname, value)
    monogo_obj = MongoOps.new(hostname)
    coll_name = "#{hostname}_patch_c"
    monogo_obj.find_by_fixid(coll_name, value)
  end

  def filter_on_fixtype(hostname, value)
    monogo_obj = MongoOps.new(hostname)
    coll_name = "#{hostname}_patch_c"
    monogo_obj.find_by_fixtype(coll_name, value)
  end

  def filter_on_date(hostname, from_date, to_date = nil)
    monogo_obj = MongoOps.new(hostname)
    coll_name = "#{hostname}_patch_c"
    monogo_obj.find_by_date(coll_name, from_date, to_date)
  end
end
