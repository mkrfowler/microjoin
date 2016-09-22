require 'test_helper'

class MicrojoinTest < Minitest::Test
  def elementary_join
    ::Microjoin::([1,2,3], [2,3,4])
  end

  def dense_join
    ::Microjoin::([1,2,3], [[2],[3],[4]])
  end

  def test_that_it_has_a_version_number
    refute_nil ::Microjoin::VERSION
  end

  def test_coherent_on_functions
    assert_raises(ArgumentError) { elementary_join.right.on(left:  -> {}, right: -> {}) { |v| v } }
    assert_raises(ArgumentError) { elementary_join.right.on(right: -> {}) { |v| v } }
    assert_raises(ArgumentError) { elementary_join.right.on(left:  -> {}) { |v| v } }
  end

  def test_elementary_left_join
    joined = elementary_join.left.on { |v| v }
    expected = {
      1 => [ [1], [ ] ],
      2 => [ [2], [2] ],
      3 => [ [3], [3] ]
    }
    assert_equal expected, joined
  end

  def test_elementary_right_join
    joined = elementary_join.right.on { |v| v }
    expected = {
      2 => [ [2], [2] ],
      3 => [ [3], [3] ],
      4 => [ [ ], [4] ]
    }
    assert_equal expected, joined
  end

  def test_elementary_inner_join
    joined = elementary_join.inner.on { |v| v }
    expected = {
      2 => [ [2], [2] ],
      3 => [ [3], [3] ]
    }
    assert_equal expected, joined
  end

  def test_elementary_outer_join
    joined = elementary_join.outer.on { |v| v }
    expected = {
      1 => [ [1], [ ] ],
      2 => [ [2], [2] ],
      3 => [ [3], [3] ],
      4 => [ [ ], [4] ]
    }
    assert_equal expected, joined
  end

  def test_dense_left_join
    joined = dense_join.left.on(left: -> (v) { v }, right: -> (arr) { arr[0] })
    expected = {
      1 => [ [1], [   ] ],
      2 => [ [2], [[2]] ],
      3 => [ [3], [[3]] ]
    }
    assert_equal expected, joined
  end

  def test_dense_right_join
    joined = dense_join.right.on(left: -> (v) { v }, right: -> (arr) { arr[0] })
    expected = {
      2 => [ [2], [[2]] ],
      3 => [ [3], [[3]] ],
      4 => [ [ ], [[4]] ]
    }
    assert_equal expected, joined
  end

  def test_dense_inner_join
    joined = dense_join.inner.on(left: -> (v) { v }, right: -> (arr) { arr[0] })
    expected = {
      2 => [ [2], [[2]] ],
      3 => [ [3], [[3]] ]
    }
    assert_equal expected, joined
  end

  def test_dense_outer_join
    joined = dense_join.outer.on(left: -> (v) { v }, right: -> (arr) { arr[0] })
    expected = {
      1 => [ [1], [   ] ],
      2 => [ [2], [[2]] ],
      3 => [ [3], [[3]] ],
      4 => [ [ ], [[4]] ]
    }
    assert_equal expected, joined
  end
end
