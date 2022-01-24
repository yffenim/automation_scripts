# Create a 3x3 board

# 1 2 3
# 4 5 6
# 7 8 9

# top row: 1 = (1,3), 2 = (2,3), 3 = (3,3)
# middle row: 4 = (1,2), 5 = (2,2), 6 = (3,2)
# last row: 7 = (1,1), 8 = (2,1), 9 = (3,1)

def print(n)
  arr = (1..n*n).to_a
  matrix = []
  arr.each_slice(3) do |x|
    matrix << x
  end
  matrix
end

# redo to create a multiplication board 
#
#
