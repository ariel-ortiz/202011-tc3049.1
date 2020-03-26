def make_generator(n)
  Enumerator.new do |yielder|
    yielder << n
    n += 1
    yielder << n
    n += 10
    yielder << n
  end
end

g = make_generator(5)
puts g.next  # 5
puts g.next  # 6
puts g.next  # 16
puts g.next  # StopIteration