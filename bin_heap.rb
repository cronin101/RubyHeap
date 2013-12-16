module Heap
end

class Heap::BinHeap
  def initialize(op=:<)
    @op = op
    @nodeset = [nil]
  end

  def size
    @nodeset.length - 1
  end

  def peek
    @nodeset[1]
  end

  def push(node)
    new_index = (@nodeset << node).length - 1
    heapify_up new_index
  end

  def pop
    result = peek
    if size == 1
      @nodeset.pop
    else # Replace the root of the heap with the last element and heapify-down
      @nodeset[1] = @nodeset.pop
      heapify_down 1
    end
    result
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

  # Given an index, return the index of its parent
  def parent(index)
    parent_level = level(index) - 1
    parent_row_index = (row_index(index) / 2.0).round

    # The position of the parent within the tree
    # = number of preceding nodes + index within parent row
    ((1..parent_level - 1).map { |l| 2**(l - 1) }.reduce(&:+) || 0) + parent_row_index
  end

  # Given an index, return the indices of its children
  def children(index)
    return [] if level(index) == Math.log(size, 2).ceil + 1

    child_row_indices = [1, 0].map { |n| (2 * row_index(index)) - n }
    previous = (1..level(index)).map { |l| 2**(l - 1) }.reduce(&:+)
    child_row_indices.map { |n| previous + n }.select { |n| n <= size }
  end

  # Given an index, return the index with the row that the node sits in
  def row_index(index)
    parent_level = level(index) - 1

    index - ((1..parent_level).map { |l| 2**(l - 1) }.reduce(&:+) || 0)
  end

  # Given an index, find out which level of the complete tree it sits in
  def level(index)
    layer = 0
    n     = 0
    until n >= index
      layer += 1
      n     += 2**(layer - 1)
    end

    layer
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

