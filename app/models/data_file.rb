class DataFile < ActiveRecord::Base
  def self.save(upload,name,directory, inputFile)
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(inputFile.read) }
  end
end