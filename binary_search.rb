class Node
    def initialize(data='nil', left='nil', right='nil')
        @data = data
        @left = left
        @right = right
    end

    attr_accessor :data, :left, :right
end

class Queue
    def initialize
        @arr = []
    end

    def enqueue(element)
        @arr.push(element)
    end

    def dequeue
        element = @arr[0]
        @arr.shift()
        return element
    end

    def get_first
        return @arr[0]
    end

    def empty?
        return @arr.empty?
    end
end

def sort(arr)
    mid = arr.length / 2
    left = arr[0, mid]
    right = arr[mid..-1]
    sort(left) if left.length > 1
    sort(right) if right.length > 1
    sorted = []
    l = 0
    r = 0
    while l < left.length && r < right.length
        if left[l] > right[r]
            sorted << left[l]
            l += 1
        else
            sorted << right[r]
            r += 1
        end
    end
    if l >= left.length
        sorted << right[r..-1]
    else
        sorted << left[l..-1]
    end
    return sorted
end

class BTree
    def initialize
        @root = Node.new
    end

    attr_accessor :root

    def build_tree(data, start, finish)
        data = data.uniq
        data = sort(data)
        return nil if start > finish
        mid = data.length / 2
        root = Node.new(data[mid])
        root.left = build_tree(data, start, mid - 1)
        root.rigth = build_tree(data, mid + 1, finish)
        return root
    end

    def insert(data)
        tmp = root
        while tmp.left != nil || tmp.right != nil
            if tmp.data > data
                tmp = tmp.left
            else
                tmp = tmp.right
            end
            if tmp.data > data && tmp.left == nil
                tmp.left = Node.new(data)
            elsif tmp.data <= data && tmp.right == nil
                tmp.rigth = Node.new(data)
            end
        end
    end

    def delete(data)
        return root if root == nil
        prev = nil
        curr = root
        while curr != nil && curr.data != data
            if curr.data > data
                curr = curr.left
            else
                curr = curr.right
            end
        end
        return root if curr == nil
        if curr.left == nil
            return curr.right
        elsif curr.rigth == nil
            return curr.left
        end
        if curr.right.left != nil
            prev = curr.right.left
            prev.right = curr.right
            return prev
        elsif curr.left.right != nil
            prev = curr.left.right
            prev.left = curr.left
            return prev
        else
            prev = curr.right
            prev.left = curr.left
            return prev
        end
    end

    def find(value)
        tmp = root
        while tmp != nil && tmp.data != value
            if tmp.data > value
                tmp = tmp.left
            else
                tmp = tmp.right
            end
        end
        return tmp if tmp.data == value
        puts 'value not found'
        return nil
    end

    def level_order(r)
        return if r == nil
        queue = Queue.new
        queue.enqueue(r)
        until queue.empty?
            node = queue.get_first
            yield node
            queue.enqueue(node.left) if node.left != nil
            queue.enqueue(node.right) if node.right != nil
            queue.dequeue
        end
    end

    def inorder(r)
        return if r == nil
        curr = r
        inorder(r.left)
        yield r
        inorder(r.right)
    end

    def preorder(r)
        return if r == nil
        curr = r
        yield r
        preorder(r.left)
        preorder(r.right)
    end

    def postorder(r)
        return if r == nil
        curr = r
        yield r
        postorder(r.left)
        postorder(r.right)
    end

    def depth(node)
        tmp = root
        counter = 0
        while tmp != nil && tmp == node
            if tmp.data > node.data
                tmp = tmp.left
            else
                tmp = tmp.right
            end
            counter += 1
        end
        return 0 if tmp == nil
        return counter
    end

    def height(node)
        children = 0
        preorder(node) {children += 1}
        h = Math.log2(children + 1).ceil
        return h
    end

    def balanced?
        level_order(root) do |node|
            if node.left == nil && height(node) > 1
                return false
            elsif node.right == nil && height(node) > 1
                return false
            end
        end
        return true
    end

    def rebalance
        arr = []
        level_order(root) {|node| arr << node}
        build_tree(arr)
    end
end