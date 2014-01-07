require 'minitest/autorun'
require '../lib/board.rb'

describe "Board", "Board primitive test" do
  describe "new method call" do
    it "should create new Board object" do
      Board.new.must_be_instance_of Board
    end
  end
end