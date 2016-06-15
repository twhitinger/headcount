module MathHelper

  def self.truncate_float(float)
    unless float.nil?
      if float.nan?
        0
      else
        (float * 1000).floor / 1000.0
      end
    end
  end
end
