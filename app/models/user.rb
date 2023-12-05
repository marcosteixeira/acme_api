class User < ApplicationRecord
	has_many :hits
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name } },
    allow_blank: true

	def count_hits
		start = Time.now.beginning_of_month
		hits.where('created_at > ?', start).count
  end
end
