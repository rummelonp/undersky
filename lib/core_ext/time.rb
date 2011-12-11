class Time
  def to_pretty
    i = (Time.now.to_i - self.to_i).to_i
    case i
    when 0
      'just now'
    when 1..59
      i.to_s + 's'
    when 60..3540
      (i / 60).to_i.to_s + 'm'
    when 3541..82800
      ((i + 99) / 3600).to_i.to_s + 'h'
    when 82801..518400
      ((i + 800) / (60 * 60 * 24)).to_i.to_s + 'd'
    else
      ((i + 180000) / (60 * 60 * 24 * 7)).to_i.to_s + 'w'
    end
  end
end
