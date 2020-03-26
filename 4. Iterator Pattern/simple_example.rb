def make_generator(n)
  Enumerator.new do |yielder|
    yielder << n
    n += 1
    yielder << n
    n += 10
    yielder << n
  end
end

def pow2(n)
  Enumerator.new do |yielder|
    n.times do |i|
      yielder << 2 ** i
    end
  end
end

def pow2_infinity
  Enumerator.new do |yielder|
    n = 1
    loop do
      yielder << n
      n *= 2
    end
  end
end

g1 = make_generator(5)
p g1.to_a

g2 = pow2(5)
p g2.to_a

g3 = pow2_infinity
p g3.take(10)