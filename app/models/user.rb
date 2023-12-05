class User < ApplicationRecord
	has_many :hits

	def count_hits
		start = Time.now.beginning_of_month
		hits.where('created_at > ?', start).count
  end
end
