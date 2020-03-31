#--------------------------------------------------------------------
# An external iterator for an array.
# Taken from [OLSEN] pp 128-129.
class ArrayIterator

  def initialize(array)
    @array = array
    @index = 0
  end

  def has_next?
    @index < @array.length
  end

  def item
    @array[@index]
  end

  def next_item
    value = @array[@index]
    @index += 1
    value
  end
end

#--------------------------------------------------------------------
# Using external iterators to implement merge sort.
# Taken from [OLSEN] p. 132.
def merge(array1, array2)
  merged = []

  iterator1 = ArrayIterator.new(array1)
  iterator2 = ArrayIterator.new(array2)

  while (iterator1.has_next? and iterator2.has_next?)
    if iterator1.item < iterator2.item
      merged << iterator1.next_item
    else
      merged << iterator2.next_item
    end
  end

  # Pick up the leftovers from array1
  while (iterator1.has_next?)
    merged << iterator1.next_item
  end

  # Pick up the leftovers from array2
  while (iterator2.has_next?)
    merged << iterator2.next_item
  end

  merged
end

a = [4, 8, 15, 16, 23, 42]
b = [1, 2, 4, 9, 9, 9, 10, 11, 20, 21, 22]
c = merge(a, b)
p c
a = []
b = []
c = merge(a, b)
p c
a = [4, 6, 7, 10, 15]
e = a.to_enum

begin
  p e.next
  p e.next
  p e.next
  p e.next
  p e.next
  p e.next
rescue StopIteration
  puts "Finished"
end