require File.dirname(__FILE__) + '/spec_helper'
require "securerandom"

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

describe "Upload" do
  def setup_db
    ActiveRecord::Schema.define(:version => 1) do
      create_table :photos do |t|
        t.column :image, :string
        t.column :image_file_name, :string
        t.column :image_small_file_name, :string
      end
    end
  end
  
  def drop_db
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
  
  class PhotoUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    # process :store_file_name
    version :small do
      process :resize_to_fill => [120, 120]
      # process :store_file_name
    end
  end

  class Photo < ActiveRecord::Base
    mount_uploader :image, PhotoUploader
  end
  
  
  before :all do
    setup_db
  end
  
  after :all do
    drop_db
  end
  
  it "should save" do
    f = File.open("spec/fixtures/big.jpg")
    @photo = Photo.create(:image => f)
    @photo.id.should_not == nil
    puts "----- #{@photo.inspect}"
    puts "----- #{@photo.image.url}"
    puts "----- #{@photo.image.small.url}"
    @photo.image_file_name.length.should_not == ""
    @photo.image_small_file_name.should_not == ""
    @photo.image_file_name.should_not == @photo.image_small_file_name
    
  end
end