require 'helper'

describe Toy::Connection do
  uses_constants('User')

  before do
    @debug = Toy.debug
    @logger = Toy.logger
  end

  after do
    Toy.debug = @debug
    Toy.logger = @logger
  end
  

  describe "store" do
    it "should set the default store" do
      Toy.store = RedisStore
      Toy.store.should == RedisStore
    end

    it "including Toy::Store should use the default store, if present" do
      Toy.store = MongoStore
      klass = Class.new { include Toy::Store }
      klass.store.should == MongoStore
    end
  end

  describe "logger" do
    it "should set the default logger" do
      logger = stub
      Toy.logger = logger
      Toy.logger.should == logger
    end

    it "should be an instance of Logger if not set" do
      Toy.logger = nil
      Toy.logger.should be_instance_of(Logger)
    end

    it "should use RAILS_DEFAULT_LOGGER if defined" do
      remove_constants("RAILS_DEFAULT_LOGGER")
      RAILS_DEFAULT_LOGGER = stub

      Toy.logger = nil
      Toy.logger.should == RAILS_DEFAULT_LOGGER
    end
  end

  describe "debug" do
    it "should set debug flag" do
      Toy.debug = true
      Toy.debug.should be_true
    end

    it "should log when creating or updating" do
      logger = stub
      Toy.logger = logger
      Toy.debug = true
      
      logger.should_receive(:debug).twice
      user = User.create
      user.save
      Toy.logger = nil
    end
  end

  describe "key_factory" do
    it "should set the default key_factory" do
      key_factory = stub
      Toy.key_factory = key_factory
      Toy.key_factory.should == key_factory
    end

    it "should default to the UUIDKeyFactory" do
      Toy.key_factory = nil
      Toy.key_factory.should be_instance_of(Toy::Identity::UUIDKeyFactory)
    end
  end
end
