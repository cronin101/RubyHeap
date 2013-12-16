require_relative '../bin_heap.rb'
include Heap

describe BinHeap do
  it "can be initialized" do
    min_heap = BinHeap.new
    min_heap.size.should == 0
    min_heap.peek.should == nil
  end

  it "can have elements added via #push" do
    min_heap = BinHeap.new
    7.downto(1).each_with_index do |n, i|
      min_heap.push n
      min_heap.size.should == i + 1
      min_heap.peek.should == n
    end
  end

  it "can have elements retrieved via #pop" do
    min_heap = BinHeap.new
    min_heap.instance_eval { @nodeset = [nil, 1, 2, 3, 4, 5, 6, 7] }
    (1..7).each_with_index do |n, i|
      min_heap.pop.should == n
      min_heap.size.should == 6 - i
    end
  end
end

describe MinHeap do
  it "correctly functions as a MinHeap" do
    input = [6, 5, 3, 2, 1, 6, 7, 8, 9, 0, 4]
    min_heap = MinHeap.new
    input.each { |n| min_heap.push n }
    result = []
    input.length.times { result << min_heap.pop }
    result.should == input.sort
  end
end

describe MaxHeap do
  it "correctly functions as a maxHeap" do
    input = [6, 5, 3, 2, 1, 6, 7, 8, 9, 0, 4]
    max_heap = MaxHeap.new
    input.each { |n| max_heap.push n }
    result = []
    input.length.times { result << max_heap.pop }
    result.should == input.sort.reverse
  end
end

