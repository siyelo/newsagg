class String

  if defined?(Encoding) && "".respond_to?(:encode)
    def encoding_aware?
      true
    end
  else
    def encoding_aware?
      false
    end
  end

  # 0x3000: fullwidth whitespace
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   "".blank?                 # => true
  #   "   ".blank?              # => true
  #   "　".blank?               # => true
  #   " something here ".blank? # => false
  #
  def blank?
    # 1.8 does not takes [:space:] properly
    if encoding_aware?
      self !~ /[^[:space:]]/
    else
      self !~ NON_WHITESPACE_REGEXP
    end
  end
end
