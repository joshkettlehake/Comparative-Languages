# Joshua Kettlehake
# Project 5

# Implementation of binary search tree (BST) functionality
class BST
  # To create setters and getters of variables root, size and compare_method
  attr_accessor :root, :size, :compare_method
  # Initializes BST variables
  # Checks if new BST can be created
  # Returns a new (empty) BST
  def initialize(&block)
    @root = nil
    @size = 0
    @compare_method = nil
    # Checks if there is block of code given to BST
    # If block is given, then block used compare two objects
    # Else, spaceship operator to compare two objects in compareVal
    if (block_given?)
      @compare_method = block
    else
      @compare_method = method(:compareVal)
    end
  end

  # Compares two objects with spaceship operator
  # Returns -1 if val1 is less than val2
  #          0 if val1 is equal to val2
  #         +1 if val1 is greater than val2
  def compareVal(val1, val2)
    val1 <=> val2
  end

  # Defines each node in binary tree
  # Returns new node in BST
  class Node
    # Creates setters and getters for value, left, and right
    attr_accessor :value, :left, :right
    # Default constructor of Node class
    # Returns nothing
    def initialize(value)
      # Initializes value and sets left and right to null
      @value = value
      @left = nil
      @right = nil
    end
  end

  # Adds new item to BST
  # Compares values to determine left or right
  # Returns nothing
  def add(value)
    if @root == nil
      @root = Node.new(value)
    else
      currentNode = @root
      previousNode = @root
      # Loops through BST to determine where add node
      while (currentNode != nil)
        # Sets previousNode to currentNode to check value
        previousNode = currentNode
        # Uses compare_method to compare two values
        if (@compare_method.call(value, currentNode.value) == -1)
          currentNode = currentNode.left
        else
          currentNode = currentNode.right
        end
      end
      # Uses compare_method to compare two values
      if (@compare_method.call(value, previousNode.value) == -1)
        previousNode.left = Node.new(value)
      else
        previousNode.right = Node.new(value)
      end
    end
    # Increases size of BST since new node created
    @size += 1
  end

  # Determines if BST is empty
  # Returns true if BST is empty
  #         false if BST is not empty
  def empty?
    # If @root is set to null, return true
    # Else, return false
    if(@root == nil)
      return true
    else
      return false
    end
  end

  # Determines if the value is in BST
  # Returns true if BST contains the value
  #         false otherwise.
  def include?(item)
    # Sets currentNode and previousNode to top of BST which is root
    currentNode, previousNode = @root
    # Determines if BST contains item or not
    while(currentNode != nil)
      previousNode = currentNode
      # Uses compare_method to compare two values
      if(@compare_method.call(item, currentNode.value) == -1)
        # If item equal to currentNode's value, return true
        # Else, set currentNode to the left of currentNode
        if(@compare_method.call(item, currentNode.value) == 0)
          return true
        else
          currentNode = currentNode.left
        end
      else
        # If item is equal to currentNode's value, return true
        # Else, set currentNode to the right of currentNode
        if(@compare_method.call(item, currentNode.value) == 0)
          return true
        else
          currentNode = currentNode.right
        end
      end
    end
    return false
  end

  # Returns the size of BST
  def size
    return @size
  end

  # Executes inorder traversal of the tree recursively
  # Returns inorder traversal of tree
  def each_inorder(currentNode = @root, &block)
    # Checks if current node is null
    if(currentNode != nil)
      # Recursively passing left side of currentNode
      each_inorder(currentNode.left, &block)
      # passes item to block using yield
      yield currentNode.value
      # Recursively passing right side of currentNode
      each_inorder(currentNode.right, &block)
    end
    return
  end

  # Executes in-order traversal of the tree passing each item found to block
  # Values returned by block are collected into new BST, which is returned
  # &block == address of block
  def collect_inorder(&block)
    # Creates new BST to add values returned by block
    otherBST = BST.new
    collect_inorder_helper(otherBST, &block)
    return otherBST
  end

  # Recursive helper method of collect_inorder
  # Executes inorder traversal of the tree, passing each item to block and adding it to otherBST
  # Returns nothing
  # &block == address of the block
  def collect_inorder_helper(otherBST, currentNode = @root, &block)
    # If currentNode not equal to null, keep recursing through original BST adding each node to otherBST using inorder traversal
    if(currentNode != nil)
      # Passing otherBST, node on left, and &block
      collect_inorder_helper(otherBST, currentNode.left, &block)
      # Add currentNode's value to otherBST and pass it to block
      otherBST.add(yield currentNode.value)
      # Passing otherBST, node on right, and &block
      collect_inorder_helper(otherBST, currentNode.right, &block)
    end
    return
  end

  # Returns a sorted array of all elements in BST
  def to_a
    # Use compare_method to check if size is 0
    # If size is 0, then return [] for empty array
    # Else, print open [ and close ], then call to_helper to print items in BST
    if(@compare_method.call(@size, 0) == 0)
      return "[]"
    else
      print "["
      to_a_helper
      print "]"
    end
  end

  # Prints items in BST using inorder traversal
  # Returns nothing
  def to_a_helper(currentNode = @root)
    if(currentNode != nil)
      # Passing node that is on left side
      to_a_helper(currentNode.left)
      # Print currentNode's value
      print "#{currentNode.value} "
      # Passing node that is on right side
      to_a_helper(currentNode.right)
    end
  end

  # Returns new BST that is a deep copy of original tree
  def dup
    # Creates new BST to hold deep copy of original BST
    copyBST = BST.new
    if(@root != nil)
      dup_helper(copyBST)
    end
    return copyBST
  end

  # Helper method of dup
  # Allows deep copy of original BST
  def dup_helper(copyBST, currentNode = @root)
    # If currentNode is not equal to null, then perform recursion using inorder traversal copying node values into copyBST
    if(currentNode != nil)
      # Recursion through left side of tree
      dup_helper(copyBST, currentNode.left)
      # Add the value of original currentNode to copyBST for deep copy
      copyBST.add(currentNode.value)
      # Recursion through right side of tree
      dup_helper(copyBST, currentNode.right)
    end
  end
end
