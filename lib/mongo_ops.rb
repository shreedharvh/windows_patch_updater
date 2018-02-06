class MongoOps
  def initialize(hostname)
    @host = hostname
    @client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'shipit')
  end

  def get_collection_data(coll_name)
    collection_name = @client[coll_name]
    collection_name.find().map{ |row| row.to_hash }
  end

  def import_data_collection(coll_name, file_path)
    cmd  = "mongoimport -d shipit -c #{coll_name} --type csv --file #{file_path} --headerline --ignoreBlanks --drop"
    `#{cmd}`
  end

  def find_by_fixid(coll_name, value)
    find(coll_name,type = 'hotfix',value)
  end

  def find_by_fixtype(coll_name,value)
    find(coll_name,type = 'fixtype',value)
  end

  def find_by_date(coll_name,from_date,to_date = nil)
    collection_name = @client[coll_name]
    if !to_date
      res = collection_name.find({"InstalledOn":{"$regex":"#{from_date}*"}})
    else
      res =  collection_name.find({"InstalledOn":{ "$gte":"#{from_date} 00:00:00 AM" , "$lt":"#{to_date} 00:00:00 AM" }})
    end
    res.map{|row| row.to_hash}
  end

  def find(coll_name,type,value)
    id = "HotFixID" if type == 'hotfix'
    id = "Description" if type == 'fixtype'

    collection_name = @client[coll_name]
    collection_name.find({"#{id}":value}).map { |row| row.to_hash }
  end
end