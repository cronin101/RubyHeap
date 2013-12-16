require_relative '../bin_heap.rb'

describe Heap::MinHeap do
  it "implements a correctly functioning Min-heap" do
    min_heap = Heap::MinHeap.new
    min_heap.size.should == 0
    min_heap.peek.should == nil

    7.downto(1).each_with_index do |n, i|
      min_heap.push n
      min_heap.size.should == i + 1
      min_heap.peek.should == n
    end

    (1..7).each_with_index do |n, i|
      min_heap.pop.should == n
      min_heap.size.should == 6 - i
    end
  end
end

describe Heap::MaxHeap do
  it "implements a correctly functioning Max-heap" do
    max_heap = Heap::MaxHeap.new
    max_heap.size.should == 0
    max_heap.peek.should == nil

    (1..7).each_with_index do |n, i|
      max_heap.push n
      max_heap.size.should == i + 1
      max_heap.peek.should == n
    end

    7.downto(1).each_with_index do |n, i|
      max_heap.pop.should == n
      max_heap.size.should == 6 - i
    end
  end

end
