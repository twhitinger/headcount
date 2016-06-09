module MathHelper

  def self.truncate_float(float)
    (float * 1000).floor / 1000.0
  end

end
