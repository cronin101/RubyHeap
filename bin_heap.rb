module Heap
end

class Heap::BinHeap
  # Build a heap structure by converting a given array.
  # @array: The collection of elements to heapify
  # Usage: Heap::BinHeap.heapify(test_scores)
  # Returns: Heap::BinHeap instance with @nodeset of heapified input
  # Complexity: O(n)
  def self.heapify(array, op = :<) # I could write this sensibly but... LOLRUBY
    (new op).tap do |h|
      h.instance_eval { @nodeset.concat array }
      (h.size / 2.0).floor.downto(1) { |i| h.send(:heapify_down, i) }
    end
  end

  # Build an empty heap structure.
  # Note: If you already have a collection of elements, it is more efficient to heapify
  #   instead of creating an empty heap and pushing each item consecutively.
  # @op?: The comparator to use, :< creates a MinHeap and :> creates a MaxHeap.
  # Usage: Heap::BinHeap.new
  # Returns: Heap::BinHeap instance with empty @nodeset.
  # Complexity: O(1)
  def initialize(op = :<)
    @op = op
    @nodeset = [nil]
  end

  # Query the number of elements contained within the heap structure.
  # Usage: heap.size
  # Returns: The number of user-inputted heap elements in the @nodeset.
  # Complexity: O(1)
  def size
    @nodeset.length - 1
  end

  # Query the root of the heap. In a MinHeap this will be the smallest element,
  #   in a MaxHeap it will be the largest.
  # Usage: heap.peek
  # Returns: The root element's value without altering the heap.
  # Complexity: O(1)
  def peek
    @nodeset[1]
  end

  # Insert a new element into the heap. The heap's properties are maintained.
  # @node: The element to insert.
  # Usage: heap.push 6
  # Returns: The BinHeap instance, TODO: Fix this to indicate duplicity?
  # Complexity: O(log n)
  def push(node)
    new_index = (@nodeset << node).length - 1
    heapify_up new_index
    self
  end

  # Retrieve the root element from the heap. The heap's properties are maintained.
  # Usage: heap.pop
  # Returns: The retrieved root element. This will be the largest element in a MaxHeap,
  #   or the smallest element in a MinHeap.
  # Complexity: O(log n)
  def pop
    peek.tap do |result|
      last = @nodeset.pop
      unless size.zero? # Replace the root of the heap with the last element and heapify-down
        @nodeset[1] = last
        heapify_down 1
      end
    end
  end

  # Draw a Graphviz plot of the BinHeap. Elements in the heap are represented by nodes,
  #   and the tree-structure is displayed via edges.
  # Usage: heap.visualize
  # Returns: Writes to './bin_heap.dot'. TODO: Fix this to make it nicer.
  # Complexity: O(n)
  def visualize
    require 'rviz'
    g = Rviz::Graph.new
    frontier = [1] # Add nodes to graph via BFS, starting with root
    until frontier.empty?
      index = frontier.shift
      unless index == 1 # Connect to parent unless root
        g.add_edge(@nodeset[parent index].to_s, '', @nodeset[index], '')
      end
      frontier.concat(children index)
    end
    g.output('bin_heap.dot')
    `dot -o bin_heap.png -Tpng bin_heap.dot`
  end

  private

  def compare(a, b)
    a.send(@op, b)
  end

  def heapify_up(index)
    return if index == 1 # Root of the tree has no parent
    p_index = parent index
    parent, child = [p_index, index].map { |i| @nodeset[i] }
    if compare(parent, child)
      return # Stop if parent and child are in correct order
    else     # Swap the child with the parent and recurse on new parent
      @nodeset[p_index], @nodeset[index] = @nodeset[index], @nodeset[p_index]
      heapify_up p_index
    end
  end

  def heapify_down(index)
    return if (nodes = children index).empty? # Leaves have no children

    pivot = if @op == :<
      nodes.min_by { |i| @nodeset[i] }
    else
      nodes.max_by { |i| @nodeset[i] }
    end

    if compare(@nodeset[index], @nodeset[pivot])
      return # Stop if parent and child are in correct order
    else     # Swap the child with the parent and recurse on new child
      @nodeset[pivot], @nodeset[index] = @nodeset[index], @nodeset[pivot]
      heapify_down pivot
    end
  end

  def parent(index)   # Index -> Parent Index
    (index / 2).floor
  end

  def children(index) # Index -> Children Index
    return [] if Math.log(index, 2).ceil == Math.log(size, 2).ceil
    [0, 1].map { |n| (2 * index) + n }.select { |n| n <= size }
  end
end

module Heap
  class MinHeap < BinHeap
    def initialize
      super(:<)
    end
  end

  class MaxHeap < BinHeap
    def initialize
      super(:>)
    end
  end
end
