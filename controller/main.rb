# Default url mappings are:
# 
# * a controller called Main is mapped on the root of the site: /
# * a controller called Something is mapped on: /something
# 
# If you want to override this, add a line like this inside the class:
#
#  map '/otherurl'
#
# this will force the controller to be mounted on: /otherurl.
class MainController < Controller
  # the index action is called automatically when no other action is specified
  def index
    @title = 'Patche'
  end

  def status
    @title = 'Patche'
    @nodename = request[:nodename]
    @username = request[:username]
    @password = request[:password]
    if !@nodename.nil? || !@username.nil? || !@password.nil?
      patch_details(@nodename,@username,@password)
    end
  end

  def patch_details(nodename,username,password)
    opsobj = FetchDisplay.new()
    opsobj.import_data_db(@nodename,@username,@password)
    @result = opsobj.display_host_patch(@nodename)
  end

  def report
    @title = 'Patche'
    @nodename = request[:nodename]
    @patchid = request[:patchid]
    @username = request[:username]
    @password = request[:password]
    if !@nodename.nil? || !@username.nil? || !@password.nil?
      patch_installer(@nodename,@username,@password)
    end
    # @title = 'Patche'
    # @nodename = request[:nodename]
    # dbObj = MongoOps.new(@nodename)
    # @result = dbObj.get_collection_data("#{@nodename}_patch_c")
  end

  def installer
    @title = 'Patche'
    @nodename = request[:nodename]
    @patchid = request[:patchid]
    @username = request[:username]
    @password = request[:password]
    if !@nodename.nil? || !@username.nil? || !@password.nil?
      delay
    end
  end

  def delay
    sleep(10)
    @result = "Successfully installed the patch!"
  end
  def patch_installer(nodename,username,password)
    opsobj = FetchDisplay.new()
    @result = opsobj.display_install_patch_details(nodename,username,password)
  end

  # the string returned at the end of the function is used as the html body
  # if there is no template for the action. if there is a template, the string
  # is silently ignored
  def notemplate
    @title = 'Welcome to Ramaze!'
    
    return 'There is no \'notemplate.xhtml\' associated with this action.'
  end
end
