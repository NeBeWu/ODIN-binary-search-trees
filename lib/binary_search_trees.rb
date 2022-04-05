# frozen_string_literal: true

# Node class models a node which stores a value and has 2 pointers to other
# nodes. It also has a comparison method to compare nodes values.
class Node
  include Comparable

  attr_accessor :value, :left_node, :right_node

  def initialize(value = nil)
    @value = value
    @left_node = nil
    @right_node = nil
  end

  def <=>(other)
    @value <=> other.value
  end
end

# Tree class models a rooted (unique attribute) binary search tree with initialization from a
# sorted unique array. It also has insertion and delete methods.
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?

    array = array.uniq.sort

    half = array.size / 2
    p root = Node.new(array[half])

    root.left_node = build_tree(array[...half])
    root.right_node = build_tree(array[half + 1..])

    root
  end

  def insert(value, node = @root)
    return nil if value == node.value

    if value < node.value
      node.left_node.nil? ? node.left_node = Node.new(value) : insert(value, node.left_node)
    else
      node.right_node.nil? ? node.right_node = Node.new(value) : insert(value, node.right_node)
    end
  end

  def delete(value, node = @root)
    return nil if node.nil?

    if value < node.value
      node.left_node = delete(value, node.left_node)
    elsif value > node.value
      node.right_node = delete(value, node.right_node)
    else
      node = remove(node)
    end

    node
  end

  # Auxiliar method which handles the (re)moving part of the delete method.
  def remove(node)
    return node.right_node if node.left_node.nil?
    return node.left_node if node.right_node.nil?

    min_node = node.right_node

    min_node = min_node.left_node while min_node.left_node

    node.value = min_node.value
    node.right_node = delete(node.value, node.right_node)

    node
  end

  # Printing method to visualize the tree (adapted to my code). Thanks fellow student!
  def to_s(node = @root, prefix = '', is_left = true)
    to_s(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    to_s(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end
end
