class Session < ActiveRecord::Base
  def self.sweep(time = 5.minutes)
    if time.is_a?(String)
      time = time.split.inject { |count, unit| count.to_i.send(unit) }
    end

    delete_all "updated_at < '#{time.ago.to_s(:db)}' OR created_at < '#{1.day.ago.to_s(:db)}'"
  end
end
