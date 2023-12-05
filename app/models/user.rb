class User < ApplicationRecord
	has_many :hits
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name } },
    allow_blank: true

	def count_hits
    Time.use_zone(timezone) do
      start = Time.zone.now.beginning_of_month
      end_time = Time.zone.now.end_of_month
      hits.where(created_at: start..end_time).count
    end
  end
end
