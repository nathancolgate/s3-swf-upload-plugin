class Integer
  # 32-bit left shift 
  def js_shl(count)
    v = (self << count) & 0xffffffff
    v > 2**31 ? v - 2**32 : v
  end

  # 32-bit zero-fill right shift  (>>>)
  def js_shr_zf(count)
    self >> count & (2**(32-count)-1)
  end
end