require File.dirname(__FILE__) + '/../spec_helper'

describe Message do
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    @sender    = people(:quentin)
    @recipient = people(:aaron)
    @message   = new_message
  end
  
  it "should be valid" do
    @message.should be_valid
  end
  
  it "should have the right sender" do
    @message.sender.should == @sender
  end
  
  it "should have the right recipient" do
    @message.recipient.should == @recipient
  end
  
  it "should require content" do
    new_message(:content => "").should_not be_valid
  end
  
  it "should not be too long" do
    too_long_content = "a" * (Message::MAX_CONTENT_LENGTH + 1)
    new_message(:content => too_long_content).should_not be_valid
  end

  it "should be able to trash messages as sender" do
    @message.trash(@message.sender)
    @message.should be_trashed(@message.sender)
    @message.should_not be_trashed(@message.recipient)
  end
  
  it "should be able to trash message as recipient" do
    @message.trash(@message.recipient)
    @message.should be_trashed(@message.recipient) 
    @message.should_not be_trashed(@message.sender)
  end
  
  it "should description not be able to trash as another user" do
    kelly = people(:kelly)
    kelly.should_not == @message.sender
    kelly.should_not == @message.recipient
    lambda { @message.trash(kelly) }.should raise_error(ArgumentError)
  end
  
  it "should untrash messages" do
    @message.trash(@message.sender)
    @message.should be_trashed(@message.sender)
    @message.untrash(@message.sender)
    @message.should_not be_trashed(@message.sender)
  end
  
  it "should handle replies" 
  
  it "should mark messages as read" 



  private

    def new_message(options = { :sender => @sender, :recipient => @recipient })   
      Message.new({ :content   => "Lorem ipsum" }.merge(options))
    end
  
    # TODO: remove this (?)
    def create_message(sender = @sender, recipient = @recipient)   
      Message.create(:content   => "Lorem ipsum",
                     :sender    => sender,
                     :recipient => recipient)
    end
end